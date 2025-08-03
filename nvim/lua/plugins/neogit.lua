return {
   'NeogitOrg/neogit',
   dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'sindrets/diffview.nvim',
   },
   config = function()
      require('neogit').setup {
         integrations = {
            telescope = true,
            diffview = true,
         },
      }

      -- Keybinding to open Neogit
      vim.api.nvim_set_keymap('n', '<leader>gg', ':Neogit<CR>',
         { noremap = true, silent = true, desc = "neogit: Open Neogit" })
   end,
}
