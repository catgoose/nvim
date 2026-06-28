local M = {}

M.conjure_filetypes = {
  "clojure",
  "fennel",
  "scheme",
  "lisp",
  "racket",
  "lua",
}

M.lisp_filetypes = {
  "clojure",
  "fennel",
  "scheme",
  "lisp",
  "racket",
}

local root_markers = {
  ".nrepl-port",
  ".shadow-cljs/nrepl.port",
  "deps.edn",
  "project.clj",
  "bb.edn",
  "shadow-cljs.edn",
  ".git",
}

local port_markers = { ".nrepl-port", ".shadow-cljs/nrepl.port" }
local connect_pending = false

local bb_auto_repl_cmd = "bb nrepl-server localhost:$port"
local jvm_auto_repl_cmd =
  "clojure -Sdeps '{:deps {nrepl/nrepl {:mvn/version \"1.3.1\"}}}' -M -m nrepl.cmdline --port $port"

function M.configure_conjure()
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
  -- Default hidden auto-REPL command. setup_autoconnect overrides it per
  -- buffer when deps.edn needs a JVM REPL instead of Babashka.
  vim.g["conjure#client#clojure#nrepl#connection#auto_repl#enabled"] = true
  vim.g["conjure#client#clojure#nrepl#connection#auto_repl#hidden"] = true
  vim.g["conjure#client#clojure#nrepl#connection#auto_repl#cmd"] = bb_auto_repl_cmd
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

function M.configure_conjure_output()
  local hook = require("conjure.hook")
  local log = require("conjure.log")
  local conjure_config = require("conjure.config")
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
        size = math.floor(vim.o.lines * height)
        set_size = vim.api.nvim_win_set_height
      end
    elseif open_cmd == "vsplit" then
      local width = conjure_config["get-in"]({ "log", "split", "width" })
      if width then
        size = math.floor(vim.o.columns * width)
        set_size = vim.api.nvim_win_set_width
      end
    end

    if not size or not set_size then
      return
    end

    for _, win in ipairs(wins) do
      if vim.api.nvim_win_is_valid(win) then
        vim.wo[win].winfixheight = open_cmd == "split"
        vim.wo[win].winfixwidth = open_cmd == "vsplit"
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
    resize_visible_log_windows(visible_log_windows(), desired)

    if vim.api.nvim_win_is_valid(current_win) then
      vim.api.nvim_set_current_win(current_win)
    end
  end

  local function schedule_log_layout_refresh(generation, delay)
    vim.defer_fn(function()
      if generation ~= resize_generation then
        return
      end
      refresh_visible_log_layout()
    end, delay or 80)
  end

  local function schedule_log_layout_refresh_passes()
    resize_generation = resize_generation + 1
    local generation = resize_generation
    for _, delay in ipairs({ 40, 160, 320 }) do
      schedule_log_layout_refresh(generation, delay)
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
    resize_visible_log_windows(visible_log_windows(), desired_log_open_cmd())

    if vim.api.nvim_win_is_valid(current_win) then
      vim.api.nvim_set_current_win(current_win)
    end
  end)

  local group = vim.api.nvim_create_augroup("ConjureLogResizeLayout", { clear = true })
  vim.api.nvim_create_autocmd({ "VimResized", "WinNew", "WinClosed", "WinResized" }, {
    group = group,
    callback = schedule_log_layout_refresh_passes,
  })

  vim.api.nvim_create_autocmd({ "BufWinEnter", "BufWinLeave" }, {
    group = group,
    callback = function(event)
      if vim.bo[event.buf].buftype == "quickfix" then
        schedule_log_layout_refresh_passes()
      end
    end,
  })
end

local function auto_repl_cmd(root)
  if root then
    if vim.fn.filereadable(vim.fs.joinpath(root, "deps.edn")) == 1 then
      return jvm_auto_repl_cmd
    end
    if vim.fn.filereadable(vim.fs.joinpath(root, "bb.edn")) == 1 then
      return bb_auto_repl_cmd
    end
  end
  return bb_auto_repl_cmd
end

local function buf_path(bufnr)
  local path = vim.api.nvim_buf_get_name(bufnr)
  if path == "" then
    return nil
  end
  return vim.fs.normalize(path)
end

