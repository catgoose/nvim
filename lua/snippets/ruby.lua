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
    "p",
    c(1, {
      fmt(
        [[
      puts "{}"
      ]],
        i(1)
      ),
      fmt(
        [[
      print "{}"
      ]],
        i(1)
      ),
    })
  ),
  s({ trig = "pri?n?t?", regTrig = true }, fmt([[print "{}"]], i(1))),
  s({ trig = "put?s?" }, fmt([[puts "{}"]], i(1))),
  s(
    "def",
    fmt(
      [[
def {}({})
  {}
end]],
      { i(1), i(2), i(0) }
    )
  ),
  s(
    { trig = "eac?h?", regTrig = true },
    fmt(
      [[
  {}.each do |{}|
    {}
  end
  ]],
      { i(1), i(2), i(0) }
    )
  ),
  s(
    { trig = "eac?h?ind?e?x?", regTrig = true },
    fmt(
      [[
  {}.each_with_index do |{}|
    {}
  end
  ]],
      { i(1), i(2), i(0) }
    )
  ),
  s(
    "l",
    fmta(
      [[
puts "<>: #{<>}"
<>
]],
      { smn(1), i(1), i(0) }
    )
  ),
}

return snippets
