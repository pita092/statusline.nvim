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
function M.get_filename()
  if not config.enabled then return '' end

  local filename

  -- Get the filename based on the configured path type
  if config.path_type == "relative" or "Relative" or "R" or "RELATIVE " then
    filename = vim.fn.expand('%:f')
  elseif config.path_type == "tail" or "Tail" or "T" or "TAIL" then
    filename = vim.fn.expand('%:t')
  elseif config.path_type == "full" or "Full" or "f" or "F" or "FULL" then
    filename = vim.fn.expand('%:F')
  else
    filename = vim.fn.expand('%:f')
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
function M.custom_filename()
  return [[ %{luaeval("require('pita.statusline.filename').get_filename()")} ]]
end

return M
