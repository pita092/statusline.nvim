local git = require("components.git")
local scroll = require("components.scrollbar")
local words = require("components.words")
local mode = require("components.mode")
local filename = require("components.filename")
local separator = require("components.separators")
vim.api.nvim_set_hl(0, 'StatusLine_1', { fg = "#fbf1c7", bg = "#32302f"})
vim.api.nvim_set_hl(0, 'StatusLine_2', { fg = "#1d2021", bg = "#1d2021" })
vim.api.nvim_set_hl(0, 'StatusLine_3', { bg = "#83a598" })

local function a(x)
  return string.rep(" ", x)
end

local M = {}

local config = {
  statusline_height = 3,
  padding = 6,
  separator = {
    enabled = true,
    separator = "",
  },
  git = {
    enabled = true,
    icon = "",
  },
  scroll = {
    enabled = true,
  },
  words = {
    enabled = true,
  },
  mode = {
    enabled = true,
  },
  filename = {
    enabled = true,
    path_type = "relative",
  },
}

function M.setup(user_config)
  config = vim.tbl_deep_extend("force", config, user_config or {})

  -- Pass configurations to individual modules
  git.setup(config.git)
  scroll.setup(config.scroll)
  words.setup(config.words)
  mode.setup(config.mode) -- Ensure this is called correctly
  filename.setup(config.filename)
  separator.setup(config.separator)

  vim.o.statusline = '%!v:lua.require("statusline").set_statusline()'
end

function M.set_statusline()
  local components = {
    '%#StatusLine_2#',
    a(config.padding),
  }

  if config.mode.enabled then
    table.insert(components, mode.mode_indicator(config.mode))
  end

  table.insert(components, '%#StatusLine_1# ')

  if config.separator.enabled then
    table.insert(components, '%#StatusLine_Separatror#')
    table.insert(components, separator.seps(config.separator))
    table.insert(components, '%#StatusLine_1# ')
  end

  table.insert(components, '  %c')
  table.insert(components, a(2))

  if config.separator.enabled then
    table.insert(components, '%#StatusLine_3#')
    table.insert(components, separator.seps(config.separator))
    table.insert(components, '%#StatusLine_1# ')
  end

  if config.filename.enabled then
    table.insert(components, filename.custom_filename(config.filename))
  end

  if config.separator.enabled then
    table.insert(components, '%#StatusLine_3#')
    table.insert(components, separator.seps(config.separator))
    table.insert(components, '%#StatusLine_1# ')
  end

  table.insert(components, a(1))
  table.insert(components, '%=')
  table.insert(components, '%#StatusLine_1#')

  if config.scroll.enabled then
    table.insert(components, '%#ScrollBar#')
    table.insert(components, scroll.scrollbar_indicator(config.scroll))
    table.insert(components, '%#StatusLine_1# ')
  end

  if config.separator.enabled then
    table.insert(components, '%#StatusLine_3#')
    table.insert(components, separator.seps(config.separator))
    table.insert(components, '%#StatusLine_1# ')
  end

  table.insert(components, a(1))

  if config.words.enabled then
    table.insert(components, words.word_count(config.words))
    table.insert(components, a(1))
  end


  if config.git.enabled then
    table.insert(components, '%#StatusLine_2#')
    table.insert(components, a(2))
    table.insert(components, '%#StatusLine_GitStatus#')
    table.insert(components, a(1))
    table.insert(components, git.get_branch(config.git))
    table.insert(components, a(1))
  end


  table.insert(components, '%#StatusLine_2#')
  table.insert(components, a(config.padding - 1))

  return table.concat(components, '')
end

git.init_git_branch()

return M