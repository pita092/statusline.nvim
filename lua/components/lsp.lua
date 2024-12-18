local M = {}

function M.lsp_status()
  local clients = vim.lsp.get_active_clients()
  if #clients > 0 then
    local msgs = vim.lsp.status()
    if #msgs > 0 then
      return msgs[1].title .. ": " .. msgs[1].message
    else
      return "LSP: " .. clients[1].name
    end
  end
  return ""
end

return M
