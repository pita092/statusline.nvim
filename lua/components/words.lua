local config = {
  enabled = true
}

local M = {}
function M.setup(user_config)
  config = vim.tbl_deep_extend("force", config, user_config or {})
end
function M.word_count()
  local wc = vim.fn.wordcount()
  return string.format("%d words, %d chars", wc.words, wc.chars)
end
return M
