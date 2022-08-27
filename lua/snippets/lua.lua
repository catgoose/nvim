local ls = require("luasnip")
local s, t, i, c, r, f = ls.snippet, ls.text_node, ls.insert_node, ls.choice_node, ls.restore_node, ls.function_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta

local snippets = {
	s(
		"snip",
		fmt(
			[[
s("{}", 
  {}
),]],
			{ i(1), i(2) }
		)
	),
	s(
		"luasnip",
		fmt(
			[[local ls = require("luasnip")
local s, t, i, c, r, f = ls.snippet, ls.text_node, ls.insert_node, ls.choice_node, ls.restore_node, ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippets = {{
  s("{}", {{
    {} 
  }}
)}}

return snippets
]],
			{ i(1), i(2) }
		)
	),
	s(
		"setup",
		fmt(
			[[require("config.utils").plugin_setup("{}", {{
  {}
}})
]],
			{ i(1), i(2) }
		)
	),
	s("config", fmt([[config = config("{}"),]], i(1))),
	s(
		"req",
		fmt([[local {} = require "{}"]], {
			f(function(import)
				local parts = vim.split(import[1][1], ".", true)
				return parts[#parts] or ""
			end, { 1 }),
			i(1),
		})
	),
}

return snippets
