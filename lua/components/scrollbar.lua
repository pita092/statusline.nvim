local config = {
  enabled = true
}

local M = {}
function M.setup(user_config)
  config = vim.tbl_deep_extend("force", config, user_config or {})
end

function M.scrollbar_indicator()
  local current_line = vim.fn.line('.')
  local total_lines = vim.fn.line('$')
  if current_line == total_lines then
    return '  '
  else
    local chars = { '▇▇', '▇▇', '▆▆', '▅▅', '▄▄', '▃▃', '▂▂', '▁▁' }
    local line_ratio = current_line / total_lines
    local index = math.ceil(line_ratio * #chars)
    return chars[index]
  end
end

return M
