-- much of this is taken from https://github.com/ray-x/go.nvim/blob/master/lua/snips/go.lua

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
local rep = require("luasnip.extras").rep
local ft = require("snippets.util.filetype.go")
local u = require("snippets.util.snip")
local smn = u.same_node

local in_func = {
  show_condition = ft.in_func,
  condition = ft.in_func,
}

local not_in_func = {
  show_condition = ft.not_in_func,
  condition = ft.not_in_func,
}

local not_in_func_first_line = {
  condition = function()
    return ft.not_in_func() and u.linenr() == 1
  end,
  show_condition = function()
    return ft.not_in_func() and u.linenr() == 1
  end,
}

local snippets = {
  -- Main
  s(
    "pkg",
    fmt(
      [[
     package {}

     {}
     ]],
      { i(1), i(0) }
    ),
    not_in_func_first_line
  ),
  s(
    "pmain",
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
    ),
    not_in_func_first_line
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
    ),
    not_in_func
  ),
  -- Function
  s({ trig = "rt", hidden = true }, {
    t("return "),
    ls.i(1),
    ls.t({ "" }),
    d(2, ft.make_default_return_nodes, { 1 }),
  }, in_func),
  s(
    "ifc",
    fmt(
      [[
        {val}, {err1} := {func}({args})
        if {err2} != nil {{
          return {err3}
        }}
        {finally}
      ]],
      {
        val = i(1, { "val" }),
        err1 = i(2, { "err" }),
        func = i(3, { "func" }),
        args = i(4),
        err2 = rep(2),
        err3 = d(5, ft.make_return_nodes, { 2 }),
        finally = i(0),
      }
    ),
    in_func
  ),
  ls.s(
    "fn",
    fmt(
      [[
        // {name1} {desc}
        func {rec}{name2}({args}) {ret} {{
          {finally}
        }}
      ]],
      {
        name1 = rep(2),
        desc = i(5, "description"),
        rec = c(1, {
          t(""),
          sn(
            nil,
            fmt("({} {}) ", {
              i(1, "r"),
              i(2, "receiver"),
            })
          ),
        }),
        name2 = i(2, "Name"),
        args = i(3),
        ret = c(4, {
          i(1, "error"),
          sn(
            nil,
            fmt("({}, {}) ", {
              i(1, "ret"),
              i(2, "error"),
            })
          ),
        }),
        finally = i(0),
      }
    ),
    not_in_func
  ),
  -- Errors
  s(
    "ife",
    fmt("if {} != nil {{\n\treturn {}\n}}\n{}", {
      i(1, "err"),
      d(2, ft.make_return_nodes, { 1 }, { user_args = { { "a1", "a2" } } }),
      i(0),
    }),
    in_func
  ),
  s(
    "fer",
    fmt(
      [[
     fmt.Errorf("{}: %{}", err)
     ]],
      { i(1), c(2, { t("w"), t("v") }) }
    )
  ),
  -- For
  s(
    "fsel",
    fmt(
      [[
for {{
	  select {{
        case {} <- {}:
			      {}
        default:
            {}
	  }}
}}
]],
      {
        c(1, { ls.i(1, "ch"), ls.i(2, "ch := ") }),
        i(2, "ch"),
        i(3, "break"),
        i(0, ""),
      }
    ),
    in_func
  ),
  s(
    { trig = "for([%w_]+)", regTrig = true, hidden = true },
    fmt(
      [[
  for  {} := 0; {} < {}; {}++ {{
    {}
  }}
  {}
      ]],
      {
        d(1, function(_, snip)
          return sn(1, ls.i(1, snip.captures[1]))
        end),
        rep(1),
        c(2, { ls.i(1, "num"), ls.sn(1, { ls.t("len("), ls.i(1, "arr"), ls.t(")") }) }),
        rep(1),
        i(3, "// TODO:"),
        i(4),
      }
    ),
    in_func
  ),
  s(
    "tysw",
    fmt(
      [[
switch {} := {}.(type) {{
    case {}:
        {}
    default:
        {}
}}
]],
      {
        i(1, "v"),
        i(2, "i"),
        i(3, "int"),
        i(4, 'fmt.Println("int")'),
        i(0, ""),
      }
    )
  ),
  -- Slices and maps
  s(
    "mk",
    fmt("{} {}= make({})\n{}", {
      i(1, "name"),
      i(2),
      c(3, {
        fmt("[]{}, {}", { r(1, "type"), ls.i(2, "len") }),
        fmt("[]{}, 0, {}", { r(1, "type"), ls.i(2, "len") }),
        fmt("map[{}]{}, {}", { r(1, "type"), ls.i(2, "values"), ls.i(3, "len") }),
      }, {
        stored = { -- FIXME: the default value is not set.
          type = i(1, "type"),
        },
      }),
      i(0),
    }),
    in_func
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
}

return snippets
