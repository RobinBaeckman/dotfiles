return {
   'akinsho/toggleterm.nvim',
   version = "*",
   config = function()
      require("toggleterm").setup {
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

      local Terminal = require('toggleterm.terminal').Terminal

      local function run_go_file()
         local file = vim.fn.expand('%')
         Terminal:new({
            cmd = "go run " .. file .. " ; read",
            hidden = true,
            direction = "horizontal",
         }):toggle()
      end

      local function run_go_tests()
         Terminal:new({
            cmd = "go test ./... ; read",
            hidden = true,
            direction = "horizontal",
         }):toggle()
      end

      vim.api.nvim_create_user_command('RunGoFile', run_go_file, {})
      vim.api.nvim_create_user_command('RunGoTests', run_go_tests, {})

      -- Keybindings with descriptions
      vim.keymap.set('n', '<leader>tt', ':ToggleTerm direction=horizontal<CR>', {
         noremap = true,
         silent = true,
         desc = "Terminal: Toggle terminal"
      })

      vim.keymap.set('n', '<leader>r', ':RunGoFile<CR>', {
         noremap = true,
         silent = true,
         desc = "Go: Run current file in terminal"
      })

      vim.keymap.set('n', '<leader>t', ':RunGoTests<CR>', {
         noremap = true,
         silent = true,
         desc = "Go: Run all tests in terminal"
      })

      vim.keymap.set('t', '<C-k>', [[<C-\><C-n>:TmuxNavigateUp<CR>]], {
         noremap = true,
         silent = true,
         desc = "Tmux: Navigate Up from terminal"
      })

      vim.keymap.set('t', '<C-l>', [[<C-\><C-n>:TmuxNavigateRight<CR>]], {
         noremap = true,
         silent = true,
         desc = "Tmux: Navigate Right from terminal"
      })
   end
}
