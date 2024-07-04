return {
   'neovim/nvim-lspconfig',
   dependencies = {
      {
         'williamboman/mason.nvim',
         opts = {
            ensure_installed = {
               "gopls",
               "lua-language-server",
               "yaml-language-server",
               "golangci-lint-langserver"
            },
         },
      },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      { 'folke/neodev.nvim', opts = {} },
   },
   config = function()
      -- Customizing client capabilities to disable didChangeWatchedFiles
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      if capabilities.workspace and capabilities.workspace.didChangeWatchedFiles then
         capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false
      end
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      local function setup_format_on_save(client, bufnr)
         if client.server_capabilities.documentFormattingProvider then
            vim.api.nvim_create_autocmd('BufWritePre', {
               buffer = bufnr,
               callback = function()
                  vim.lsp.buf.format { async = false }
               end,
            })
         end
      end

      local function on_attach(client, bufnr)
         local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
         local opts = { noremap = true, silent = true }

         buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
         buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
         buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
         buf_set_keymap('n', 'gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>', opts)
         buf_set_keymap('n', '<C-k>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
         buf_set_keymap('n', '<leader>wa', '<Cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
         buf_set_keymap('n', '<leader>wr', '<Cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
         buf_set_keymap('n', '<leader>wl', '<Cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
         buf_set_keymap('n', '<leader>D', '<Cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
         buf_set_keymap('n', '<leader>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>', opts)
         buf_set_keymap('n', 'gr', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)
         buf_set_keymap('n', '<leader>ca', '<Cmd>lua vim.lsp.buf.code_action()<CR>', opts)
         buf_set_keymap('n', '<leader>e', '<Cmd>lua vim.diagnostic.open_float()<CR>', opts)
         buf_set_keymap('n', '[d', '<Cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
         buf_set_keymap('n', ']d', '<Cmd>lua vim.diagnostic.goto_next()<CR>', opts)
         buf_set_keymap('n', '<leader>ds', '<Cmd>lua vim.diagnostic.setloclist()<CR>', opts)
         vim.cmd [[ command! Format execute 'lua vim.lsp.buf.format()' ]]
         setup_format_on_save(client, bufnr)
      end

      local servers = {
         gopls = {
            on_attach = function(client, bufnr)
               on_attach(client, bufnr)
               setup_format_on_save(client, bufnr)
               if client.server_capabilities.codeActionProvider then
                  vim.api.nvim_create_autocmd('BufWritePre', {
                     buffer = bufnr,
                     callback = function()
                        vim.lsp.buf.code_action({
                           context = {
                              only = { "source.organizeImports" },
                              diagnostics = {}
                           },
                           apply = true,
                        })
                     end,
                  })
               end
            end,
            capabilities = capabilities,
            settings = {
               gopls = {
                  gofumpt = true,
                  staticcheck = true,
                  analyses = {
                     unusedparams = true,
                     shadow = true,
                  },
               },
            },
         },
         lua_ls = {
            on_attach = on_attach,
            capabilities = capabilities,
            settings = {
               Lua = {
                  diagnostics = {
                     globals = { 'vim' },
                  },
                  workspace = {
                     library = vim.api.nvim_get_runtime_file("", true),
                     checkThirdParty = false,
                  },
                  telemetry = {
                     enable = false,
                  },
               },
            },
         },
         yamlls = {
            on_attach = function(client, bufnr)
               if client.name == "yamlls" then
                  client.server_capabilities.documentFormattingProvider = true
               end
               on_attach(client, bufnr)
               setup_format_on_save(client, bufnr)
            end,
            capabilities = capabilities,
            settings = {
               yaml = {
                  schemas = {
                     ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*.{yml,yaml}",
                     ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
                     ["https://json.schemastore.org/helmfile"] = "helmfile.{yml,yaml}",
                     ["https://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
                     ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
                  },
                  format = {
                     enable = true,
                  },
               },
            },
         },
         golangci_lint_ls = {
            on_attach = function(client, bufnr)
               on_attach(client, bufnr)
               setup_format_on_save(client, bufnr)
            end,
            capabilities = capabilities,
            cmd = { "golangci-lint-langserver" },
            init_options = {
               command = { "golangci-lint", "run", "--config", "~/.config/golangci/config.yaml", "--out-format", "json", "--issues-exit-code=1" }
            },
            filetypes = { 'go', 'gomod' },
         },
      }

      require('mason').setup()
      require('mason-tool-installer').setup {
         ensure_installed = vim.tbl_keys(servers),
      }

      require('mason-lspconfig').setup {
         handlers = {
            function(server_name)
               local server = servers[server_name] or {}
               server.on_attach = server.on_attach or on_attach
               server.capabilities = server.capabilities or capabilities
               require('lspconfig')[server_name].setup(server)
            end,
         },
      }
   end,
}
