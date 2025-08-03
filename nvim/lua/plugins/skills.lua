return {
   dir = '~/.config/nvim/lua/skills',
   event = 'VimEnter',
   config = function()
      require('skills').setup()

      -- Key mapping to start the game
      -- vim.api.nvim_set_keymap('n', '<leader>g', ':lua require("skills").start_game()<CR>',
      --    { noremap = true, silent = true })
   end,
}
