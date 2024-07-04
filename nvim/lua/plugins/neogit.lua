return {
   'NeogitOrg/neogit',
   dependencies = {
      'nvim-lua/plenary.nvim',         -- Required dependency
      'nvim-telescope/telescope.nvim', -- Optional dependency for Telescope integration
   },
   config = function()
      require('neogit').setup {
         integrations = {
            telescope = true, -- Enable Telescope integration
         },
      }

      -- Keybinding to open Neogit with <leader>gg
      vim.api.nvim_set_keymap('n', '<leader>gg', ':Neogit<CR>',
         { noremap = true, silent = true, desc = "neogit: Open Neogit" })
   end,
}
