local conjure_filetypes = {
  "clojure",
  "fennel",
  "scheme",
  "lisp",
  "racket",
  "lua",
}

--[[
Paredit
  Use this for editing structure safely.

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
  | <space>kr | edit op | raise form | remove one outer wrapper and keep the current form |
  | <space>kR | edit op | raise element | unwrap one element from its enclosing form |
]]

--[[ 
Conjure
  Use this for REPL/eval workflow.

  | Keys | Kind | Meaning | When to use |
  |---|---|---|---|
  | :ConjureSchool | command | interactive tutorial | first-time onboarding |
  | <space>ee | eval | eval current form | most common command while editing |
  | <space>er | eval | eval root/enclosing form | eval whole defn, let, etc. |
  | <space>ew | eval | eval word under cursor | inspect a var quickly |
  | <space>e! | eval/edit | eval and replace form with result | quick experimentation / reduction |
  | <space>E | eval | eval visual selection or motion | eval exactly a region you choose |
  | <space>eb | eval | eval buffer contents | push current unsaved buffer to REPL |
  | <space>ef | eval | eval file from disk | reload saved file |
  | <space>ls | log | open log split | inspect results persistently |
  | <space>lv | log | open log vsplit | same, vertical |
  | <space>lg | log | toggle log | quick show/hide |
  | <space>ll | log | jump to latest log entry | follow newest result |
  | <space>cf | connection | connect using .nrepl-port | attach to project REPL |
  | <space>cd | connection | disconnect | leave current REPL |
  | <space>car | connection | restart auto-REPL | restart hidden bb fallback |
  | <space>vs | inspect | view source of symbol | inspect implementation |
  | <space>ve | inspect | view last exception | debug failed eval |
  | <space>x1 | inspect | macroexpand-1 | inspect one macro step |
  | <space>xr | inspect | macroexpand | inspect macro output |
  | <space>xa | inspect | macroexpand-all | deeper macro debugging |
  | <space>tn | test | run current namespace tests | normal test loop |
  | <space>tc | test | run current test | tight test-focused iteration |
  | <space>rr | refresh | refresh changed namespaces | common reload flow |
  | <space>ra | refresh | refresh all namespaces | full refresh |
]]

