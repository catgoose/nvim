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

function M.same_node(arg)
  return f(function(args)
    return args[1]
  end, arg)
end

function M.linenr()
  return vim.api.nvim_win_get_cursor(0)[1]
end

return M