local function buf_root(bufnr)
  local path = buf_path(bufnr)
  if not path then
    return nil
  end
  return vim.fs.root(path, root_markers) or vim.fs.dirname(path)
end

local function port_file(bufnr)
  local path = buf_path(bufnr)
  if not path then
    return nil
  end

  return vim.fs.find(port_markers, {
    path = vim.fs.dirname(path),
    upward = true,
  })[1]
end

local function port_open(port, timeout_ms)
  local uv = vim.uv or vim.loop
  local client = uv.new_tcp()
  local done, open = false, false
  client:connect("127.0.0.1", port, function(err)
    open = err == nil
    done = true
    client:close()
  end)
  vim.wait(timeout_ms or 200, function()
    return done
  end, 10)
  if not done then
    pcall(function()
      if not client:is_closing() then
        client:close()
      end
    end)
  end
  return open
end

local function port_file_live(path)
  local lines = vim.fn.readfile(path, "", 1)
  local port = tonumber(lines and lines[1])
  return port ~= nil and port_open(port)
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

local function retry_connect(connect_fn, state, remaining)
  local conn = state.get().conn
  if (conn and conn["ready?"]) or remaining <= 0 then
    connect_pending = false
    return
  end

  vim.defer_fn(function()
    local next_conn = state.get().conn
    if next_conn and next_conn["ready?"] then
      connect_pending = false
      return
    end

    if not next_conn then
      connect_fn()
    end

    retry_connect(connect_fn, state, remaining - 1)
  end, 250)
end

local function connect_when_port_open(port, connect_fn, remaining)
  if port_open(port, 100) then
    connect_fn()
    connect_pending = false
    return
  end

  if remaining <= 0 then
    connect_pending = false
    return
  end

  vim.defer_fn(function()
    connect_when_port_open(port, connect_fn, remaining - 1)
  end, 250)
end

local function maybe_autoconnect(bufnr)
  if vim.bo[bufnr].filetype ~= "clojure" or connect_pending then
    return
  end

  local ok_action, action = pcall(require, "conjure.client.clojure.nrepl.action")
  local ok_server, server = pcall(require, "conjure.client.clojure.nrepl.server")
  local ok_auto_repl, auto_repl = pcall(require, "conjure.client.clojure.nrepl.auto-repl")
  local ok_state, state = pcall(require, "conjure.client.clojure.nrepl.state")
  if not (ok_action and ok_server and ok_auto_repl and ok_state) or server["connected?"]() then
    return
  end

  connect_pending = true
  local repl_port_file = port_file(bufnr)

  if repl_port_file and port_file_live(repl_port_file) then
    local function connect_existing_repl()
      action["connect-port-file"]({
        ["silent?"] = true,
      })
    end

    connect_existing_repl()
    retry_connect(connect_existing_repl, state, 4)
    return
  end

  local root = buf_root(bufnr)
  vim.b[bufnr]["conjure#client#clojure#nrepl#connection#auto_repl#cmd"] = auto_repl_cmd(root)

  local port = with_root_cwd(root, function()
    auto_repl["upsert-auto-repl-proc"]()
    return state.get()["auto-repl-port"]
  end)

  if not port then
    connect_pending = false
    return
  end

  -- JVM nREPL can take several seconds to boot; poll up to ~15s.
  connect_when_port_open(tonumber(port), function()
    action["connect-host-port"]({
      host = "127.0.0.1",
      port = tostring(port),
    })
  end, 60)
end

function M.setup_autoconnect()
  local group = vim.api.nvim_create_augroup("ConjureClojureAutoConnect", { clear = true })
  vim.api.nvim_create_autocmd("BufEnter", {
    group = group,
    pattern = { "*" },
    callback = function(event)
      maybe_autoconnect(event.buf)
    end,
  })

  vim.schedule(function()
    maybe_autoconnect(vim.api.nvim_get_current_buf())
  end)
end

function M.setup_cmp_conjure()
  local ok_cmp, cmp = pcall(require, "cmp")
  if not ok_cmp then
    return
  end
  local existing = cmp.get_config().sources or {}
  local merged = vim.deepcopy(existing)
  table.insert(merged, { name = "conjure", group_index = 4, keyword_length = 2 })
  cmp.setup.buffer({ sources = merged })
end

function M.setup_wrap_mapping()
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

return M
