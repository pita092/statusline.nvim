local config = {
  enabled = false,
  separator = ""
}

local M = {}

  function M.setup(user_config)
    config = vim.tbl_deep_extend("force", config, user_config or {})
  end
M.seps = function()

  return config.separator

end


return M
