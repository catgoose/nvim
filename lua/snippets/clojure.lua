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

local snippets = {
  s(
    "cmt",
    fmt(
      [[
(comment
  {}
)
    ]],
      { i(0) }
    )
  ),
  s(
    "def",
    fmt("({} {} {})", {
      t("def"),
      i(1, "foo"),
      i(0, "(expr)"),
    })
  ),
}

return snippets
