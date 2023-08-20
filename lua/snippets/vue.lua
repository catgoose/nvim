local ls = require("luasnip")
local s, t, i, c, r, f, sn =
	ls.snippet, ls.text_node, ls.insert_node, ls.choice_node, ls.restore_node, ls.function_node, ls.snippet_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local u = require("util.luasnip")
local smn = u.same_node
local low = u.lower

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
		"setup",
		fmt(
			[[
      <script setup lang='ts'>
      {}
      </script>
      ]],
			{ i(1) }
		)
	),
	s(
		"template",
		fmt(
			[[
  <template>
  {}
  </template>
  ]],
			{ i(1) }
		)
	),
}

return snippets
