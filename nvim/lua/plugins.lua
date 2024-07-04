local function get_plugins()
  local plugins = {}
  local plugin_files = vim.fn.globpath(vim.fn.stdpath('config') .. '/lua/plugins', '*.lua', false, true)
  
  for _, file in ipairs(plugin_files) do
    local plugin = file:match("([^/]+)%.lua$")
    if plugin and plugin ~= "init" then
      table.insert(plugins, { import = 'plugins.' .. plugin })
    end
  end
  
  return plugins
end

return get_plugins()
