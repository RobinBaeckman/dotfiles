vim.g.mapleader = ','
vim.g.maplocalleader = ','

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = false

-- Load configurations from the lua directory
require("options")
require("mappings")
require("autocommands")

-- Install `lazy.nvim` plugin manager
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
   local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
   vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- Import and set up plugins
require('lazy').setup(require('plugins'), {
   ui = {
      icons = vim.g.have_nerd_font and {} or {
         cmd = '⌘',
         config = '🛠',
         event = '📅',
         ft = '📂',
         init = '⚙',
         keys = '🗝',
         plugin = '🔌',
         runtime = '💻',
         require = '🌙',
         source = '📄',
         start = '🚀',
         task = '📌',
         lazy = '💤 ',
      },
   },
})
