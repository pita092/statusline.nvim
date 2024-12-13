-- local config = {
--   colors = "gruvbox",
--   padding = 6,
--   separator = {
--     enabled = true,
--     separator = "",
--   },
--   git = {
--     enabled = true,
--     icon = "",
--   },
--   scroll = {
--     enabled = true,
--   },
--   words = {
--     enabled = true,
--   },
--   mode = {
--     enabled = true,
--   },
--   filename = {
--     enabled = true,
--     path_type = "relative",
--   },
-- }
--
-- local git = require("components.git")
-- local scroll = require("components.scrollbar")
-- local words = require("components.words")
-- local mode = require("components.mode")
-- local filename = require("components.filename")
-- local separator = require("components.separators")
--
-- local function a(x)
--   return string.rep(" ", x)
-- end
--
-- local M = {}
--
-- local function load_colors()
--   local ok, _ = pcall(require, "colors." .. config.colors)
--   if not ok then
--     vim.notify("Failed to load color scheme: " .. config.colors, vim.log.levels.WARN)
--   end
-- end
--
-- function M.setup(user_config)
--   -- Check if user_config.config exists and use it, otherwise use user_config directly
--   local new_config = user_config.config or user_config
--
--   -- Merge user config with default config
--   config = vim.tbl_deep_extend("force", config, new_config or {})
--
--   -- Pass configurations to individual modules
--   git.setup(config.git)
--   scroll.setup(config.scroll)
--   words.setup(config.words)
--   mode.setup(config.mode)
--   filename.setup(config.filename)
--   separator.setup(config.separator)
--
--   vim.o.statusline = '%!v:lua.require("statusline").set_statusline()'
--
--   load_colors()
-- end
--
-- function M.set_statusline()
--   local components = {
--     '%#StatusLine_bg#',
--     string.rep(" ", config.padding),
--   }
--
--   if config.mode.enabled then
--     table.insert(components, mode.mode_indicator(config.mode))
--   end
--
--   table.insert(components, '%#StatusLine_Normal# ')
--
--   if config.separator.enabled then
--     table.insert(components, '%#StatusLine_Separatror#')
--     table.insert(components, separator.seps(config.separator))
--     table.insert(components, '%#StatusLine_Normal# ')
--   end
--
--   table.insert(components, '%#StatusLine_Column#col:%c%#StatusLine_Normal#')
--   table.insert(components, a(2))
--
--   if config.separator.enabled then
--     table.insert(components, '%#StatusLine_Separatror#')
--     table.insert(components, separator.seps(config.separator))
--     table.insert(components, '%#StatusLine_Normal# ')
--   end
--
--   if config.filename.enabled then
--     table.insert(components, filename.custom_filename(config.filename))
--   end
--
--   if config.separator.enabled then
--     table.insert(components, '%#StatusLine_Separatror#')
--     table.insert(components, separator.seps(config.separator))
--     table.insert(components, '%#StatusLine_Normal# ')
--   end
--
--   table.insert(components, a(1))
--   table.insert(components, '%=')
--   table.insert(components, '%#StatusLine_Normal#')
--
--   if config.scroll.enabled then
--     table.insert(components, '%#Scrollbar#')
--     table.insert(components, scroll.scrollbar_indicator(config.scroll))
--     table.insert(components, '%#StatusLine_Normal# ')
--   end
--
--   if config.separator.enabled then
--     table.insert(components, '%#StatusLine_Separatror#')
--     table.insert(components, separator.seps(config.separator))
--     table.insert(components, '%#StatusLine_Normal# ')
--   end
--
--   table.insert(components, a(1))
--
--   if config.words.enabled then
--     table.insert(components, words.word_count(config.words))
--     table.insert(components, a(1))
--   end
--
--   if config.git.enabled and git.in_git_repo() then
--     table.insert(components, '%#StatusLine_bg#')
--     table.insert(components, a(2))
--     table.insert(components, '%#StatusLine_GitStatus#')
--     table.insert(components, git.get_branch(config.git))
--     table.insert(components, a(1))
--   end
--
--   table.insert(components, '%#StatusLine_bg#')
--   table.insert(components, a(config.padding - 1))
--
--   return table.concat(components, '')
-- end
--
-- git.init_git_branch()
--
-- return M

local config = {
  colors = "gruvbox",
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

local function get_section(section_components)
  local components = {}
  for _, component in ipairs(section_components) do
    if type(component) == "function" then
      table.insert(components, component())
    else
      table.insert(components, component)
    end
  end
  return table.concat(components, '')
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
  local sections = {
    a = {
      '%#StatusLine_bg#',
      a(config.padding),
      function() return config.mode.enabled and mode.mode_indicator(config.mode) or '' end,
      '%#StatusLine_Normal# ',
    },
    b = {
      function() return config.git.enabled and git.in_git_repo() and git.get_branch(config.git) or '' end,
    },
    c = {
      function() return config.filename.enabled and filename.custom_filename(config.filename) or '' end,
    },
    x = {
      function() return config.words.enabled and words.word_count(config.words) or '' end,
    },
    y = {
      function() return config.scroll.enabled and scroll.scrollbar_indicator(config.scroll) or '' end,
    },
    z = {
      '%#StatusLine_Column#col:%c%#StatusLine_Normal#',
      a(2),
      '%#StatusLine_bg#',
      a(config.padding - 1),
    },
  }

  local components = {
    get_section(sections.a),
    config.separator.enabled and separator.seps(config.separator) or '',
    get_section(sections.b),
    config.separator.enabled and separator.seps(config.separator) or '',
    get_section(sections.c),
    '%=',  -- This will push the following components to the right
    get_section(sections.x),
    config.separator.enabled and separator.seps(config.separator) or '',
    get_section(sections.y),
    config.separator.enabled and separator.seps(config.separator) or '',
    get_section(sections.z),
  }

  return table.concat(components, '')
end

git.init_git_branch()

return M

