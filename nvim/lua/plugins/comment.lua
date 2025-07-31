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
      local comment_api = require("Comment.api")

      require('Comment').setup({
         mappings = {
            basic = false,
            extra = false,
            extended = false,
         },
      })

      -- 🗒️ Comment keymaps (with desc for Telescope keymap list)
      vim.keymap.set('n', '<leader>cc', comment_api.toggle.linewise.current,
         { noremap = true, silent = true, desc = "Comment: Toggle current line" })

      vim.keymap.set('x', '<leader>cc', function()
         -- Escape visual mode and toggle selected lines
         vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
         comment_api.toggle.linewise(vim.fn.visualmode())
      end, {
         noremap = true,
         silent = true,
         desc = "Comment: Toggle selected lines",
      })
   end,
}
