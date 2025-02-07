local ls = require("luasnip")
---@diagnostic disable-next-line: unused-local
local s, t, i, c, r, f, sn, d =
  ls.snippet,
  ls.text_node,
  ls.insert_node,
  ls.choice_node,
  ls.restore_node,
  ls.function_node,
  ls.snippet_node,
  ls.dynamic_node

local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local u = require("util.luasnip")
local smn = u.same_node

local snippets = {
  -- printing
  s(
    "pr",
    fmt(
      [[
  fmt.Print({}, {})
  {}
  ]],
      { i(1), i(2), i(0) }
    )
  ),
  s(
    "prf",
    fmt(
      [[
fmt.Printf({}, {})
{}
    ]],
      {
        i(1),
        i(2),
        i(0),
      }
    )
  ),
  s(
    "prl",
    fmt(
      [[
fmt.Println({})
{}
    ]],
      {
        i(1),
        i(0),
      }
    )
  ),
  s(
    "fpf",
    fmt(
      [[
fmt.Fprintf({}, {})
{}
    ]],
      {
        i(1),
        i(2),
        i(0),
      }
    )
  ),
  s(
    "fpl",
    fmt(
      [[
fmt.Fprintln({})
{}
    ]],
      {
        i(1),
        i(0),
      }
    )
  ),
  s(
    "spf",
    fmt(
      [[
fmt.Sprintf({}, {})
{}
    ]],
      {
        i(1),
        i(2),
        i(0),
      }
    )
  ),
  s(
    "spl",
    fmt(
      [[
fmt.Sprintln({})
{}
    ]],
      {
        i(1),
        i(0),
      }
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
  -- range
  s(
    "rn",
    fmta(
      [[
  for <>, <> := range <> {
    <>
  }
  ]],
      {
        i(1, "_"),
        i(2, "_"),
        i(3),
        i(4),
      }
    )
  ),
  -- main package
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
  -- main
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
  -- ok
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
  -- function
  s(
    "fn",
    c(1, {
      fmta(
        [[
func <>()<> {
  <>
}
    ]],
        { r(1, "func_name"), i(2), i(3) }
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
  -- interface
  s(
    "int",
    fmta(
      [[
type <> interface {
  <>
}
     ]],
      { i(1), i(0) }
    )
  ),
  -- struct
  s(
    "str",
    fmta(
      [[
  type <> struct {
    <>
  }
       ]],
      { i(1), i(2) }
    )
  ),
  s(
    "db",
    fmt(
      [[
  {} {} `db:"{}"`
  {}
  ]],
      { i(1, "Field"), i(2, "type"), smn(1), i(0) }
    )
  ),
  s(
    "form",
    fmt(
      [[
  {} {} `form:"{}" {}`
  {}
  ]],
      { i(1, "Field"), i(2, "type"), smn(1), i(3), i(0) }
    )
  ),
  -- map
  s(
    "ma",
    fmt(
      [[
map[{}]{}
{}
     ]],
      {
        i(1, "string"),
        i(2, "string"),
        i(0),
      }
    )
  ),
  -- err
  s(
    "er",
    c(1, {
      fmta(
        [[
	if err != nil {
    <>
	}
  <>
   ]],
        { r(1, "if_err_nil"), i(0) }
      ),
      fmta(
        [[
	if err == nil {
    <>
	}
  <>
   ]],
        { r(1, "if_err_nil"), i(0) }
      ),
    })
  ),
  s(
    "ferr",
    fmt(
      [[
     fmt.Errorf("{}: %{}", err)
     ]],
      { i(1), c(2, { t("v"), t("w") }) }
    )
  ),
  -- slice
  s(
    "sl",
    fmta(
      [[
     []<>{<>}
     ]],
      { i(1), i(2) }
    )
  ),
  s(
    "handler",
    fmta(
      [[
func <>(<>) echo.HandlerFunc {
	return func(c echo.Context) error {
		return <>
	}
}
    ]],
      { i(1), i(2), i(0) }
    )
  ),
  s(
    "pkg",
    fmt(
      [[
     package {}

     {}
     ]],
      { i(1), i(0) }
    )
  ),
  s(
    "iferr",
    fmta(
      [[
     if err := <>; err != nil {
       <>
     }
     ]],
      { i(1), i(0) }
    )
  ),
}

return snippets
