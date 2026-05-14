local fn, api, cmd, diag, o, g, tbl_contains, bo, keymap =
  vim.fn, vim.api, vim.cmd, vim.diagnostic, vim.o, vim.g, vim.tbl_contains, vim.bo, vim.keymap

local M = {}

local function get_config_modules(exclude_map)
  exclude_map = exclude_map or {
    "lazy",
    "init",
  }
  local files = {}
  for _, file in ipairs(fn.glob(fn.stdpath("config") .. "/lua/config/*.lua", true, true)) do
    table.insert(files, fn.fnamemodify(file, ":t:r"))
  end
  files = vim.tbl_filter(function(file)
    for _, pattern in ipairs(exclude_map) do
      if file:match(pattern) then
        return false
      end
    end
    return true
  end, files)
  return files
end

function M.load_configs()
  for _, file in ipairs(get_config_modules()) do
    require("config." .. file)
  end
  require("config.lazy")
end

function M.reload_lua()
  for _, file in ipairs(get_config_modules()) do
    R("config." .. file)
    R("util.functions")
  end
  cmd.nohlsearch()
end

local function cmd_string(cmd_arg)
  return [[<cmd>]] .. cmd_arg .. [[<cr>]]
end

local function str_to_tbl(v)
  if type(v) == "string" then
    v = { v }
  end
  return v
end

function M.cmd_map(lhs, rhs, modes, opts)
  modes = str_to_tbl(modes) or { "n" }
  opts = opts or { silent = true, noremap = true }
  for _, mode in ipairs(modes) do
    if type(lhs) == "table" then
      for _, _lhs in ipairs(lhs) do
        keymap.set(mode, _lhs, cmd_string(rhs), opts)
      end
    else
      keymap.set(mode, lhs, cmd_string(rhs), opts)
    end
  end
end

function M.key_map(lhs, rhs, modes, opts)
  modes = str_to_tbl(modes) or { "n" }
  opts = opts or { silent = true, noremap = true }
  for _, mode in ipairs(modes) do
    keymap.set(mode, lhs, rhs, opts)
  end
end

function M.lazy_map(lhs, rhs, modes)
  if type(rhs) == "string" then
    rhs = cmd_string(rhs)
  end
  modes = str_to_tbl(modes) or { "n" }
  return {
    lhs,
    rhs,
    mode = modes,
  }
end

function M.path_exists(path)
  return (vim.uv or vim.loop).fs_stat(fn.expand(path)) ~= nil
end

function M.use_local_plugin(path)
  return not g.lightweight and M.path_exists(path)
end

function M.create_augroup(group, opts)
  opts = opts or { clear = true }
  return api.nvim_create_augroup(group, opts)
end

function M.current_word()
  local current_word = fn.expand("<cword>")
  return current_word
end

function M.tbl_index(tbl, value)
  for i, v in ipairs(tbl) do
    if v == value then
      return i
    end
  end
  return nil
end

function M.tbl_foreach(tbl, f)
  local t = {}
  for key, value in ipairs(tbl) do
    t[key] = f(value)
  end
  return t
end

function M.tbl_filter(tbl, f)
  if not tbl or tbl == {} then
    return {}
  end
  local t = {}
  for key, value in ipairs(tbl) do
    if f(key, value) then
      table.insert(t, value)
    end
  end
  return t
end

function M.list_concat(A, B)
  local t = {}
  for _, value in ipairs(A) do
    table.insert(t, value)
  end
  for _, value in ipairs(B) do
    table.insert(t, value)
  end
  return t
end

function M.map_q_to_quit(event)
  bo[event.buf].buflisted = false
  M.cmd_map("q", "close", "n", { silent = true, noremap = true, buffer = true })
end

function M.restore_cmdheight()
  if g.CMDHEIGHTZERO == 1 then
    o.cmdheight = 0
  else
    o.cmdheight = 1
  end
end

function M.create_cmd(command, f, opts)
  opts = opts or {}
  api.nvim_create_user_command(command, f, opts)
end

function M.screen_scale(config)
  local defaults = {
    width = 0.5,
    height = 0.5,
  }
  config = config or defaults
  config.width = config.width or defaults.width
  config.height = config.height or defaults.height
  local width = fn.round(o.columns * config.width)
  local height = fn.round(o.lines * config.height)
  return {
    width = width,
    height = height,
  }
end

function M.diag_error()
  return #diag.get(0, { severity = diag.severity.ERROR }) ~= 0
end

