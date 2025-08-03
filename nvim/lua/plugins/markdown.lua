return {
   {
      "MeanderingProgrammer/render-markdown.nvim",
      dependencies = {
         "nvim-treesitter/nvim-treesitter",
         "nvim-tree/nvim-web-devicons", -- eller mini.nvim om du använder det
      },
      opts = {},                     -- valfri config, tom funkar fint som default
      ft = { "markdown" },           -- valfritt men smart att lägga till
   },
}
