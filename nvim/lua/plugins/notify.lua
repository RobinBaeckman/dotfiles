return {
   -- Notification display
   {
      "rcarriga/nvim-notify",
      config = function()
         vim.notify = require("notify")
         require("notify").setup({
            stages = "slide",              -- or "fade", "static", etc.
            timeout = 3000,
            background_colour = "#1e1e2e", -- tweak to match your colorscheme
         })
      end,
   },

   -- Better vim.ui.input and select popups
   {
      "stevearc/dressing.nvim",
      event = "VeryLazy",
      opts = {
         input = {
            enabled = true,
            border = "rounded",
         },
         select = {
            enabled = true,
            backend = { "telescope", "fzf", "builtin" },
         },
      },
   },

   -- LSP progress indicator
   {
      "j-hui/fidget.nvim",
      tag = "legacy",
      event = "LspAttach",
      opts = {
         text = {
            spinner = "dots",
         },
         window = {
            blend = 0,
         },
      },
   },
}
