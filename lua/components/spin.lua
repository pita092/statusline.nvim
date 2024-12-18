local M = {}

local spinner_frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
local spinner_index = 1
local spinner_timer = nil
local is_spinning = false

local function update_spinner()
  spinner_index = (spinner_index % #spinner_frames) + 1
  vim.schedule(function()
    vim.api.nvim_command("redrawstatus")
  end)
end

local function start_spinner()
  if spinner_timer == nil then
    spinner_timer = vim.loop.new_timer()
    spinner_timer:start(0, 100, vim.schedule_wrap(update_spinner))
    is_spinning = true
  end
end

local function stop_spinner()
  if spinner_timer then
    spinner_timer:stop()
    spinner_timer:close()
    spinner_timer = nil
    is_spinning = false
  end
end

function M.get_spinner()
  if is_spinning then
    return spinner_frames[spinner_index]
  else
    return ""  -- Return an empty string when not spinning
  end
end

local function check_lsp_status()
  local clients = vim.lsp.get_active_clients()
  local loading = false

  for _, client in ipairs(clients) do
    local messages = vim.lsp.util.get_progress_messages()
    for _, msg in ipairs(messages) do
      if msg.name == client.name and msg.progress then
        loading = true
        break
      end
    end
    if loading then break end
  end

  if loading and not is_spinning then
    start_spinner()
  elseif not loading and is_spinning then
    stop_spinner()
  end
end

function M.setup()
  -- Check LSP status periodically
  vim.api.nvim_create_autocmd({"BufEnter", "CursorHold", "CursorHoldI"}, {
    callback = check_lsp_status,
  })

  -- Check LSP status when LSP attaches to a buffer
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = check_lsp_status,
  })
end

return M
