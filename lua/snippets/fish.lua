local ls = require("luasnip")
local s, t, i, c, r, f, sn =
	ls.snippet, ls.text_node, ls.insert_node, ls.choice_node, ls.restore_node, ls.function_node, ls.snippet_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local u = require("util.luasnip")
local smn = u.same_node

local snippets = {
	s(
		"argp",
		fmt(
			[[
    argparse --min-args {} -- $argv
    or return
  ]],
			i(1, "min_args")
		)
	),
}

return snippets
