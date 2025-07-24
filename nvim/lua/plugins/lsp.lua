return {
   'neovim/nvim-lspconfig',
   dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      { 'williamboman/mason.nvim',           config = true },
      { 'williamboman/mason-lspconfig.nvim', config = true },
   },
   config = function()
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

         keymap('n', 'gd', vim.lsp.buf.definition, opts)
         keymap('n', 'K', vim.lsp.buf.hover, opts)
         keymap('n', '<leader>rn', vim.lsp.buf.rename, opts)
         keymap('n', '<leader>ca', vim.lsp.buf.code_action, opts)
         keymap('n', '[d', vim.diagnostic.goto_prev, opts)
         keymap('n', ']d', vim.diagnostic.goto_next, opts)
         vim.keymap.set('n', '<leader>e', function()
            local wininfo = vim.fn.getwininfo()
            for _, win in ipairs(wininfo) do
               if win.loclist == 1 then
                  vim.cmd('lclose')
                  return
               end
            end
            vim.diagnostic.setloclist({ open = true })
         end, { noremap = true, silent = true, desc = "Toggle diagnostic location list" })

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
