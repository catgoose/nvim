local ls = require("luasnip")
local s, t, i, c, r, f = ls.snippet, ls.text_node, ls.insert_node, ls.choice_node, ls.restore_node, ls.function_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta

local snippets = {
	s(
		"form",
		fmt(
			[[
<form [formGroup]="{}" autocomplete="off">
    ]],
			{ i(1) }
		)
	),
	s(
		"slider",
		fmt(
			[[
  <mat-slide-toggle formControlName="{}"
    >{}</mat-slide-toggle
  >
    ]],
			{ i(1), i(2) }
		)
	),
	s(
		"stylebg",
		fmt(
			[[
  style="background-color: {}"
  ]],
			{ i(1) }
		)
	),
	s(
		"matbuttonraised",
		fmt(
			[[
  <button mat-raised-button>{}</button>
  ]],
			{ i(1) }
		)
	),
	s(
		"matbuttonicon",
		fmt(
			[[
  <button mat-icon-button><mat-icon>{}</mat-icon></button>
  ]],
			{ i(1) }
		)
	),
	s(
		"matinput",
		fmt(
			[[
  <mat-form-field appearance="outline">
    <mat-label>{}</mat-label>
    <input matInput type="text"
  /></mat-form-field>
  ]],
			{ i(1) }
		)
	),
}

return snippets
