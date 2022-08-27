local ls = require("luasnip")
local parse = ls.parser.parse_snippet
local s, t, i, c, r, f = ls.snippet, ls.text_node, ls.insert_node, ls.choice_node, ls.restore_node, ls.function_node
local utils = require("config.luasnip_utils")
local today = utils.today
local comment = utils.comment

local snippets = {
	s("todo", {
		f(comment),
		t(" TODO: "),
		f(today),
		t(" - "),
		i(1),
	}),
	s("fix", {
		f(comment),
		t(" FIX: "),
		f(today),
		t(" - "),
		i(1),
	}),
	s("bug", {
		f(comment),
		t(" BUG: "),
		f(today),
		t(" - "),
		i(1),
	}),
	s("test", {
		f(comment),
		t(" TEST: "),
		f(today),
		t(" - "),
		i(1),
	}),
	s("hack", {
		f(comment),
		t(" HACK: "),
		f(today),
		t(" - "),
		i(1),
	}),
	s("optim", {
		f(comment),
		t(" OPTIM: "),
		f(today),
		t(" - "),
		i(1),
	}),
}

return snippets
