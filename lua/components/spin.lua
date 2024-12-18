-- Save this as lsp_status.lua in your Neovim config directory

local M = {}

M.state = {
  lsp_msg = "",
  spinner_index = 1
}

local spinners = { "", "", "", "󰪞", "󰪟", "󰪠", "󰪢", "󰪣", "󰪤", "󰪥" }

local function update_spinner()
  M.state.spinner_index = (M.state.spinner_index % #spinners) + 1
  vim.cmd.redrawstatus()
end

local spinner_timer = nil

local function start_spinner()
  if spinner_timer == nil then
    spinner_timer = vim.loop.new_timer()
    spinner_timer:start(0, 100, vim.schedule_wrap(update_spinner))
  end
end

local function stop_spinner()
  if spinner_timer then
    spinner_timer:stop()
    spinner_timer:close()
    spinner_timer = nil
  end
end

local function update_lsp_progress(args)
  local data = args.data.params.value
  local progress = ""

  if data.kind == "begin" then
    start_spinner()
  elseif data.kind == "end" then
    stop_spinner()
    M.state.lsp_msg = ""
    vim.cmd.redrawstatus()
    return
  end

  if data.percentage then
    progress = data.percentage .. "%% "
  end

  local str = progress .. (data.message or "") .. " " .. (data.title or "")
  M.state.lsp_msg = str
  vim.cmd.redrawstatus()
end

function M.setup()
  vim.api.nvim_create_autocmd("LspProgress", {
    pattern = { "begin", "report", "end" },
    callback = update_lsp_progress,
  })
end

function M.get_lsp_progress()
  if M.state.lsp_msg ~= "" then
    return spinners[M.state.spinner_index] .. " " .. M.state.lsp_msg
  else
    return ""
  end
end

return M

