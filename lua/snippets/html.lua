local ls = require("luasnip")
local s, t, i, c, r, f, sn =
	ls.snippet, ls.text_node, ls.insert_node, ls.choice_node, ls.restore_node, ls.function_node, ls.snippet_node
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
		"mslider",
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
		"ngif",
		fmt(
			[[
  <ng-container *ngIf="{}">
  {}
  </ng-container>
  ]],
			{
				c(1, {
					i(1),
					{
						i(1),
						t(" | async"),
					},
				}),
				i(2),
			}
		)
	),
	s(
		"ngfor",
		fmt(
			[[
  <ng-container *ngFor="let {} of {}">
  {}
  </ng-container>
  ]],
			{
				i(1),
				c(2, {
					i(1),
					{
						i(1),
						t(" | async"),
					},
				}),
				i(3),
			}
		)
	),
	s(
		"mbutton",
		fmt(
			[[
      <button {}{}>{}</button>
  ]],
			{
				c(1, {
					t(""),
					t("mat-button"),
					t("mat-raised-button"),
					t("mat-flat-button"),
					t("mat-stroked-button"),
					t("mat-icon-button"),
					t("mat-fab"),
					t("mat-mini-fab"),
				}),
				c(2, {
					t(""),
					t(' color="primary"'),
					t(' color="accent"'),
					t(' color="warn"'),
				}),
				i(3),
			}
		)
	),

	s(
		"moption",
		fmt(
			[[
        <mat-form-field appearance="outline" class="form-control">
          <mat-label></mat-label>
          <mat-select name="" formControlName="">
            <mat-option
              *ngFor=""
              [value]=""
            >
            </mat-option>
          </mat-select>
        </mat-form-field>
  ]],
			{}
		)
	),
	s(
		"minput",
		fmt(
			[[
          <mat-form-field appearance="outline" class="form-control">
            <mat-label></mat-label>
            <input matInput name="" formControlName="" />
          </mat-form-field>
  ]],
			{}
		)
	),
	s(
		"div",
		fmt(
			[[
  <div {}>
  {}
  </div>
  ]],
			{ c(1, {
				t(""),
				t([[fxLayout="row"]]),
				t([[fxLayout="column"]]),
			}), i(0) }
		)
	),
}

return snippets
