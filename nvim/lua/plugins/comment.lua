return {
   'numToStr/Comment.nvim',
   opts = {
      mappings = {
         basic = false,    -- Disable basic mappings
         extra = false,    -- Disable extra mappings
         extended = false, -- Disable extended mappings
      },
   },
   config = function()
      require('Comment').setup({
         mappings = {
            basic = false,
            extra = false,
            extended = false,
         },
      })

      -- Custom key mappings for toggling comments
      vim.api.nvim_set_keymap('n', '<leader>cc', '<cmd>lua require("Comment.api").toggle.linewise.current()<CR>',
         { noremap = true, silent = true })
      vim.api.nvim_set_keymap('x', '<leader>cc',
         '<esc><cmd>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>',
         { noremap = true, silent = true })
   end,
}
