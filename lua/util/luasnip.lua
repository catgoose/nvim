local ls = require("luasnip")
---@diagnostic disable-next-line: unused-local
local s, t, i, c, r, f, sn =
  ls.snippet,
  ls.text_node,
  ls.insert_node,
  ls.choice_node,
  ls.restore_node,
  ls.function_node,
  ls.snippet_node
---@diagnostic disable-next-line: unused-local
local fmt = require("luasnip.extras.fmt").fmt
local M = {}

local comment_open = {
  lua = "-- ",
  typescript = "// ",
  javascript = "// ",
  scss = "// ",
  cpp = "// ",
  sh = "# ",
  fish = "# ",
  html = "<!-- ",
  query = "; ",
}

local comment_close = {
  html = " -->",
}

function M.comment_open()
  local ok, ts_context = pcall(require, "ts_context_commentstring")
  if ok then
    local comment_string = ts_context.calculate_commentstring()
    if not comment_string then
      return
    end
    return vim.split(comment_string, "%s", { plain = true })[1]
  else
    local ft = vim.bo.filetype
    local ext = vim.fn.expand("%:e")
    if comment_open[ft] then
      return comment_open[ft]
    end
    if ft == "query" and ext == "scm" then
      return "; "
    end
  end
end

function M.comment_close()
  local ok, ts_context = pcall(require, "ts_context_commentstring")
  if ok then
    local comment_string = ts_context.calculate_commentstring()
    if not comment_string then
      return
    end
    return vim.split(comment_string, "%s", { plain = true })[2]
  else
    local ft = vim.bo.filetype
    if comment_close[ft] then
      return comment_close[ft]
    end
  end
end

function M.today()
  return os.date("%Y-%m-%d")
end

function M.capitalize(node_index)
  return f(function(args)
    local str = args[1][1]
    return str:sub(1, 1):upper() .. str:sub(2)
  end, node_index)
end

function M.lower(node_index)
  return f(function(args)
    local str = args[1][1]
    return str:sub(1, 1):lower() .. str:sub(2)
  end, node_index)
end

function M.lua_require(arg)
  local parts = vim.split(arg[1][1], ".", { plain = true })
  return parts[#parts] or ""
end

function M.same_node(arg)
  return f(function(args)
    return args[1]
  end, arg)
end

function M.nest_method_args(_, snip, _)
  local ts_query = "(required_parameter pattern: (identifier) @param )"
  local method_args = ""
  local pos_begin = snip.nodes[3].mark:pos_begin()
  local pos_end = snip.nodes[3].mark:pos_end()
  local parser = vim.treesitter.get_parser(0, "typescript")
  local tstree = parser:parse()[1]
  local node =
    tstree:root():named_descendant_for_range(pos_begin[1], pos_begin[2], pos_end[1], pos_end[2])

  if node == nil then
    return ""
  end
  for child in node:iter_children() do
    local query = vim.treesitter.query.parse("typescript", ts_query)
    ---@diagnostic disable-next-line: missing-parameter
    for _, arg in query:iter_captures(child, 0) do
      method_args = method_args .. vim.treesitter.get_node_text(arg, 0) .. ", "
    end
  end

  if method_args ~= "" then
    method_args = method_args:sub(1, -3)
  end
  return method_args
end

function M.nest_classname()
  local ts_query = "(class_declaration name: (type_identifier) @class_name)"
  local parser = vim.treesitter.get_parser(0, "typescript")
  local tstree = parser:parse()[1]
  local node = tstree:root()
  local query = vim.treesitter.query.parse("typescript", ts_query)
  ---@diagnostic disable-next-line: missing-parameter
  for _, class_name in query:iter_captures(node, 0) do
    return vim.treesitter.get_node_text(class_name, 0)
  end
end

return M
