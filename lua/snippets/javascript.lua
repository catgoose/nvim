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
    "cl",
    c(1, {
      fmt(
        [[
      console.log({});
      ]],
        r(1, "console_log")
      ),
      fmt(
        [[
console.group('{}');
console.log({});
console.groupEnd();
  ]],
        { i(1), r(2, "console_log") }
      ),
    })
  ),
  s(
    "t",
    fmt(
      [[
      test('{}', () => {{
        {}
      }});
      ]],
      { i(1), i(2) }
    )
  ),
  s(
    "exp",
    fmt(
      [[
      expect({}).{}
      ]],
      { i(1), i(2) }
    )
  ),
}

return snippets
