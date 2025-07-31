return {
   "folke/flash.nvim",
   event = "VeryLazy",
   opts = {},
   keys = {
      {
         "s",
         mode = { "n", "x", "o" },
         function() require("flash").jump() end,
         desc = "Flash: Jump to location",
      },
      {
         "S",
         mode = { "n", "x", "o" },
         function() require("flash").treesitter() end,
         desc = "Flash: Jump using Treesitter",
      },
      {
         "r",
         mode = "o",
         function() require("flash").remote() end,
         desc = "Flash: Remote jump",
      },
      {
         "R",
         mode = { "o", "x" },
         function() require("flash").treesitter_search() end,
         desc = "Flash: Treesitter search",
      },
      {
         "<C-s>",
         mode = { "c" },
         function() require("flash").toggle() end,
         desc = "Flash: Toggle Flash Search in command mode",
      },
   },
}
