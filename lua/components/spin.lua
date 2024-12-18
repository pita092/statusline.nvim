local M = {}

local spinner_frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
local spinner_index = 1
local spinner_timer = nil

local function update_spinner()
  spinner_index = (spinner_index % #spinner_frames) + 1
  vim.schedule(function()
    vim.api.nvim_command("redrawstatus")
  end)
end

function M.start()
  if spinner_timer == nil then
    spinner_timer = vim.loop.new_timer()
    spinner_timer:start(0, 100, vim.schedule_wrap(update_spinner))
  end
end

function M.stop()
  if spinner_timer then
    spinner_timer:stop()
    spinner_timer:close()
    spinner_timer = nil
  end
end

function M.get_spinner()
  return spinner_frames[spinner_index]
end

return M

