return {
   "nvim-pack/nvim-spectre",
   dependencies = { "nvim-lua/plenary.nvim" },
   keys = {
      {
         "<leader>sg",
         function()
            require("spectre").open()
         end,
         mode = "n",
         desc = "Spectre: Global search and replace",
      },
      {
         "<leader>ss",
         function()
            require("spectre").open_file_search()
         end,
         mode = "n",
         desc = "Spectre: Search and replace in current file",
      },
   },
   opts = {
      open_cmd = "vnew", -- vertikal split
      live_update = true, -- visa resultat direkt
      result_padding = "│ ", -- snygg kolumnvisning
      is_insert_mode = true, -- börja skriva direkt
   },
}
