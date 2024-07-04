local M = {}

local telescope = require('telescope')
local theme_switcher = require('utils.theme_switcher')

telescope.extensions.themes = {
  themes = function()
    require('telescope.pickers').new({}, {
      prompt_title = 'Switch Theme',
      finder = require('telescope.finders').new_table {
        results = theme_switcher.themes,
      },
      sorter = require('telescope.config').values.generic_sorter({}),
      attach_mappings = function(_, map)
        map('i', '<CR>', function(prompt_bufnr)
          local selection = require('telescope.actions.state').get_selected_entry()
          require('telescope.actions').close(prompt_bufnr)
          theme_switcher.switch_theme(selection[1])
        end)
        return true
      end,
    }):find()
  end
}

M.themes = telescope.extensions.themes.themes

return M
