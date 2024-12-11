local config = {
  enabled = true
}

local M = {}
function M.setup(user_config)
  config = vim.tbl_deep_extend("force", config, user_config or {})
end

function M.mode_indicator()
  local mode_map = {
    n = { 'NORMAL', 'ModeNormal' },
    i = { 'INSERT', 'ModeInsert' },
    v = { 'VISUAL', 'ModeVisual' },
    ['\x16'] = { 'V-BLOCK', 'ModeVisual' },
    V = { 'V-LINE', 'ModeVisual' },
    c = { 'COMMAND', 'ModeCommand' },
    R = { 'REPLACE', 'ModeReplace' },
    ['r'] = { 'REPLACE', 'ModeReplace' },
    ['r?'] = { 'REPLACE', 'ModeReplace' },
    ['!'] = { 'SHELL', 'ModeNormal' },
    ['no'] = { 'PENDING', 'ModeReplace' },
    t = { 'TERMINAL', 'ModeTerminal' },
  }
  local api_mode = vim.api.nvim_get_mode()
  local mode = api_mode.mode
  local mode_info = mode_map[mode] or { 'UNKNOWN', 'NormalMode' }
  if api_mode.blocking then
    mode_info = { 'O-PENDING', 'ModeNormal' }
  end
  local current_buf_name = vim.fn.expand("%:t")
  if current_buf_name ==  "UniqueFloatingCmdLineName" then
    mode_info = { 'COMMAND', 'ModeCommand' }
  end

  return string.format(
    '%%#%s#%s%s%s%%#Normal#',
    mode_info[2],
    ' ',
    mode_info[1],
    ' '
  )
end

return M