---@diagnostic disable-next-line: unused-local, unused-function
local function should_tw_values(ft)
  ft = ft or bo.filetype
  if not tbl_contains({
    "typescript",
    "html",
    "templ",
  }, ft) then
    return false
  end
  local clients = vim.lsp.get_clients({ name = "tailwindcss" })
  if not clients[1] then
    return false
  end
  local ft_query = [[
    (attribute
      (attribute_name) @attr_name
        (quoted_attribute_value (attribute_value) @attr_val)
        (#match? @attr_name "class")
    )
    ]]
  local ok, query = pcall(vim.treesitter.query.parse, ft, ft_query)
  if not ok or not query then
    return
  end
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor = vim.treesitter.get_node({
    bufnr = bufnr,
    ignore_injections = false,
  })
  if cursor == nil then
    return false
  end
  local parent = cursor:parent()
  if not parent then
    return false
  end
  local isclass_attr = vim.treesitter.get_node_text(cursor, bufnr) == "class"
  for id, _ in query:iter_captures(parent, bufnr, 0, -1) do
    return isclass_attr and #query.captures[id] > 0
  end
  parent = parent:parent()
  if not parent then
    return false
  end
  isclass_attr = vim.treesitter.get_node_text(parent, bufnr):match("^class=")
  for id, _ in query:iter_captures(parent, bufnr, 0, -1) do
    return isclass_attr and #query.captures[id] > 0
  end
end

local function is_diag_for_cur_pos()
  local diagnostics = vim.diagnostic.get(0)
  local pos = api.nvim_win_get_cursor(0)
  if #diagnostics == 0 then
    return false
  end
  local message = vim.tbl_filter(function(d)
    return d.col == pos[2] and d.lnum == pos[1] - 1
  end, diagnostics)
  return #message > 0
end

local function is_diag_neotest()
  local diagnostics = vim.diagnostic.get(0)
  local found = false
  for _, d in ipairs(diagnostics) do
    if d.source and d.source:match("neotest") then
      found = true
      break
    end
  end
  return found
end

local function is_clojure_filetype(ft)
  return tbl_contains({ "clojure" }, ft)
end

local function command_exists(name)
  return fn.exists(":" .. name) > 0
end

local function trim_empty_lines(lines)
  local start_idx = 1
  local end_idx = #lines
  while start_idx <= end_idx and lines[start_idx]:match("^%s*$") do
    start_idx = start_idx + 1
  end
  while end_idx >= start_idx and lines[end_idx]:match("^%s*$") do
    end_idx = end_idx - 1
  end
  local trimmed = {}
  for i = start_idx, end_idx do
    trimmed[#trimmed + 1] = lines[i]
  end
  return trimmed
end

local function open_hover_preview(lines)
  if not lines or vim.tbl_isempty(lines) then
    return
  end
  vim.lsp.util.open_floating_preview(lines, "markdown", {
    border = "rounded",
    focus_id = "catgoose-hover-handler",
  })
end

local function run_conjure_doc_word()
  local ok, conjure_eval = pcall(require, "conjure.eval")
  if ok and conjure_eval and conjure_eval["doc-word"] then
    conjure_eval["doc-word"]()
    return true
  end
  if command_exists("ConjureDocWord") then
    cmd("silent! ConjureDocWord")
    return true
  end
  return false
end

local function run_conjure_view_source()
  local ok, action = pcall(require, "conjure.client.clojure.nrepl.action")
  if ok and action and action["view-source"] then
    action["view-source"]()
    return true
  end
  if command_exists("ConjureCljViewSource") then
    cmd("silent! ConjureCljViewSource")
    return true
  end
  return false
end

local function has_conjure_source_target(info)
  return info and not info.candidates and info.file and info.line
end

local function with_conjure_info(word, callback)
  local ok_server, server = pcall(require, "conjure.client.clojure.nrepl.server")
  local ok_extract, extract = pcall(require, "conjure.extract")
  if not ok_server or not ok_extract or not word or word == "" then
    return false
  end

  server["with-conn-and-ops-or-warn"]({ "info", "lookup" }, function(conn, ops)
    local request
    if ops.info then
      request = {
        op = "info",
        ns = extract.context() or "user",
        symbol = word,
        session = conn.session,
        ["download-sources-jar"] = 1,
      }
    elseif ops.lookup then
      request = {
        op = "lookup",
        ns = extract.context() or "user",
        sym = word,
        session = conn.session,
      }
    end

    if not request then
      callback(nil)
      return
    end

    server.send(request, function(msg)
      if msg and msg.status and msg.status["no-info"] then
        callback(nil)
        return
      end
      callback(msg and (msg.info or msg) or nil)
    end)
  end, {
    ["silent?"] = true,
    ["else"] = function()
      callback(nil)
    end,
  })

  return true
end

local function run_conjure_hover_fallback()
  local current_word = M.current_word()
  if with_conjure_info(current_word, function(info)
    if has_conjure_source_target(info) then
      if not run_conjure_view_source() then
        run_conjure_doc_word()
      end
    elseif not run_conjure_doc_word() then
      run_conjure_view_source()
    end
  end) then
    return true
  end
  return run_conjure_view_source() or run_conjure_doc_word()
end

local function lsp_hover_lines(result)
  if not result or not result.contents then
    return {}
  end
  local lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
  return trim_empty_lines(lines)
end

local function is_path_like_hover_line(line)
  return line:match("^%*?%[.+%]%(.+%)%*?$") or line:match("^file://") or line:match("^/.+")
end

local function normalize_hover_line(line)
  return line
    :gsub("^```[%w_-]*$", "")
    :gsub("^```$", "")
    :gsub("[`*_]", "")
    :gsub("%s+", " ")
    :gsub("^%s+", "")
    :gsub("%s+$", "")
end

local function is_noise_hover_line(line, current_word)
  return line == ""
    or line:match("^[─-]+$")
    or line == current_word
    or is_path_like_hover_line(line)
end

local function has_substantive_clojure_hover(result)
  local current_word = M.current_word()
  local lines = lsp_hover_lines(result)
  for _, line in ipairs(lines) do
    local normalized = normalize_hover_line(line)
    if not is_noise_hover_line(normalized, current_word) then
      return true, lines
    end
  end
  return false, lines
end

local function clojure_hover_handler()
  local client = vim.lsp.get_clients({
    bufnr = 0,
    name = "clojure_lsp",
  })[1]
  if not client then
    return run_conjure_hover_fallback()
  end

  local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
  client:request("textDocument/hover", params, function(err, result)
    if err then
      run_conjure_hover_fallback()
      return
    end

    local useful, lines = has_substantive_clojure_hover(result)
    if useful then
      open_hover_preview(lines)
      return
    end

    if not run_conjure_hover_fallback() then
      open_hover_preview(lines)
    end
  end, 0)
  return true
end

--  TODO: 2024-07-01 - add fallback for previewing githunk
function M.hover_handler()
  local dap_ok, dap = pcall(require, "dap")
  if dap_ok and dap.session() ~= nil then
    local dapui_ok, dapui = pcall(require, "dap.ui.widgets")
    if dapui_ok and vim.bo.filetype ~= "dap-float" then
      dapui.hover(nil, { border = "rounded" })
    end
  end
  local ft = bo.filetype
  if tbl_contains({ "vim", "help" }, ft) then
    cmd("silent! h " .. fn.expand("<cword>"))
  elseif should_tw_values(ft) then
    cmd("TWValues")
  elseif tbl_contains({ "man" }, ft) then
    cmd("silent! Man " .. fn.expand("<cword>"))
  elseif is_diag_for_cur_pos() then
    if is_diag_neotest() then
      local nt_ok, nt = pcall(require, "neotest")
      if nt_ok then
        nt.output.open({
          enter = true,
          auto_close = true,
        })
      end
    else
      vim.diagnostic.open_float()
    end
  elseif is_clojure_filetype(ft) then
    clojure_hover_handler()
  else
    vim.lsp.buf.hover({
      border = "rounded",
      silent = true,
      winopts = {
        conceallevel = 3,
      },
    })
  end
end

function M.deep_copy(orig)
  local t = type(orig)
  local copy
  if t == "table" then
    copy = {}
    for k, v in pairs(orig) do
      copy[k] = M.deep_copy(v)
    end
  else
    copy = orig
  end
  return copy
end

function M.split_string(str, sep, include_empty)
  sep = sep or " "
  include_empty = include_empty or false
  local t = {}
  local pattern = string.format("([^%s]*)", sep)
  for word in string.gmatch(str, pattern) do
    if include_empty or word ~= "" then
      table.insert(t, word)
    end
  end
  return t
end

function M.get_node_text(tsnode, bufnr)
  bufnr = bufnr or 0
  return vim.treesitter.get_node_text(tsnode, bufnr)
end

function M.set_formatoptions()
  vim.opt_local.formatoptions = vim.opt_local.formatoptions
    - "t"
    + "c"
    - "r"
    - "o"
    - "q"
    - "a"
    + "n"
    - "2"
    + "l"
    + "j"
end

function M.find_path(path, pattern)
  return path:find(pattern) ~= nil
end

return M
