return {
   'nvim-treesitter/nvim-treesitter',
   build = ':TSUpdate',
   dependencies = {
      "nvim-treesitter/playground",
   },
   opts = {
      ensure_installed = { 'go', 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'vim', 'vimdoc', 'yaml' },
      auto_install = true,
      highlight = {
         enable = true,
         additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
   },
   config = function(_, opts)
      require('nvim-treesitter.install').prefer_git = true
      require('nvim-treesitter.configs').setup(opts)
   end,
}
