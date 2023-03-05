local ls = require("luasnip")
local s, t, i, c, r, f = ls.snippet, ls.text_node, ls.insert_node, ls.choice_node, ls.restore_node, ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippets = {
	s(
		"dsldconfig",
		fmt(
			[[[remote "origin"]
  url = git@github.com-dsld:DSLDDev/{}.git
  fetch = +refs/heads/*:refs/remotes/origin/*
]],
			i(1)
		)
	),
}

return snippets
