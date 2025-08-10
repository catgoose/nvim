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

local snippets = {
  s(
    "lua",
    fmt(
      [[
```lua
{}
```
    ]],
      { i(1) }
    )
  ),
  s({ trig = "table(%d+)x(%d+)", regTrig = true }, {
    ---@diagnostic disable-next-line: unused-local
    d(1, function(args, snip)
      local nodes = {}
      local i_counter = 0
      local hlines = ""
      for _ = 1, snip.captures[2] do
        i_counter = i_counter + 1
        table.insert(nodes, t("| "))
        table.insert(nodes, i(i_counter, "Column" .. i_counter))
        table.insert(nodes, t(" "))
        hlines = hlines .. "|---"
      end
      table.insert(nodes, t({ "|", "" }))
      hlines = hlines .. "|"
      table.insert(nodes, t({ hlines, "" }))
      for _ = 1, snip.captures[1] do
        for _ = 1, snip.captures[2] do
          i_counter = i_counter + 1
          table.insert(nodes, t("| "))
          table.insert(nodes, i(i_counter))
          table.insert(nodes, t(" "))
        end
        table.insert(nodes, t({ "|", "" }))
      end
      return sn(nil, nodes)
    end),
  }),
}

return snippets
