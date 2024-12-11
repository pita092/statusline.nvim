local git = require("pita.statusline.git")
local scroll = require("pita.statusline.scrollbar")
local words = require("pita.statusline.words")
local mode = require("pita.statusline.mode")
local filename = require("pita.statusline.filename")
local separator = require("pita.statusline.separators")

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

  vim.o.statusline = '%!v:lua.require("pita.statusline").set_statusline()'
end

function M.set_statusline()
  local components = {
    '%#GruvboxBg0#',
    a(config.padding),
  }

  if config.mode.enabled then
    table.insert(components, mode.mode_indicator(config.mode))
  end

  table.insert(components, '%#StatusLine# ')

  if config.separator.enabled then
    table.insert(components, '%#StatusLine_Separatror#')
    table.insert(components, separator.seps(config.separator))
    table.insert(components, '%#StatusLine# ')
  end

  table.insert(components, '  %c')
  table.insert(components, a(2))

  if config.separator.enabled then
    table.insert(components, '%#StatusLine_Separatror#')
    table.insert(components, separator.seps(config.separator))
    table.insert(components, '%#StatusLine# ')
  end

  if config.filename.enabled then
    table.insert(components, filename.custom_filename(config.filename))
  end

  if config.separator.enabled then
    table.insert(components, '%#StatusLine_Separatror#')
    table.insert(components, separator.seps(config.separator))
    table.insert(components, '%#StatusLine# ')
  end

  table.insert(components, a(1))
  table.insert(components, '%=')
  table.insert(components, '%#StatusLine#')

  if config.scroll.enabled then
    table.insert(components, '%#ScrollBar#')
    table.insert(components, scroll.scrollbar_indicator(config.scroll))
    table.insert(components, '%#StatusLine# ')
  end

  if config.separator.enabled then
    table.insert(components, '%#StatusLine_Separatror#')
    table.insert(components, separator.seps(config.separator))
    table.insert(components, '%#StatusLine# ')
  end

  table.insert(components, a(1))

  if config.words.enabled then
    table.insert(components, words.word_count(config.words))
    table.insert(components, a(1))
  end


  if config.git.enabled then
    table.insert(components, '%#GruvboxBg0#')
    table.insert(components, a(2))
    table.insert(components, '%#StatusLine_GitStatus#')
    table.insert(components, a(1))
    table.insert(components, git.get_branch(config.git))
    table.insert(components, a(1))
  end


  table.insert(components, '%#GruvboxBg0#')
  table.insert(components, a(config.padding - 1))

  return table.concat(components, '')
end

git.init_git_branch()

return M
