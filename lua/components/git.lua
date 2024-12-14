

local current_git_branch = ''
local current_git_dir = ''
local branch_cache = {}
local active_bufnr = '0'
local sep = package.config:sub(1, 1)
local file_changed = vim.loop.new_fs_event()
local git_dir_cache = {}

local M = {}

M.stbufnr = function()
  return vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0)
end

M.is_activewin = function()
  return vim.api.nvim_get_current_win() == vim.g.statusline_winid
end

-- Configuration table with default values
local config = {
  enabled = true,
  icon = "",
}

-- Setup function to merge user configuration
function M.setup(user_config)
  config = vim.tbl_deep_extend("force", config, user_config or {})
end

-- Function to read the current git branch from the HEAD file
local function get_git_head(head_file)
  local f_head = io.open(head_file)
  if f_head then
    local HEAD = f_head:read()
    f_head:close()
    local branch = HEAD:match('ref: refs/heads/(.+)$')
    if branch then
      current_git_branch = branch
    else
      current_git_branch = HEAD:sub(1, 6)
    end
  end
end

-- Function to update the current git branch based on file changes
local function update_branch()
  active_bufnr = tostring(vim.api.nvim_get_current_buf())
  file_changed:stop()
  local git_dir = current_git_dir
  if git_dir and #git_dir > 0 then
    local head_file = git_dir .. sep .. 'HEAD'
    get_git_head(head_file)
    file_changed:start(
      head_file,
      {},
      vim.schedule_wrap(function()
        update_branch()
      end)
    )
  else
    current_git_branch = ''
  end
  branch_cache[vim.api.nvim_get_current_buf()] = current_git_branch
end

-- Function to update the current git directory
local function update_current_git_dir(git_dir)
  if current_git_dir ~= git_dir then
    current_git_dir = git_dir
    update_branch()
  end
end

-- Function to find the .git directory in the project root
function M.find_git_dir(dir_path)
  local git_dir = vim.env.GIT_DIR
  if git_dir then
    update_current_git_dir(git_dir)
    return git_dir
  end

  local file_dir = dir_path or vim.fn.expand('%:p:h')
  local root_dir = file_dir

  while root_dir do
    if git_dir_cache[root_dir] then
      git_dir = git_dir_cache[root_dir]
      break
    end

    local git_path = root_dir .. sep .. '.git'
    local git_file_stat = vim.loop.fs_stat(git_path)

    if git_file_stat then
      if git_file_stat.type == 'directory' then
        git_dir = git_path
      elseif git_file_stat.type == 'file' then
        local file = io.open(git_path)
        if file then
          git_dir = file:read()
          git_dir = git_dir and git_dir:match('gitdir: (.+)$')
          file:close()
        end

        if git_dir and git_dir:sub(1, 1) ~= sep and not git_dir:match('^%a:.*$') then
          git_dir = git_path:match('(.*).git') .. git_dir
        end
      end

      if git_dir then
        local head_file_stat = vim.loop.fs_stat(git_dir .. sep .. 'HEAD')
        if head_file_stat and head_file_stat.type == 'file' then
          break
        else
          git_dir = nil
        end
      end
    end

    root_dir = root_dir:match('(.*)' .. sep .. '.-')
  end

  git_dir_cache[file_dir] = git_dir

  if dir_path == nil then
    update_current_git_dir(git_dir)
  end

  return git_dir
end

function M.in_git_repo()
  return current_git_dir ~= nil and current_git_dir ~= ''
end


-- Function to get the current branch name, with optional user configuration for display purposes.
function M.get_branch(user_config)
    if not config.enabled or not M.in_git_repo() then return "" end

  -- Merge user configuration for this call (if needed)
  local cfg = vim.tbl_deep_extend("force", user_config, user_config or {})

  -- Update the Git directory based on the actual buffer being used.
  if vim.g.actual_curbuf ~= nil and active_bufnr ~= vim.g.actual_curbuf then
    M.find_git_dir()
  end

  -- Get the current branch name and prepend the icon (if configured).
  local branch = current_git_branch
  return branch ~= "" and (cfg.icon .. " " .. branch) or ""
end

-- Function to display Git branch
M.git_branch = function()
  if not M.in_git_repo() then
    return ""
  end

  local branch = M.get_branch({ icon = "" })
  if branch == "" then
    return ""
  end

  return " " .. branch
end

-- Function to display Git status (added, modified, removed files)
M.git_status = function()
  if not M.in_git_repo() then
    return ""
  end

  -- Get git status
  local git_status = vim.fn.system("git status --porcelain")
  local added, changed, removed = 0, 0, 0

  for line in git_status:gmatch("[^\r\n]+") do
    local status = line:sub(1, 2)
    if status:match("A") then
      added = added + 1
    elseif status:match("M") or status:match("R") then
      changed = changed + 1
    elseif status:match("D") then
      removed = removed + 1
    end
  end

  local status_string = ""
  if added > 0 then status_string = status_string .. "  " .. added end
  if changed > 0 then status_string = status_string .. "  " .. changed end
  if removed > 0 then status_string = status_string .. "  " .. removed end

  return status_string
end



-- Initialize the Git branch tracking by finding the Git directory.
function M.init_git_branch()
  M.find_git_dir()

  -- Create an autocommand to find the Git directory when entering a buffer.
  vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
      M.find_git_dir()
    end,
  })
end

return M

