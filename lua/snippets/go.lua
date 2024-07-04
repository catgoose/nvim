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
local fmta = require("luasnip.extras.fmt").fmta

local snippets = {
  s(
    "pr",
    fmt(
      [[
		fmt.Println({})
    ]],
      i(1)
    )
  ),
  s(
    "pf",
    fmt(
      [[
		fmt.Printf("{}", {})
    ]],
      { i(1), i(0) }
    )
  ),
  s(
    "for",
    fmt(
      [[
	for i := {}; i < {}; i++ {{
    {}
  }}
     ]],
      { i(1), i(2), i(0) }
    )
  ),
  s(
    "packmain",
    fmt(
      [[
     package main

     func main() {{
       {}
     }}
     ]],
      {
        i(1),
      }
    )
  ),
}

return snippets
