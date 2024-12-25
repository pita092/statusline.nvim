local M = {}

-- Default configuration
local config = {
  enabled = true,
}

function M.setup(user_config)
  config = vim.tbl_deep_extend("force", config, user_config or {})
end

function M.get_filename()
  if not config.enabled then return '' end


  local filename = vim.fn.expand('%:t')
  local filetype = vim.bo.filetype

  if filename == '' then
    return '.'
  elseif filetype == 'help' then
    return 'Help: ' .. filename
  elseif filename == 'UniqueFloatingCmdLineName' then
    if vim.fn.bufname(vim.fn.bufnr('#')) == '' then
      return '.'
    end
  elseif filetype == 'qf' then
    return 'Quickfix List'
  else
    return filename
  end
end

-- Function to return a custom filename for statusline with LuaEval for dynamic updates.
function M.custom_filename()
  return [[ %{luaeval("require('components.filename').get_filename()")}]]
end

return M
