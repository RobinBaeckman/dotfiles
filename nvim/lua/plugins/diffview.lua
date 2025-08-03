return {
   "sindrets/diffview.nvim",
   dependencies = { "nvim-lua/plenary.nvim" },
   keys = {
      {
         "gd",
         "<cmd>DiffviewOpen<CR>",
         desc = "Diffview: Open diff (working tree vs HEAD)"
      },
      {
         "gq",
         "<cmd>DiffviewClose<CR>",
         desc = "Diffview: Close diff"
      },
      {
         "gh",
         "<cmd>DiffviewFileHistory<CR>",
         desc = "Diffview: File history (entire repo)"
      },
      {
         "gf",
         "<cmd>DiffviewFileHistory %<CR>",
         desc = "Diffview: File history (current file)"
      },
   },
}
