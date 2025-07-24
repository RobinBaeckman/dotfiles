return {
   {
      'catppuccin/nvim',
      name = 'catppuccin',
      priority = 1000,
      config = function()
         require('catppuccin').setup({
            flavour = "mocha",
            transparent_background = false,
            term_colors = true,
            color_overrides = {
               mocha = {
                  base = "#141423",
                  mantle = "#141423",
                  crust = "#141423",
               },
            },
            integrations = {
               treesitter = true,
               gitsigns = true,
               telescope = true,
               nvimtree = {
                  enabled = true,
                  show_root = true,
               },
            },
         })
         vim.cmd.colorscheme 'catppuccin'
      end,
   },
}
