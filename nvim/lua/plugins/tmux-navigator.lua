return {
   "christoomey/vim-tmux-navigator",
   lazy = false,
   config = function()
      vim.g.tmux_navigator_no_mappings = 1

      vim.api.nvim_set_keymap('n', '<C-h>', ':TmuxNavigateLeft<CR>',
         { noremap = true, silent = true, desc = "Tmux: Navigate to the left pane" })
      vim.api.nvim_set_keymap('n', '<C-j>', ':TmuxNavigateDown<CR>',
         { noremap = true, silent = true, desc = "Tmux: Navigate to the lower pane" })
      vim.api.nvim_set_keymap('n', '<C-k>', ':TmuxNavigateUp<CR>',
         { noremap = true, silent = true, desc = "Tmux: Navigate to the upper pane" })
      vim.api.nvim_set_keymap('n', '<C-l>', ':TmuxNavigateRight<CR>',
         { noremap = true, silent = true, desc = "Tmux: Navigate to the right pane" })
      vim.api.nvim_set_keymap('n', '<C-\\>', ':TmuxNavigatePrevious<CR>',
         { noremap = true, silent = true, desc = "Tmux: Navigate to the previous pane" })
   end
}
