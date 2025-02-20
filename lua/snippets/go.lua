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
     package {name}

     {finally}
     ]],
      {
        name = i(1),
        finally = i(0),
      }
    ),
    not_in_func_first_line
  ),
  s(
    "pmain",
    fmta(
      [[
     package main

     func main() {
       <body>
     }
     ]],
      {
        body = i(0),
      }
    ),
    not_in_func_first_line
  ),
  s(
    "main",
    fmta(
      [[
     func main() {
       <body>
     }
     ]],
      {
        body = i(0),
      }
    ),
    not_in_func
  ),
  -- Function
  s({ trig = "rt", hidden = false }, {
    t("return "),
    i(1),
    t({ "" }),
    d(2, ft.make_default_return_nodes, { 1 }),
  }, in_func),
  s(
    "ifc",
    fmta(
      [[
        <val>, <err1> := <func>(<args>)
        if <err2> != nil {
          return <err3>
        }
        <finally>
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
  s(
    "fn",
    fmta(
      [[
        // <name1> <desc>
        func <rec><name2>(<args>) <ret> {
          <finally>
        }
      ]],
      {
        name1 = rep(2),
        desc = i(5, "description"),
        rec = c(1, {
          t(""),
          sn(
            nil,
            fmt("({}) ", {
              f(ft.get_receiver),
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
  s(
    "fnr",
    fmta(
      [[
  // <name1> <desc>
  func <rec><name2>(<args>) <ret> {
    <finally>
  }
     ]],
      {
        name1 = rep(2),
        desc = i(5, "description"),
        rec = sn(
          1,
          fmt("({}) ", {
            f(ft.get_receiver),
          })
        ),
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
    )
  ),
  -- Errors
  s(
    "er",
    fmta(
      [[
if <> <> nil {
  return <>
}
<>
      ]],
      {
        i(1, "err"),
        c(2, {
          t("!="),
          t("=="),
        }),
        d(3, ft.make_return_nodes, { 1 }, { user_args = { { "a1", "a2" } } }),
        i(0),
      }
    ),
    in_func
  ),
  s(
    "iferr",
    fmta(
      [[
if err := <>; err != nil {
  return <>
}
<>
     ]],
      {
        i(1),
        d(2, ft.make_return_nodes, { 1 }, { user_args = { { "a1", "a2" } } }),
        i(0),
      }
    )
  ),
  s(
    "fer",
    fmt(
      [[
     fmt.Errorf("{}: {} %{}", {}, err)
     {}
     ]],
      { i(1), i(2), c(3, { t("w"), t("v") }), i(4), i(0) }
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
          return sn(1, i(1, snip.captures[1]))
        end),
        rep(1),
        c(2, { i(1, "num"), sn(1, { t("len("), i(1, "arr"), t(")") }) }),
        rep(1),
        i(3, "// TODO:"),
        i(4),
      }
    ),
    in_func
  ),
  s(
    "tysw",
    fmta(
      [[
switch <> := <>.(type) {
    case <>:
        <>
    default:
        <>
}
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
    fmt(
      [[
{} {}= make({})
{}
    ]],
      {
        i(1, "name"),
        i(2),
        c(3, {
          fmt("[]{}, {}", { r(1, "type"), ls.i(2, "len") }),
          fmt("[]{}, 0, {}", { r(1, "type"), ls.i(2, "len") }),
          fmt("map[{}]{}, {}", { r(1, "type"), ls.i(2, "values"), ls.i(3, "len") }),
        }, {
          stored = {
            type = i(1, "type"),
          },
        }),
        i(0),
      }
    ),
    in_func
  ),
  -- ok
  s(
    "ok",
    fmt(
      [[
 {val}, ok := {var}.({type})
 if {ok} {{
   {todo}
 }}
 {finally}
     ]],
      {
        val = i(1, { "val" }),
        var = i(2, { "var" }),
        type = i(3, { "type" }),
        ok = c(4, {
          t("ok"),
          t("!ok"),
        }),
        todo = i(5, { "// TODO:" }),
        finally = i(0),
      }
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
    ),
    not_in_func
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
    ),
    not_in_func
  ),
  -- TODO: 2025-02-19 - Create treesitter query to check if inside struct
  -- definition
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
  s(
    "ectx",
    fmt(
      [[
ctx := c.Request().Context()
{}
     ]],
      { i(0) }
    )
  ),
}

return snippets
