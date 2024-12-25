local M = {}



function M.get_filename()

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
function M.custom_filename(path_type)
  return [[ %{luaeval("require('components.filename').get_filename( ]] .. path_type .. ')")}'
end

return M
