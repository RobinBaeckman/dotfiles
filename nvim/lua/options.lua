-- Custom highlights for log levels
vim.cmd [[
  highlight LogLevelDEBUG guifg=#c4a4f4
  highlight LogLevelINFO guifg=#a4dc94
  highlight LogLevelERROR guifg=#ec9ca4
  highlight LogLevelUNKNOWN guifg=#808080
  highlight CursorLineHighlight guibg=#ecd49c guifg=#000000 ctermbg=yellow ctermfg=black
]]

-- Set line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable mouse support
vim.opt.mouse = 'a'

-- Don't show mode, as it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim
vim.opt.clipboard = 'unnamedplus'

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching unless \C or capital letters are used
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time for which-key popup
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Preview substitutions live, as you type
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor
vim.opt.scrolloff = 10

-- Ensure formatoptions are set correctly
vim.api.nvim_create_autocmd('BufEnter', {
   group = vim.api.nvim_create_augroup('FormatOptions', { clear = true }),
   callback = function()
      vim.opt_local.formatoptions:remove('r')
      vim.opt_local.formatoptions:remove('o')
   end,
})

-- Set tab width to 3 spaces
vim.opt.tabstop = 3
vim.opt.softtabstop = 3
vim.opt.shiftwidth = 3
vim.opt.expandtab = true

-- Enable auto indentation
vim.opt.autoindent = true
vim.opt.smartindent = true
