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
function M.diagnostic_status()
  local counts = {
    errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR }),
    warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN }),
    info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO }),
    hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
  }
  return string.format("E:%d W:%d I:%d H:%d", counts.errors, counts.warnings, counts.info, counts.hints)
end


return M
