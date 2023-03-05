local ls = require("luasnip")
local s, t, i, c, r, f, sn =
	ls.snippet, ls.text_node, ls.insert_node, ls.choice_node, ls.restore_node, ls.function_node, ls.snippet_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local u = require("util.luasnip")

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
local s, t, i, c, r, f, sn = ls.snippet, ls.text_node, ls.insert_node, ls.choice_node, ls.restore_node, ls.function_node, ls.snippet_node
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
		"req",
		fmt([[local {} = require("{}")]], {
			f(u.lua_require, { 1 }),
			i(1),
		})
	),
	s("kan", t([[local colors = require("kanagawa.colors").setup()]])),
	s("kanagawa", t([[local colors = require("kanagawa.colors").setup()]])),
	s("colors", t([[local colors = require("kanagawa.colors").setup()]])),
	s("p", fmt([[print({})]], i(1))),
	s("P", fmt([[P({})]], i(1))),
	s(
		"M",
		fmta(
			[[
  local M = {}

  <>

  return M
  ]],
			i(1)
		)
	),
	s(
		"M.config",
		fmt(
			[[
M.init = function(opts)
	opts = opts or {{}}
	M.opts = vim.tbl_deep_extend("keep", opts, M.opts)
	if M.opts.dev then
		dev()
	end
	return M.opts
end
  ]],
			{}
		)
	),
	s("insp", fmt([[print(vim.inspect({}))]], i(1))),
	s("pp", fmt([[vim.pretty_print({})]], i(1))),
	s(
		"lazy",
		c(1, {
			fmta(
				[[
    return {
      "<>",
    }
    ]],
				r(1, "lazy_plugin")
			),
			fmta(
				[[
    local opts = {
      <>
    }

    return {
      "<>",
      opts = opts
    }
    ]],
				{ i(1), r(2, "lazy_plugin") }
			),
		})
	),
}

return snippets
