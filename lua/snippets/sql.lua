local ls = require("luasnip")
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
local smn = u.same_node

local snippets = {
  s(
    "dbs",
    fmt(
      [[
SELECT name 
FROM sys.databases 
WHERE database_id > 4;
{}
   ]],
      { i(1) }
    )
  ),
  s(
    "tbls",
    fmt(
      [[
SELECT TABLE_NAME
FROM information_schema.tables
WHERE table_type = 'BASE TABLE' AND table_schema = 'dbo';
{}
     ]],
      { i(1) }
    )
  ),
}

return snippets
