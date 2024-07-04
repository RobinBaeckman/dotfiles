return {
   "ThePrimeagen/harpoon",
   branch = "harpoon2",
   dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
   config = function()
      local harpoon = require("harpoon")

      -- REQUIRED
      harpoon:setup({
         global_settings = {
            save_on_toggle = false,
            save_on_change = true,
            enter_on_sendcmd = false,
            tmux_autoclose_windows = false,
            excluded_filetypes = { "harpoon" },
            mark_branch = false,
         }
      })
      -- REQUIRED

      -- Harpoon key mappings
      vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end,
         { desc = "Harpoon: Add file to harpoon list" })
      vim.keymap.set("n", "<leader>hl", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
         { desc = "Harpoon: Toggle quick menu" })
      vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end,
         { desc = "Harpoon: Navigate to file 1" })
      vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end,
         { desc = "Harpoon: Navigate to file 2" })
      vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end,
         { desc = "Harpoon: Navigate to file 3" })
      vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end,
         { desc = "Harpoon: Navigate to file 4" })
   end
}
