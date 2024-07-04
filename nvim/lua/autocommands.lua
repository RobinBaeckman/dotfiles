-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
   desc = 'Highlight when yanking (copying) text',
   group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
   callback = function()
      vim.highlight.on_yank()
   end,
})

-- Format YAML files on save
vim.api.nvim_create_autocmd('BufWritePost', {
   pattern = '*.yaml',
   desc = 'Format YAML files on save',
   group = vim.api.nvim_create_augroup('FormatAutogroup', { clear = true }),
   callback = function()
      vim.lsp.buf.format({ async = true })
   end,
})

