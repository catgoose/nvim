local fn, api, cmd, diag, o, g, tbl_contains, bo, keymap =
  vim.fn, vim.api, vim.cmd, vim.diagnostic, vim.o, vim.g, vim.tbl_contains, vim.bo, vim.keymap

local M = {}

local function get_config_modules(exclude_map)
  exclude_map = exclude_map or {
    "lazy",
    "init",
    "statuscol",
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
    keymap.set(mode, lhs, cmd_string(rhs), opts)
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
local function treesitter_is_css_class_under_cursor()
  local ft = bo.filetype
  if not tbl_contains({ "typescript", "typescriptreact", "vue", "html", "svelt", "astro" }, ft) then
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

  if query == nil then
    return false
  end

  for id, _ in query:iter_captures(parent, bufnr, 0, -1) do
    local name = query.captures[id]
    return #name > 0
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
    if d.source:match("neotest") then
      found = true
      break
    end
  end
  return found
end

--  TODO: 2024-07-01 - add fallback for previewing githunk
function M.hover_handler()
  local ufo_ok, ufo = pcall(require, "ufo")
  if ufo_ok then
    local winid = ufo.peekFoldedLinesUnderCursor()
    if winid then
      return
    end
  end
  local ft = bo.filetype
  if tbl_contains({ "vim", "help" }, ft) then
    cmd("silent! h " .. fn.expand("<cword>"))
  elseif treesitter_is_css_class_under_cursor() then
    local clients = vim.lsp.get_clients({ name = "tailwindcss" })
    if clients[1] then
      cmd("TWValues")
    end
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
  else
    vim.lsp.buf.hover()
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
