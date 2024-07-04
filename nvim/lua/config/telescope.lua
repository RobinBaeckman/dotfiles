local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

-- Function to search for keymap definitions in your config files
local function find_keymap_definition(keymap)
   if not keymap then
      print("find_keymap_definition: keymap is nil")
      return nil, nil
   end
   local search_dirs = { vim.fn.stdpath('config') }
   for _, dir in ipairs(search_dirs) do
      local command = "grep -rn --include '*.lua' '" .. keymap .. "' " .. dir
      print("Executing command: " .. command)
      local handle = io.popen(command)
      local result = handle:read("*a")
      handle:close()
      if result and result ~= "" then
         for line in result:gmatch("[^\r\n]+") do
            local filename, lnum = line:match("^(.-):(%d+):")
            if filename and lnum then
               return filename, tonumber(lnum)
            end
         end
      end
   end
   return nil, nil
end

-- Function to jump to the keymap definition
local function jump_to_keymap(prompt_bufnr)
   local selected = action_state.get_selected_entry()
   actions.close(prompt_bufnr)
   if selected then
      print(vim.inspect(selected))
      local keymap = selected.lhs
      if keymap then
         local leader_key = "<leader>"
         if keymap:sub(1, 1) == "," then
            keymap = leader_key .. keymap:sub(2)
         end
         print("Keymap selected: " .. keymap)
         local filename, lnum = find_keymap_definition(keymap)
         if filename and lnum then
            vim.api.nvim_command('edit ' .. filename)
            vim.api.nvim_win_set_cursor(0, { lnum, 0 })
         else
            print("No keymap definition found for: " .. keymap)
         end
      else
         print("No keymap value found in the selected entry")
      end
   end
end

-- Function to find keymaps
local function find_keymaps()
   require('telescope.builtin').keymaps({
      attach_mappings = function(_, map)
         map('i', '<CR>', jump_to_keymap)
         map('n', '<CR>', jump_to_keymap)
         return true
      end,
   })
end

-- Telescope setup
require('telescope').setup {
   defaults = {
      mappings = {
         i = {
            ["<C-t>"] = actions.select_tab,
            ["<C-\\>"] = actions.select_vertical,
         },
         n = {
            ["<C-t>"] = actions.select_tab,
            ["<C-\\>"] = actions.select_vertical,
         },
      },
   },
   extensions = {
      ['ui-select'] = {
         require('telescope.themes').get_dropdown(),
      },
   },
   -- pickers = {
   --    help_tags = {
   --       layout_strategy = 'buffer_window',
   --       layout_config = {
   --          width = 0.99,
   --          height = 0.99,
   --          preview_width = 0.6,
   --       },
   --    },
   -- },
}
pcall(require('telescope').load_extension, 'fzf')
pcall(require('telescope').load_extension, 'ui-select')

local builtin = require 'telescope.builtin'
function SearchInDotfiles()
   require('telescope.builtin').live_grep({
      search_dirs = { "~/dotfiles" },
      prompt_title = "Live Grep in ~/.dotfiles",
   })
end

-- Telescope key mappings
vim.api.nvim_set_keymap('n', '<leader>gd', ':lua SearchInDotfiles()<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope: Find Help Tags' })
vim.keymap.set('n', '<leader>fk', find_keymaps, { desc = 'Telescope: Find Keymaps' })
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope: Find Files' })
vim.keymap.set('n', '<leader>fi', builtin.builtin, { desc = 'Telescope: Find Builtin' })
vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, { desc = 'Telescope: Find Symbols' })
vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = 'Telescope: Find Word under Cursor' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope: Live Grep' })
vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = 'Telescope: Find Diagnostics' })
vim.keymap.set('n', '<leader>fp', builtin.resume, { desc = 'Telescope: Resume Last Search' })
vim.keymap.set('n', '<leader>fr', builtin.registers, { desc = 'Telescope: Find Registers' })
vim.keymap.set('n', '<leader>fo', builtin.oldfiles, { desc = 'Telescope: Find Old Files' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope: Find Buffers' })
vim.keymap.set('n', '<leader>/', function()
   builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
      winblend = 10,
      previewer = false,
   })
end, { desc = 'Telescope: Fuzzily search in current buffer' })
vim.keymap.set('n', '<leader><leader>', function()
   builtin.find_files { cwd = vim.fn.stdpath 'config' }
end, { desc = 'Telescope: Find Neovim Config Files' })
vim.keymap.set('n', '<leader>fd', function()
   require('telescope.builtin').find_files {
      cwd = vim.fn.expand('~/dotfiles'),
      hidden = true
   }
end, { desc = 'Telescope: Find Dotfiles' })
