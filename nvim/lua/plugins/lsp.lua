return {
   'neovim/nvim-lspconfig',
   dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      { 'williamboman/mason.nvim',           config = true },
      { 'williamboman/mason-lspconfig.nvim', config = true },
      { 'folke/neodev.nvim',                 opts = {} }, -- ✅ Add this
   },
   config = function()
      require("neodev").setup({}) -- ✅ Must go before lua_ls.setup
      -- 🪧 Diagnostic icons and config
      vim.diagnostic.config({
         virtual_text = {
            prefix = '●', -- You can change to '', '▎', '■', etc.
         },
         signs = true,
         underline = true,
         update_in_insert = false,
         severity_sort = true,
      })

      local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
      for type, icon in pairs(signs) do
         local hl = "DiagnosticSign" .. type
         vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      local lspconfig = require('lspconfig')
      local util = require('lspconfig.util')
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      local function on_attach(client, bufnr)
         local opts = { noremap = true, silent = true, buffer = bufnr }
         local keymap = vim.keymap.set

         keymap('n', 'gd', vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = 'LSP: Go to definition' }))
         keymap('n', 'gD', vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = 'LSP: Go to declaration' }))
         keymap('n', 'gi', vim.lsp.buf.implementation,
            vim.tbl_extend("force", opts, { desc = 'LSP: Go to implementation' }))
         keymap('n', 'gr', vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = 'LSP: Show references' }))
         keymap('n', 'K', vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = 'LSP: Hover documentation' }))
         keymap('n', '<leader>rn', vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = 'LSP: Rename symbol' }))
         keymap('n', '<leader>ca', vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = 'LSP: Code action' }))
         keymap('n', '[d', vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, { desc = 'LSP: Previous diagnostic' }))
         keymap('n', ']d', vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = 'LSP: Next diagnostic' }))
         keymap('n', '<leader>q', vim.diagnostic.setqflist,
            vim.tbl_extend("force", opts, { desc = 'LSP: Set diagnostics to quickfix list' }))

         keymap('n', '<leader>e', function()
            local wininfo = vim.fn.getwininfo()
            for _, win in ipairs(wininfo) do
               if win.loclist == 1 then
                  vim.cmd('lclose')
                  return
               end
            end
            vim.diagnostic.setloclist({ open = true })
         end, vim.tbl_extend("force", opts, { desc = "LSP: Toggle diagnostic location list" }))

         if client.server_capabilities.documentFormattingProvider then
            vim.api.nvim_create_autocmd("BufWritePre", {
               buffer = bufnr,
               callback = function() vim.lsp.buf.format({ async = false }) end,
            })
         end

         if client.name == "gopls" and client.server_capabilities.codeActionProvider then
            vim.api.nvim_create_autocmd("BufWritePre", {
               buffer = bufnr,
               callback = function()
                  vim.lsp.buf.code_action({
                     context = { only = { "source.organizeImports" }, diagnostics = {} },
                     apply = true,
                  })
               end,
            })
         end
      end

      -- Installera LSP-servrar
      require("mason").setup()
      require("mason-lspconfig").setup({
         ensure_installed = { "gopls", "lua_ls" },
      })

      -- Konfigurera gopls
      lspconfig.gopls.setup({
         on_attach = on_attach,
         capabilities = capabilities,
         root_dir = util.root_pattern("go.work", "go.mod", ".git"),
         settings = {
            gopls = {
               gofumpt = true,
               staticcheck = true,
               analyses = { unusedparams = true, shadow = true },
            },
         },
      })

      -- Konfigurera lua_ls
      lspconfig.lua_ls.setup({
         on_attach = on_attach,
         capabilities = capabilities,
         settings = {
            Lua = {
               diagnostics = { globals = { 'vim' } },
               workspace = { library = vim.api.nvim_get_runtime_file("", true), checkThirdParty = false },
               telemetry = { enable = false },
            },
         },
      })
   end,
}
