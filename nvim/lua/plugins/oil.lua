return {
   "stevearc/oil.nvim",
   opts = {},
   dependencies = { "nvim-tree/nvim-web-devicons" },
   config = function()
      local oil = require("oil")
      local actions = require("oil.actions")

      oil.setup({
         default_file_explorer = true,
         delete_to_trash = true,
         skip_confirm_for_simple_edits = true,
         view_options = {
            show_hidden = true,
            natural_order = true,
            is_always_hidden = function(name, _)
               return name == ".." or name == ".git"
            end,
         },
         float = {
            padding = 2,
            max_width = 90,
            max_height = 0,
         },
         win_options = {
            wrap = true,
            winblend = 0,
         },
         keymaps = {
            ["<C-c>"] = false,
            ["q"] = "actions.close",
         },
      })

      -- 📁 Oil keymaps (with desc for Telescope keymap list)
      vim.keymap.set("n", "<leader>cd", actions.cd.callback, {
         noremap = true,
         silent = true,
         desc = "Oil: Set cwd to current directory",
      })

      vim.keymap.set("n", "-", oil.open_float, {
         noremap = true,
         silent = true,
         desc = "Oil: Open floating directory view",
      })
   end,
}
