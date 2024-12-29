local config = {
  enabled = true
}

local M = {}
function M.setup(user_config)
  config = vim.tbl_deep_extend("force", config, user_config or {})
end

function M.mode_indicator()
  local mode_map = {
  ["n"] = { "NORMAL", "ModeNormal" },
  ["no"] = { "NORMAL (no)", "ModeNormal" },
  ["nov"] = { "NORMAL (nov)", "ModeNormal" },
  ["noV"] = { "NORMAL (noV)", "ModeNormal" },
  ["noCTRL-V"] = { "NORMAL", "ModeNormal" },
  ["niI"] = { "NORMAL i", "ModeNormal" },
  ["niR"] = { "NORMAL r", "ModeNormal" },
  ["niV"] = { "NORMAL v", "ModeNormal" },
  ["nt"] = { "NTERMINAL", "ModeTerminal" },
  ["ntT"] = { "NTERMINAL (ntT)", "ModeTerminal" },

  ["v"] = { "VISUAL", "ModeVisual" },
  ["vs"] = { "V-CHAR (Ctrl O)", "ModeVisual" },
  ["V"] = { "V-LINE", "ModeVisual" },
  ["Vs"] = { "V-LINE", "ModeVisual" },
  [""] = { "V-BLOCK", "ModeVisual" },

  ["i"] = { "INSERT", "ModeInsert" },
  ["ic"] = { "INSERT (completion)", "ModeInsert" },
  ["ix"] = { "INSERT completion", "ModeInsert" },

  ["t"] = { "TERMINAL", "ModeTerminal" },

  ["R"] = { "REPLACE", "ModeReplace" },
  ["Rc"] = { "REPLACE (Rc)", "ModeReplace" },
  ["Rx"] = { "REPLACEa (Rx)", "ModeReplace" },
  ["Rv"] = { "V-REPLACE", "ModeReplace " },
  ["Rvc"] = { "V-REPLACE (Rvc)", "ModeReplace" },
  ["Rvx"] = { "V-REPLACE (Rvx)", "ModeReplace" },

  ["s"] = { "SELECT", "ModeVisual" },
  ["S"] = { "S-LINE", "ModeVisual" },
  [""] = { "S-BLOCK", "ModeVisual" },
  ["c"] = { "COMMAND", "ModeCommand" },
  ["cv"] = { "COMMAND", "ModeCommand" },
  ["ce"] = { "COMMAND", "ModeCommand" },
  ["cr"] = { "COMMAND", "ModeCommand" },
  ["r"] = { "PROMPT", "ModeNormal" },
  ["rm"] = { "MORE", "ModeNormal" },
  ["r?"] = { "CONFIRM", "ModeNormal" },
  ["x"] = { "CONFIRM", "ModeNormal" },
  ["!"] = { "SHELL", "ModeNormal" },
}

  -- local mode_map = {
  --   n = { 'NORMAL',         'ModeNormal' },
  --   i = { 'INSERT',         'ModeInsert' },
  --   v = { 'VISUAL',         'ModeVisual' },
  --   ['\x16'] = { 'V-BLOCK', 'ModeVisual' },
  --   V = { 'V-LINE',         'ModeVisual' },
  --   c = { 'COMMAND',        'ModeCommand' },
  --   R = { 'REPLACE',        'ModeReplace' },
  --   ['r'] = { 'REPLACE',    'ModeReplace' },
  --   ['r?'] = { 'REPLACE',   'ModeReplace' },
  --   ['!'] = { 'SHELL',      'ModeNormal' },
  --   ['no'] = { 'PENDING',   'ModeReplace' },
  --   t = { 'TERMINAL',       'ModeTerminal' },
  -- }
  --
  local api_mode = vim.api.nvim_get_mode()
  local mode = api_mode.mode
  local mode_info = mode_map[mode] or { 'UNKNOWN', 'NormalMode' }
  if api_mode.blocking then
    mode_info = { 'O-PENDING', 'ModeNormal' }
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
