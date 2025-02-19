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
local u = require("snippets.util.snip")
local smn = u.same_node

local snippets = {
  s(
    "scr",
    fmt(
      [[
<script> 
  {}
</script>
  ]],
      i(0)
    )
  ),
  s(
    "hxlog",
    fmt(
      [[
<script> 
  htmx.logAll();
</script>
{}
  ]],
      i(0)
    )
  ),
  s(
    "eventlisten",
    fmta(
      [[
   document.body.addEventListener('<>', function (<>) {
     <>
     }) 
     ]],
      { i(1), i(2), i(0) }
    )
  ),
  s(
    "cl",
    fmt(
      [[
     console.log({})
     ]],
      i(0)
    )
  ),
  s(
    "range",
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
    "hs",
    fmt(
      [[_="
{}
"]],
      { i(1) }
    )
  ),
  -- TODO: 2025-02-05 - convert to choice
  s(
    "htas",
    fmt(
      [[
        on htmx:afterSwap if not event.detail.failed
          {}
]],
      { i(1) }
    )
  ),
  s(
    "htar",
    fmt(
      [[
        on htmx:afterRequest if not event.detail.failed
          {}
]],
      { i(1) }
    )
  ),
  s(
    "fn",
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
    "templ",
    fmta(
      [[
templ <>(<>) {
  <>
}
     ]],
      { i(1), i(2), i(0) }
    )
  ),
  s(
    "for",
    fmta(
      [[
  for _, <> := range <> {
    <>
  }
    ]],
      { i(1), i(2), i(0) }
    )
  ),
  s(
    "spf",
    fmta(
      [[
      {fmt.Sprintf("<>", <>)}
    ]],
      {
        i(1),
        i(0),
      }
    )
  ),
}

return snippets
