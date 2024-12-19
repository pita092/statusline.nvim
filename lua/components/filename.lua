local M = {}

-- Default configuration
local config = {
  enabled = true,
  path_type = "tail", -- Default path type
}

-- Function to set up the module with user configuration
function M.setup(user_config)
  config = vim.tbl_deep_extend("force", config, user_config or {})
end

-- Function to get the filename based on the configured path type
function M.get_filename(a)
  if not config.enabled then return '' end

  local filename

  -- Get the filename based on the configured path type
    if a == "relative" or a == "Relative" or a == "R" or a == "RELATIVE " then
    filename = vim.fn.expand('%:f')
  elseif a == "tail" or a == "Tail" or a == "T" or a == "TAIL" then
    filename = vim.fn.expand('%:t')
  elseif a == "full" or a == "Full" or a == "f" or a == "F" or a == "FULL" then
    filename = vim.fn.expand('%:F')
  else
    filename = vim.fn.expand('%:t')
  end

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
