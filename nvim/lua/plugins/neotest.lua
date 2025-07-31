return {
   "nvim-neotest/neotest",
   dependencies = {
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-go",
   },
   config = function()
      local neotest = require("neotest")

      neotest.setup({
         adapters = {
            require("neotest-go")({
               experimental = {
                  test_table = true,
               },
               args = { "-count=1", "-timeout=60s" },
            }),
         },
      })

      -- 🧪 Neotest keymaps (med desc för Telescope integration)
      vim.keymap.set("n", "<leader>tn", function() neotest.run.run() end,
         { desc = "Test: Run nearest test", noremap = true, silent = true })
      vim.keymap.set("n", "<leader>tf", function() neotest.run.run(vim.fn.expand("%")) end,
         { desc = "Test: Run current file", noremap = true, silent = true })
      vim.keymap.set("n", "<leader>td", function() neotest.run.run({ strategy = "dap" }) end,
         { desc = "Test: Debug nearest test", noremap = true, silent = true })
      vim.keymap.set("n", "<leader>to", neotest.output.open,
         { desc = "Test: Open test output", noremap = true, silent = true })
      vim.keymap.set("n", "<leader>ts", neotest.summary.toggle,
         { desc = "Test: Toggle test summary", noremap = true, silent = true })
   end,
}