local function configure_conjure()
  -- Conjure defaults made explicit for quick reference.
  -- <localleader> is <Space> in this config.
  vim.g["conjure#mapping#prefix"] = "<localleader>"
  vim.g["conjure#mapping#log_split"] = "ls"
  vim.g["conjure#mapping#log_vsplit"] = "lv"
  vim.g["conjure#mapping#log_tab"] = "lt"
  vim.g["conjure#mapping#log_buf"] = "le"
  vim.g["conjure#mapping#log_toggle"] = "lg"
  vim.g["conjure#mapping#log_close_visible"] = "lq"
  vim.g["conjure#mapping#log_reset_soft"] = "lr"
  vim.g["conjure#mapping#log_reset_hard"] = "lR"
  vim.g["conjure#mapping#log_jump_to_latest"] = "ll"
  vim.g["conjure#mapping#eval_current_form"] = "ee"
  vim.g["conjure#mapping#eval_comment_current_form"] = "ece"
  vim.g["conjure#mapping#eval_root_form"] = "er"
  vim.g["conjure#mapping#eval_comment_root_form"] = "ecr"
  vim.g["conjure#mapping#eval_word"] = "ew"
  vim.g["conjure#mapping#eval_comment_word"] = "ecw"
  vim.g["conjure#mapping#eval_replace_form"] = "e!"
  vim.g["conjure#mapping#eval_marked_form"] = "em"
  vim.g["conjure#mapping#eval_file"] = "ef"
  vim.g["conjure#mapping#eval_buf"] = "eb"
  vim.g["conjure#mapping#eval_visual"] = "E"
  vim.g["conjure#mapping#eval_motion"] = "E"
  vim.g["conjure#mapping#eval_previous"] = "ep"
  vim.g["conjure#mapping#def_word"] = "gd"
  vim.g["conjure#mapping#doc_word"] = false
  vim.g["conjure#log#botright"] = true
  vim.g["conjure#log#split#height"] = 0.3

  -- Clojure nREPL defaults.
  vim.g["conjure#filetype#clojure"] = "conjure.client.clojure.nrepl"
  -- Use Conjure's built-in hidden Babashka auto-REPL as a fallback for quick
  -- scratch evaluation. Project REPLs can still live in tmux or a visible
  -- terminal and Conjure will stop the auto-REPL after connecting elsewhere.
  vim.g["conjure#client#clojure#nrepl#connection#auto_repl#enabled"] = true
  vim.g["conjure#client#clojure#nrepl#connection#auto_repl#hidden"] = true
  vim.g["conjure#client#clojure#nrepl#connection#auto_repl#cmd"] = "bb nrepl-server localhost:$port"
  vim.g["conjure#client#clojure#nrepl#connection#auto_repl#port_file"] = ".nrepl-port"
  vim.g["conjure#client#clojure#nrepl#connection#auto_repl#stop_on_new_conn"] = true
  vim.g["conjure#client#clojure#nrepl#mapping#disconnect"] = "cd"
  vim.g["conjure#client#clojure#nrepl#mapping#connect_port_file"] = "cf"
  vim.g["conjure#client#clojure#nrepl#mapping#interrupt"] = "ei"
  vim.g["conjure#client#clojure#nrepl#mapping#macro_expand_1"] = "x1"
  vim.g["conjure#client#clojure#nrepl#mapping#macro_expand"] = "xr"
  vim.g["conjure#client#clojure#nrepl#mapping#macro_expand_all"] = "xa"
  vim.g["conjure#client#clojure#nrepl#mapping#last_exception"] = "ve"
  vim.g["conjure#client#clojure#nrepl#mapping#result_1"] = "v1"
  vim.g["conjure#client#clojure#nrepl#mapping#result_2"] = "v2"
  vim.g["conjure#client#clojure#nrepl#mapping#result_3"] = "v3"
  vim.g["conjure#client#clojure#nrepl#mapping#view_source"] = "vs"
  vim.g["conjure#client#clojure#nrepl#mapping#view_tap"] = "vt"
  vim.g["conjure#client#clojure#nrepl#mapping#session_clone"] = "sc"
  vim.g["conjure#client#clojure#nrepl#mapping#session_fresh"] = "sf"
  vim.g["conjure#client#clojure#nrepl#mapping#session_close"] = "sq"
  vim.g["conjure#client#clojure#nrepl#mapping#session_close_all"] = "sQ"
  vim.g["conjure#client#clojure#nrepl#mapping#session_list"] = "sl"
  vim.g["conjure#client#clojure#nrepl#mapping#session_next"] = "sn"
  vim.g["conjure#client#clojure#nrepl#mapping#session_prev"] = "sp"
  vim.g["conjure#client#clojure#nrepl#mapping#session_select"] = "ss"
  vim.g["conjure#client#clojure#nrepl#mapping#run_all_tests"] = "ta"
  vim.g["conjure#client#clojure#nrepl#mapping#run_current_ns_tests"] = "tn"
  vim.g["conjure#client#clojure#nrepl#mapping#run_alternate_ns_tests"] = "tN"
  vim.g["conjure#client#clojure#nrepl#mapping#run_current_test"] = "tc"
  vim.g["conjure#client#clojure#nrepl#mapping#refresh_changed"] = "rr"
  vim.g["conjure#client#clojure#nrepl#mapping#refresh_all"] = "ra"
  vim.g["conjure#client#clojure#nrepl#mapping#refresh_clear"] = "rc"
  vim.g["conjure#client#clojure#nrepl#mapping#auto_repl_restart"] = "car"

  vim.g["conjure#log#hud#enabled"] = true
  vim.g["conjure#log#hud#open_when"] = "log-win-not-visible"
  vim.g["conjure#log#hud#border"] = "rounded"
  vim.g["conjure#extract#tree_sitter#enabled"] = true
end

local function configure_conjure_output()
  local hook = require("conjure.hook")
  local log = require("conjure.log")
  local default_display_hud = hook.get("display-hud")

  hook.override("display-hud", function(opts)
    if vim.bo.filetype ~= "clojure" then
      if default_display_hud then
        return default_display_hud(opts)
      end
      return
    end

    local current_win = vim.api.nvim_get_current_win()
    log.split()

    if vim.api.nvim_win_is_valid(current_win) then
      vim.api.nvim_set_current_win(current_win)
    end
  end)
end

local function setup_cmp_conjure()
  local ok_cmp, cmp = pcall(require, "cmp")
  if not ok_cmp then
    return
  end
  local existing = cmp.get_config().sources or {}
  local merged = vim.deepcopy(existing)
  table.insert(merged, { name = "conjure", group_index = 4, keyword_length = 2 })
  cmp.setup.buffer({ sources = merged })
end

return {
  {
    "Olical/conjure",
    ft = conjure_filetypes,
    init = configure_conjure,
    config = configure_conjure_output,
    dependencies = {
      "PaterJason/cmp-conjure",
    },
    lazy = true,
  },
  {
    "PaterJason/cmp-conjure",
    ft = conjure_filetypes,
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
      local group = vim.api.nvim_create_augroup("cmp_conjure_clojure", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = conjure_filetypes,
        callback = setup_cmp_conjure,
      })
    end,
    lazy = true,
  },
  {
    "julienvincent/nvim-paredit",
    ft = { "clojure", "fennel", "scheme", "lisp", "racket" },
    opts = function()
      local api = require("nvim-paredit.api")
      return {
        use_default_keys = true,
        indent = { enabled = true },
        keys = {
          -- Free <localleader>o for <leader>o (oil) since localleader == leader == <Space>.
          ["<localleader>o"] = false,
          ["<localleader>O"] = false,
          ["<localleader>kr"] = { api.raise_form, "Raise form" },
          ["<localleader>kR"] = { api.raise_element, "Raise element" },
        },
      }
    end,
  },
}
