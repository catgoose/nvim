local clojure = require("util.clojure")

--[[
Paredit
  Use this for editing structure safely.
  `<localleader>` is `,` in this config.

  | Keys | Kind | Meaning | When to use |
  |---|---|---|---|
  | ( | motion | jump to parent form start | you’re nested deep and want the opening ( of the enclosing expr |
  | ) | motion | jump to parent form end | same, but to the closing boundary |
  | af | text object | around form | delete/yank/change a whole expression |
  | if | text object | inside form | rewrite contents but keep delimiters |
  | ae | text object | around element | operate on one child within a form |
  | ie | text object | inside element | usually for strings/symbol-ish element edits |
  | >) | edit op | slurp forwards | current form should include the next sibling |
  | <) | edit op | barf forwards | current form includes too much; push last child out |
  | >e | edit op | drag element right | reorder one argument / item / map pair |
  | <e | edit op | drag element left | same, opposite direction |
  | >f | edit op | drag form right | move a whole nested expression right |
  | <f | edit op | drag form left | same, opposite direction |
  | <localleader>o | edit op | raise form | remove one outer wrapper and keep the current form |
  | <localleader>O | edit op | raise element | unwrap one element from its enclosing form |
  | <leader>i | edit op | wrap current form | add one outer list; on lists, leave insertion point for a new head |
]]

--[[
Conjure
  Use this for REPL/eval workflow.
  `<localleader>` is `,`; `<leader>k` remains a fast current-form eval alias.

  | Keys | Kind | Meaning | When to use |
  |---|---|---|---|
  | :ConjureSchool | command | interactive tutorial | first-time onboarding |
  | <leader>k | eval | eval current form | fastest current-form eval |
  | <localleader>ee | eval | eval current form | canonical Conjure mapping |
  | <localleader>er | eval | eval root/enclosing form | eval whole defn, let, etc. |
  | <localleader>ew | eval | eval word under cursor | inspect a var quickly |
  | <localleader>e! | eval/edit | eval and replace form with result | quick experimentation / reduction |
  | <localleader>E | eval | eval visual selection or motion | eval exactly a region you choose |
  | <localleader>eb | eval | eval buffer contents | push current unsaved buffer to REPL |
  | <localleader>ef | eval | eval file from disk | reload saved file |
  | <localleader>ls | log | open log split | inspect results persistently |
  | <localleader>lv | log | open log vsplit | same, vertical |
  | <localleader>lg | log | toggle log | quick show/hide |
  | <localleader>ll | log | jump to latest log entry | follow newest result |
  | <localleader>cf | connection | connect using .nrepl-port | attach to project REPL |
  | <localleader>cd | connection | disconnect | leave current REPL |
  | <localleader>car | connection | restart auto-REPL | restart hidden bb fallback |
  | <localleader>vs | inspect | view source of symbol | inspect implementation |
  | <localleader>ve | inspect | view last exception | debug failed eval |
  | <localleader>x1 | inspect | macroexpand-1 | inspect one macro step |
  | <localleader>xr | inspect | macroexpand | inspect macro output |
  | <localleader>xa | inspect | macroexpand-all | deeper macro debugging |
  | <localleader>tn | test | run current namespace tests | normal test loop |
  | <localleader>tc | test | run current test | tight test-focused iteration |
  | <localleader>rr | refresh | refresh changed namespaces | common reload flow |
  | <localleader>ra | refresh | refresh all namespaces | full refresh |
]]

return {
  {
    "Olical/conjure",
    ft = clojure.conjure_filetypes,
    init = clojure.configure_conjure,
    config = function()
      clojure.configure_conjure_output()
      clojure.setup_autoconnect()
      clojure.setup_wrap_mapping()
    end,
    dependencies = {
      "PaterJason/cmp-conjure",
    },
    lazy = true,
  },
  {
    "PaterJason/cmp-conjure",
    ft = clojure.conjure_filetypes,
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
      local group = vim.api.nvim_create_augroup("cmp_conjure_clojure", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = clojure.conjure_filetypes,
        callback = clojure.setup_cmp_conjure,
      })
    end,
    lazy = true,
  },
  {
    "julienvincent/nvim-paredit",
    enabled = false,
    ft = clojure.lisp_filetypes,
    opts = {
      use_default_keys = true,
      indent = { enabled = true },
    },
  },
  {
    "gpanders/nvim-parinfer",
    ft = clojure.lisp_filetypes,
  },
  {
    "https://gitlab.com/HiPhish/rainbow-delimiters.nvim",
    name = "rainbow-delimiters.nvim",
    ft = { "clojure" },
    submodules = false,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    enabled = false,
    init = function()
      vim.g.rainbow_delimiters = {
        strategy = {
          [""] = "rainbow-delimiters.strategy.global",
        },
        query = {
          [""] = "rainbow-delimiters",
        },
        whitelist = { "clojure" },
        condition = function(bufnr)
          return vim.bo[bufnr].filetype == "clojure"
        end,
      }
    end,
    config = function()
      local ok, lib = pcall(require, "rainbow-delimiters.lib")
      if ok and vim.bo.filetype == "clojure" then
        lib.attach(vim.api.nvim_get_current_buf())
      end
    end,
  },
}
