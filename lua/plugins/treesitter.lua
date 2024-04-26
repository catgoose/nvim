local m = require("util").lazy_map
local k = vim.keymap.set

local config = function()
  local opts = {
    ensure_installed = {
      "angular",
      "awk",
      "bash",
      "c",
      "cpp",
      "css",
      "csv",
      "dockerfile",
      "fish",
      "git_config",
      "git_rebase",
      "gitattributes",
      "gitcommit",
      "gitignore",
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
      "ruby",
      "scheme",
      "scss",
      "sql",
      "toml",
      "typescript",
      "vim",
      "vimdoc",
      "vue",
      "yaml",
    },
    highlight = {
      enable = true,
    },
    matchup = {
      enable = true,
    },
    autotag = {
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
          ["]f"] = "@function.inner",
          ["]e"] = "@function.outer",
          ["]b"] = "@parameter.outer",
          ["]d"] = "@block.inner",
          ["]a"] = "@attribute.inner",
          ["]m"] = "@this_method_call",
          ["]s"] = { query = "@scope", query_group = "locals" },
          --  TODO: 2024-01-08 - this is not working in typescript files
          ["]c"] = "@method_object_call",
          ["]o"] = "@object_declaration",
          ["]k"] = "@object_key",
          ["]v"] = "@object_value",
          ["]w"] = "@method_parameter",
        },
        goto_next_end = {
          ["]F"] = "@function.inner",
          ["]E"] = "@function.outer",
          ["]B"] = "@parameter.outer",
          ["]D"] = "@block.inner",
          ["]A"] = "@attribute.inner",
          ["]M"] = "@this_method_call",
          ["]S"] = { query = "@scope", query_group = "locals" },
          ["]C"] = "@method_object_call",
          ["]O"] = "@object_declaration",
          ["]K"] = "@object_key",
          ["]V"] = "@object_value",
          ["]W"] = "@method_parameter",
        },
        goto_previous_start = {
          ["[f"] = "@function.inner",
          ["[e"] = "@function.outer",
          ["[b"] = "@parameter.outer",
          ["[d"] = "@block.inner",
          ["[a"] = "@attribute.inner",
          ["[m"] = "@this_method_call",
          ["[s"] = { query = "@scope", query_group = "locals" },
          ["[c"] = "@method_object_call",
          ["[o"] = "@object_declaration",
          ["[k"] = "@object_key",
          ["[v"] = "@object_value",
          ["[w"] = "@method_parameter",
        },
        goto_previous_end = {
          ["[F"] = "@function.inner",
          ["[E"] = "@function.outer",
          ["[B"] = "@parameter.outer",
          ["[D"] = "@block.inner",
          ["[A"] = "@attribute.inner",
          ["[M"] = "@this_method_call",
          ["[S"] = { query = "@scope", query_group = "locals" },
          ["[C"] = "@method_object_call",
          ["[O"] = "@object_declaration",
          ["[K"] = "@object_key",
          ["[V"] = "@object_value",
          ["[W"] = "@method_parameter",
        },
      },
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@call.outer",
          ["ic"] = "@call.inner",
          ["aC"] = "@class.outer",
          ["iC"] = "@class.inner",
          ["ib"] = "@parameter.inner",
          ["ab"] = "@parameter.outer",
          ["iB"] = "@block.inner",
          ["aB"] = "@block.outer",
          ["id"] = "@block.inner",
          ["ad"] = "@block.outer",
          ["il"] = "@loop.inner",
          ["al"] = "@loop.outer",
          ["ia"] = "@attribute.inner",
          ["aa"] = "@attribute.outer",
        },
      },
    },
    textsubjects = {
      enable = true,
      prev_selection = ",",
      keymaps = {
        ["."] = "textsubjects-smart",
        [";"] = "textsubjects-container-outer",
        ["i;"] = "textsubjects-container-inner",
      },
    },
    playground = {
      enable = true,
      disable = {},
      updatetime = 25,
      persist_queries = true,
      keybindings = {
        toggle_query_editor = "o",
        toggle_hl_groups = "i",
        toggle_injected_languages = "t",
        toggle_anonymous_nodes = "a",
        toggle_language_display = "I",
        focus_language = "f",
        unfocus_language = "F",
        update = "R",
        goto_node = "<cr>",
        show_help = "?",
      },
    },
    query_linter = {
      enable = true,
      use_virtual_text = true,
      lint_events = {
        "BufWrite",
        "CursorHold",
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
    lazy = false,
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "RRethy/nvim-treesitter-textsubjects",
      "JoosepAlviste/nvim-ts-context-commentstring",
      "windwp/nvim-ts-autotag",
      "CKolkey/ts-node-action",
      "nvim-treesitter/nvim-treesitter-context",
      {
        "nvim-treesitter/playground",
        cmd = "TSPlaygroundToggle",
        keys = {
          m("<leader>tp", [[TSPlaygroundToggle]]),
        },
      },
      {
        "bennypowers/template-literal-comments.nvim",
        opts = true,
        ft = {
          "javascript",
          "typescript",
        },
        enabled = true,
      },
    },
  },
}
