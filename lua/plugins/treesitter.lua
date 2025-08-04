local config = function()
  local opts = {
    ensure_installed = {
      "angular",
      "bash",
      "c",
      "css",
      "csv",
      "dap_repl",
      "dockerfile",
      "fish",
      "git_config",
      "git_rebase",
      "gitattributes",
      "gitcommit",
      "gitignore",
      "go",
      "html",
      "http",
      "javascript",
      "jq",
      "json",
      "jsonc",
      "lua",
      "luap",
      "make",
      "markdown",
      "markdown_inline",
      "python",
      "query",
      "regex",
      "scheme",
      "scss",
      "sql",
      "templ",
      "toml",
      "typescript",
      "vim",
      "vimdoc",
      "vue",
      "xml",
      "yaml",
    },
    highlight = {
      enable = true,
    },
    matchup = {
      enable = true,
    },
    {
      context_commentstring = {
        enable = true,
        enable_autocmd = true,
      },
    },
    textobjects = {
      lsp_interop = {
        enable = true,
        border = "rounded",
        floating_preview_opts = {},
        -- peek_definition_code = {
        -- 	["<leader>df"] = "@function.outer",
        -- 	["<leader>dF"] = "@class.outer",
        -- },
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          ["]f"] = "@function.outer",
          ["]e"] = "@function_field",
          ["]s"] = "@method_object_call",
          ["]c"] = "@class.outer",
          ["]w"] = "@parameter.inner",
          ["]d"] = "@block.inner",
          ["]a"] = "@attribute.inner",

          -- ["]b"] = { query = "@scope", query_group = "locals" },
          -- ["]o"] = "@object_declaration",
          -- ["]k"] = "@object_key",
          -- ["]v"] = "@object_value",
          -- ["]m"] = "@this_method_call",
        },
        goto_previous_start = {
          ["[f"] = "@function.outer",
          ["[e"] = "@function_field",
          ["[s"] = "@method_object_call",
          ["[w"] = "@parameter.inner",
          ["[d"] = "@block.inner",
          ["[a"] = "@attribute.inner",
          ["[c"] = "@class.outer",

          -- ["[b"] = { query = "@scope", query_group = "locals" },
          -- ["[o"] = "@object_declaration",
          -- ["[k"] = "@object_key",
          -- ["[v"] = "@object_value",
          -- ["[m"] = "@this_method_call",
        },
      },
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ib"] = "@parameter.inner",
          ["ab"] = "@parameter.outer",
          ["id"] = "@block.inner",
          ["ad"] = "@block.outer",
          ["ac"] = "@call.outer",
          ["ic"] = "@call.inner",
          ["aC"] = "@class.outer",
          ["iC"] = "@class.inner",
          ["iB"] = "@block.inner",
          ["aB"] = "@block.outer",
          ["il"] = "@loop.inner",
          ["al"] = "@loop.outer",
          ["ia"] = "@attribute.inner",
          ["aa"] = "@attribute.outer",
        },
      },
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        node_incremental = "v",
        node_decremental = "V",
        init_selection = "<C-y>",
        -- scope_incremental = "<C-v>",
      },
    },
  }

  require("nvim-treesitter.configs").setup(opts)

  vim.treesitter.language.register("markdown", "octo")

  local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
  -- k({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
  -- k({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    config = config,
    lazy = true,
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "JoosepAlviste/nvim-ts-context-commentstring",
      "CKolkey/ts-node-action",
      {
        "nvim-treesitter/nvim-treesitter-context",
        config = true,
        event = "BufReadPost",
        lazy = true,
      },
      {
        "bennypowers/template-literal-comments.nvim",
        opts = true,
        ft = {
          "javascript",
          "typescript",
        },
      },
      {
        "LiadOz/nvim-dap-repl-highlights",
        config = true,
      },
    },
  },
}
