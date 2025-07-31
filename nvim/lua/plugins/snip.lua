return {
   'hrsh7th/nvim-cmp',
   event = 'InsertEnter',
   dependencies = {
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
   },
   config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'

      -- Ladda dina Lua-baserade snippets
      require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/lua/snippets" })

      -- Init LuaSnip
      luasnip.config.setup {}

      cmp.setup {
         snippet = {
            expand = function(args)
               luasnip.lsp_expand(args.body)
            end,
         },
         completion = { completeopt = 'menu,menuone,noinsert' },
         mapping = cmp.mapping.preset.insert {
            ['<C-n>'] = cmp.mapping.select_next_item(),
            ['<C-p>'] = cmp.mapping.select_prev_item(),
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-y>'] = cmp.mapping.confirm { select = true },
            ['<C-Space>'] = cmp.mapping.complete {},
            ['<C-l>'] = cmp.mapping(function()
               if luasnip.expand_or_locally_jumpable() then
                  luasnip.expand_or_jump()
               end
            end, { 'i', 's' }),
            ['<C-h>'] = cmp.mapping(function()
               if luasnip.locally_jumpable(-1) then
                  luasnip.jump(-1)
               end
            end, { 'i', 's' }),
         },
         sources = {
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
            { name = 'path' },
         },
      }

      -- Keymaps för att byta val i choice_node manuellt
      vim.keymap.set({ "i", "s" }, "<C-j>", function()
         if luasnip.choice_active() then
            luasnip.change_choice(1)
         end
      end, { desc = "LuaSnip: Next Choice" })

      vim.keymap.set({ "i", "s" }, "<C-k>", function()
         if luasnip.choice_active() then
            luasnip.change_choice(-1)
         end
      end, { desc = "LuaSnip: Prev Choice" })
   end,
}
