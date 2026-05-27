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

local function configure_conjure()
  -- Conjure defaults made explicit for quick reference.
  -- <localleader> is `,` in this config.
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
  local conjure_config = require("conjure.config")
  local editor = require("conjure.editor")
  local default_display_hud = hook.get("display-hud")
  local repl_split_column_threshold = 128
  local resize_generation = 0

  local function open_log_window()
    if vim.o.columns < repl_split_column_threshold then
      return log.split()
    end

    return log.vsplit()
  end

  local function desired_log_open_cmd()
    if vim.o.columns < repl_split_column_threshold then
      return "split"
    end

    return "vsplit"
  end

  local function visible_log_windows()
    local wins = {}
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      if win ~= log.state.hud.id then
        local buf = vim.api.nvim_win_get_buf(win)
        local name = vim.api.nvim_buf_get_name(buf)
        if name ~= "" and log["log-buf?"](name) then
          wins[#wins + 1] = win
        end
      end
    end
    return wins
  end

  local function resize_visible_log_windows(wins, open_cmd)
    local size
    local set_size

    if open_cmd == "split" then
      local height = conjure_config["get-in"]({ "log", "split", "height" })
      if height then
        size = editor["percent-height"](height)
        set_size = vim.api.nvim_win_set_height
      end
    elseif open_cmd == "vsplit" then
      local width = conjure_config["get-in"]({ "log", "split", "width" })
      if width then
        size = editor["percent-width"](width)
        set_size = vim.api.nvim_win_set_width
      end
    end

    if not size or not set_size then
      return
    end

    for _, win in ipairs(wins) do
      if vim.api.nvim_win_is_valid(win) then
        pcall(set_size, win, size)
      end
    end
  end

  local function refresh_visible_log_layout()
    local wins = visible_log_windows()
    if vim.tbl_isempty(wins) then
      return
    end

    local desired = desired_log_open_cmd()
    if log.state["last-open-cmd"] == desired then
      resize_visible_log_windows(wins, desired)
      return
    end

    local current_win = vim.api.nvim_get_current_win()
    log["close-visible"]()
    open_log_window()

    if vim.api.nvim_win_is_valid(current_win) then
      vim.api.nvim_set_current_win(current_win)
    end
  end

  hook.override("display-hud", function(opts)
    if vim.bo.filetype ~= "clojure" then
      if default_display_hud then
        return default_display_hud(opts)
      end
      return
    end

    local current_win = vim.api.nvim_get_current_win()
    open_log_window()

    if vim.api.nvim_win_is_valid(current_win) then
      vim.api.nvim_set_current_win(current_win)
    end
  end)

  local group = vim.api.nvim_create_augroup("ConjureLogResizeLayout", { clear = true })
  vim.api.nvim_create_autocmd("VimResized", {
    group = group,
    callback = function()
      resize_generation = resize_generation + 1
      local generation = resize_generation
      vim.defer_fn(function()
        if generation ~= resize_generation then
          return
        end
        refresh_visible_log_layout()
      end, 50)
    end,
  })
end

local clojure_root_markers = {
  ".nrepl-port",
  ".shadow-cljs/nrepl.port",
  "deps.edn",
  "project.clj",
  "bb.edn",
  "shadow-cljs.edn",
  ".git",
}
local clojure_port_markers = { ".nrepl-port", ".shadow-cljs/nrepl.port" }
local clojure_connect_pending = false

local function clojure_buf_path(bufnr)
  local path = vim.api.nvim_buf_get_name(bufnr)
  if path == "" then
    return nil
  end
  return vim.fs.normalize(path)
end

local function clojure_buf_root(bufnr)
  local path = clojure_buf_path(bufnr)
  if not path then
    return nil
  end
  return vim.fs.root(path, clojure_root_markers) or vim.fs.dirname(path)
end

local function clojure_port_file(bufnr)
  local path = clojure_buf_path(bufnr)
  if not path then
    return nil
  end

  return vim.fs.find(clojure_port_markers, {
    path = vim.fs.dirname(path),
    upward = true,
  })[1]
end

local function with_root_cwd(root, f)
  if not root then
    return f()
  end

  local win = vim.api.nvim_get_current_win()
  return vim.api.nvim_win_call(win, function()
    local had_local_dir = vim.fn.haslocaldir(0, 0) == 1
    local previous_dir = had_local_dir and vim.fn.getcwd() or vim.fn.getcwd(-1, -1)

    vim.cmd("lcd " .. vim.fn.fnameescape(root))
    local ok, result = pcall(f)
    vim.cmd((had_local_dir and "lcd " or "cd ") .. vim.fn.fnameescape(previous_dir))

    if not ok then
      error(result)
    end

    return result
  end)
end

local function retry_clojure_connect(connect_fn, state, remaining)
  local conn = state.get().conn
  if (conn and conn["ready?"]) or remaining <= 0 then
    clojure_connect_pending = false
    return
  end

  vim.defer_fn(function()
    local next_conn = state.get().conn
    if next_conn and next_conn["ready?"] then
      clojure_connect_pending = false
      return
    end

    if not next_conn then
      connect_fn()
    end

    retry_clojure_connect(connect_fn, state, remaining - 1)
  end, 250)
end

local function maybe_autoconnect_clojure(bufnr)
  if vim.bo[bufnr].filetype ~= "clojure" or clojure_connect_pending then
    return
  end

  local ok_action, action = pcall(require, "conjure.client.clojure.nrepl.action")
  local ok_server, server = pcall(require, "conjure.client.clojure.nrepl.server")
  local ok_auto_repl, auto_repl = pcall(require, "conjure.client.clojure.nrepl.auto-repl")
  local ok_state, state = pcall(require, "conjure.client.clojure.nrepl.state")
  if not (ok_action and ok_server and ok_auto_repl and ok_state) or server["connected?"]() then
    return
  end

  clojure_connect_pending = true
  local port_file = clojure_port_file(bufnr)

  if port_file then
    local function connect_existing_repl()
      action["connect-port-file"]({
        ["silent?"] = true,
      })
    end

    connect_existing_repl()
    retry_clojure_connect(connect_existing_repl, state, 4)
    return
  end

  local root = clojure_buf_root(bufnr)
  local function connect_auto_repl()
    with_root_cwd(root, function()
      auto_repl["upsert-auto-repl-proc"]()

      local port = state.get()["auto-repl-port"]
      if port then
        action["connect-host-port"]({
          host = "127.0.0.1",
          port = tostring(port),
        })
      end
    end)
  end

  with_root_cwd(root, function()
    auto_repl["upsert-auto-repl-proc"]()
  end)
  vim.defer_fn(function()
    connect_auto_repl()
    retry_clojure_connect(connect_auto_repl, state, 8)
  end, 1000)
end

local function setup_clojure_autoconnect()
  local group = vim.api.nvim_create_augroup("ConjureClojureAutoConnect", { clear = true })
  vim.api.nvim_create_autocmd("BufEnter", {
    group = group,
    pattern = { "*" },
    callback = function(event)
      maybe_autoconnect_clojure(event.buf)
    end,
  })

  vim.schedule(function()
    maybe_autoconnect_clojure(vim.api.nvim_get_current_buf())
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

local function setup_clojure_wrap_mapping()
  local function set_wrap_keymap(bufnr)
    vim.keymap.set("n", "<leader>i", function()
      require("util.ts-node-action").wrap_clojure_form()
    end, {
      buffer = bufnr,
      silent = true,
      desc = "Wrap current Clojure form",
    })
  end

  local group = vim.api.nvim_create_augroup("ClojureWrapFormMapping", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = { "clojure", "edn" },
    callback = function(event)
      set_wrap_keymap(event.buf)
    end,
  })

  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(bufnr) then
      local filetype = vim.bo[bufnr].filetype
      if filetype == "clojure" or filetype == "edn" then
        set_wrap_keymap(bufnr)
      end
    end
  end
end

return {
  {
    "Olical/conjure",
    ft = conjure_filetypes,
    init = configure_conjure,
    config = function()
      configure_conjure_output()
      setup_clojure_autoconnect()
      setup_clojure_wrap_mapping()
    end,
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
    opts = {
      use_default_keys = true,
      indent = { enabled = true },
    },
  },
}
