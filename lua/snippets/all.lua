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
local fmt = require("luasnip.extras.fmt").fmt
local u = require("util.luasnip")
local today = u.today
local comment_open = u.comment_open
local comment_close = u.comment_close

local snippets = {}

local todos = {
  "fix",
  "todo",
  "hack",
  "warn",
  "perf",
  "note",
  "test",
  "bug",
  "refc",
  "question",
}
for _, todo in ipairs(todos) do
  table.insert(
    snippets,
    s(
      todo,
      fmt([[
		    {} ]] .. string.upper(todo) .. [[: {} - {}{}
		    ]], {
        f(comment_open),
        f(today),
        i(1),
        f(comment_close),
      })
    )
  )
end

return snippets
