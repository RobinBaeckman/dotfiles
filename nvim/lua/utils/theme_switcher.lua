local M = {}

local success, theme_plugins = pcall(require, 'plugins.themes')
local theme_names = {}

if success then
  for _, plugin in ipairs(theme_plugins) do
    if plugin[1] then
      table.insert(theme_names, plugin.name)
    end
  end
else
  print("Failed to load themes: ", theme_plugins)
end

local theme_file = vim.fn.stdpath('config') .. '/selected_theme.txt'

M.themes = theme_names

M.switch_theme = function(theme)
  vim.cmd.colorscheme(theme)
  -- Save the selected theme to a file
  local file = io.open(theme_file, 'w')
  if file then
    file:write(theme)
    file:close()
  end
end

-- Load the saved theme during startup
local function load_theme()
  local file = io.open(theme_file, 'r')
  if file then
    local theme = file:read('*all')
    file:close()
    if theme and theme ~= '' then
      vim.cmd.colorscheme(theme)
    end
  end
end

M.load_theme = load_theme

return M
