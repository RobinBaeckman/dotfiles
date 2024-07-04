local themes = {
  {
    'folke/tokyonight.nvim',
    name = 'tokyonight-night',
    priority = 1000, -- Ensure it loads first
    config = function()
      vim.cmd.colorscheme 'tokyonight-night'
    end,
  },
{
  'catppuccin/nvim',
  name = 'catppuccin',
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

local theme_names = {}
for _, theme in ipairs(themes) do
  table.insert(theme_names, theme.name)
end

return themes, theme_names
