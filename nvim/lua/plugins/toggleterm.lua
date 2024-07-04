return {
   'akinsho/toggleterm.nvim',
   version = "*",
   config = function()
      require("toggleterm").setup {
         -- Default configuration options
         size = 20,
         open_mapping = [[<c-\>]],
         hide_numbers = true,
         shade_filetypes = {},
         shade_terminals = true,
         shading_factor = 2,
         start_in_insert = true,
         insert_mappings = true,
         terminal_mappings = true,
         persist_size = true,
         direction = 'horizontal',
         close_on_exit = true,
         shell = 'zsh',
         float_opts = {
            border = 'curved',
            winblend = 0,
            highlights = {
               border = "Normal",
               background = "Normal",
            },
         },
      }

      -- Function to run the current Go file in a toggle terminal
      local function run_go_file()
         local file = vim.fn.expand('%')
         require('toggleterm.terminal').Terminal:new({
            cmd = "go run " .. file .. " ; read",
            hidden = true,
            direction = "horizontal",
         }):toggle()
      end

      -- Function to run Go tests in a toggle terminal
      local function run_go_tests()
         require('toggleterm.terminal').Terminal:new({
            cmd = "go test ./... ; read",
            hidden = true,
            direction = "horizontal",
         }):toggle()
      end

      -- Create user commands to run the Go file and Go tests
      vim.api.nvim_create_user_command('RunGoFile', run_go_file, {})
      vim.api.nvim_create_user_command('RunGoTests', run_go_tests, {})

      -- Keybinding to run the current Go file
      vim.api.nvim_set_keymap('n', '<leader>r', ':RunGoFile<CR>', { noremap = true, silent = true })

      -- Keybinding to run Go tests
      vim.api.nvim_set_keymap('n', '<leader>t', ':RunGoTests<CR>', { noremap = true, silent = true })

      -- Keybinding to toggle an empty terminal for input
      vim.api.nvim_set_keymap('n', '<leader>tt', ':ToggleTerm direction=horizontal<CR>',
         { noremap = true, silent = true })
      vim.api.nvim_set_keymap('t', '<C-k>', [[<C-\><C-n>:TmuxNavigateUp<CR>]], { noremap = true, silent = true })
      vim.api.nvim_set_keymap('t', '<C-l>', [[<C-\><C-n>:TmuxNavigateRight<CR>]], { noremap = true, silent = true })
   end
}

