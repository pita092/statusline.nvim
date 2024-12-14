local config = {
  colors = "gruvbox",
  padding = 6,
  col = {
    enabled = true
  },
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
    path_type = "Tail",
  },
}

local git = require("components.git")
local scroll = require("components.scrollbar")
local words = require("components.words")
local mode = require("components.mode")
local filename = require("components.filename")
local separator = require("components.separators")

local function a(x)
  return string.rep(" ", x)
end

local M = {}

local function load_colors()
  local ok, _ = pcall(require, "colors." .. config.colors)
  if not ok then
    vim.notify("Failed to load color scheme: " .. config.colors, vim.log.levels.WARN)
  end
end

function M.setup(user_config)
  -- Check if user_config.config exists and use it, otherwise use user_config directly
  local new_config = user_config.config or user_config

  -- Merge user config with default config
  config = vim.tbl_deep_extend("force", config, new_config or {})

  -- Pass configurations to individual modules
  git.setup(config.git)
  scroll.setup(config.scroll)
  words.setup(config.words)
  mode.setup(config.mode)
  filename.setup(config.filename)
  separator.setup(config.separator)

  vim.o.statusline = '%!v:lua.require("statusline").set_statusline()'

  load_colors()
end

function M.set_statusline()
  local components = {
    '%#StatusLine_bg#',
    string.rep(" ", config.padding),
  }

  if config.mode.enabled then
    table.insert(components, mode.mode_indicator(config.mode))
  end

  table.insert(components, '%#StatusLine_Normal# ')

  if config.separator.enabled then
    table.insert(components, '%#StatusLine_Separatror#')
    table.insert(components, separator.seps(config.separator))
    table.insert(components, '%#StatusLine_Normal# ')
  end
  if config.col.enabled then
  table.insert(components, a(1))
  table.insert(components, '%#StatusLine_Column#col:%c%#StatusLine_Normal#')
  table.insert(components, a(2))
  end

  if config.separator.enabled then
    table.insert(components, '%#StatusLine_Separatror#')
    table.insert(components, separator.seps(config.separator))
    table.insert(components, '%#StatusLine_Normal# ')
  end

  if config.filename.enabled then
    table.insert(components, filename.custom_filename(config.filename.path_type))
  end

  if config.separator.enabled then
    table.insert(components, '%#StatusLine_Separatror#')
    table.insert(components, separator.seps(config.separator))
    table.insert(components, '%#StatusLine_Normal# ')
  end

  table.insert(components, a(1))
  table.insert(components, '%=')
  table.insert(components, '%#StatusLine_Normal#')

  if config.scroll.enabled then
    table.insert(components, '%#Scrollbar#')
    table.insert(components, scroll.scrollbar_indicator(config.scroll))
    table.insert(components, '%#StatusLine_Normal# ')
  end

  if config.separator.enabled then
    table.insert(components, '%#StatusLine_Separatror#')
    table.insert(components, separator.seps(config.separator))
    table.insert(components, '%#StatusLine_Normal# ')
  end

  table.insert(components, a(1))

  if config.words.enabled then
    table.insert(components, words.word_count(config.words))
    table.insert(components, a(1))
  end

  if config.git.enabled and git.in_git_repo() then
    table.insert(components, '%#StatusLine_bg#')
    table.insert(components, a(2))
    table.insert(components, '%#StatusLine_GitStatus#')
    table.insert(components, git.get_branch(config.git))
    table.insert(components, a(1))
    table.insert(components, git.git())
  end

  table.insert(components, '%#StatusLine_bg#')
  table.insert(components, a(config.padding - 1))

  return table.concat(components, '')
end

git.init_git_branch()

return M
