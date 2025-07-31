return {
   {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      dependencies = {
         "nvim-treesitter/playground",
         "nvim-treesitter/nvim-treesitter-textobjects",
      },
      opts = {
         ensure_installed = {
            "go", "bash", "c", "diff", "html", "lua", "luadoc", "markdown",
            "vim", "vimdoc", "yaml"
         },
         auto_install = true,
         highlight = {
            enable = true,
            additional_vim_regex_highlighting = { "ruby" },
         },
         indent = {
            enable = true,
            disable = { "ruby" },
         },
         textobjects = {
            select = {
               enable = true,
               lookahead = true, -- Automatically jump forward to textobj
               keymaps = {
                  -- Function
                  ["af"] = "@function.outer",
                  ["if"] = "@function.inner",
                  -- Class (for OOP langs)
                  ["ac"] = "@class.outer",
                  ["ic"] = "@class.inner",
                  -- Block
                  ["ab"] = "@block.outer",
                  ["ib"] = "@block.inner",
                  -- Parameter
                  ["aa"] = "@parameter.outer",
                  ["ia"] = "@parameter.inner",
               },
            },
            move = {
               enable = true,
               set_jumps = true,
               goto_next_start = {
                  ["]m"] = "@function.outer",
                  ["]]"] = "@class.outer",
               },
               goto_previous_start = {
                  ["[m"] = "@function.outer",
                  ["[["] = "@class.outer",
               },
            },
            swap = {
               enable = true,
               swap_next = {
                  ["<leader>a"] = "@parameter.inner",
               },
               swap_previous = {
                  ["<leader>A"] = "@parameter.inner",
               },
            },
         },
      },
      config = function(_, opts)
         require("nvim-treesitter.install").prefer_git = true
         require("nvim-treesitter.configs").setup(opts)
      end,
   },
}
