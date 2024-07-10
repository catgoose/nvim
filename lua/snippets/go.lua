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
local u = require("util.luasnip")
local smn = u.same_node

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
  --  TODO: 2024-07-06 - use same node for i
  s(
    "for",
    fmt(
      [[
	for {} := {}; {} < {}; {}++ {{
    {}
  }}
     ]],
      { i(1), i(2), smn(1), i(3), smn(1), i(0) }
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
  s(
    "main",
    fmt(
      [[
     func main() {{
       {}
     }}
     ]],
      i(0)
    )
  ),
  s(
    "v",
    fmt(
      [[
     {} := {}
     {}
     ]],
      { i(1), i(2), i(0) }
    )
  ),
  s(
    "ok",
    fmt(
      [[
     {}, ok := {}
     {}
     ]],
      { i(1), i(2), i(0) }
    )
  ),
  s(
    "func",
    c(1, {
      fmta(
        [[
func <>() {
  <>
}
    ]],
        { r(1, "func_name"), i(2) }
      ),
      fmta(
        [[
func (<>) <>(<>) <> {
  <>
}
    ]],
        { i(1), r(2, "func_name"), i(3), i(4), i(5) }
      ),
    })
  ),
  s(
    "inter",
    fmta(
      [[
type <> interface {
  <>
}
     ]],
      { i(1), i(0) }
    )
  ),
  s(
    "struct",
    fmta(
      [[
type <> struct {
  <>
}
     ]],
      { i(1), i(2) }
    )
  ),
}

return snippets
