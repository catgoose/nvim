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
local fmta = require("luasnip.extras.fmt").fmta
local u = require("util.luasnip")
local smn = u.same_node

local snippets = {
  s(
    "form",
    fmt(
      [[
<form [formGroup]="{}" autocomplete="off">
{}
</form>
    ]],
      { i(1), i(2) }
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
          t("mat-raised-button"),
          t("mat-flat-button"),
          t("mat-stroked-button"),
          t("mat-icon-button"),
          t("mat-fab"),
          t("mat-mini-fab"),
          t("mat-button"),
          t(""),
        }),
        c(2, {
          t(' color="primary"'),
          t(' color="accent"'),
          t(' color="warn"'),
          t(""),
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
          <mat-label>{}</mat-label>
          <mat-select name="{}" formControlName="{}">
            <mat-option
              *ngFor="let {} of {}"
              [value]="{}"
            >
            {{{}}}
            </mat-option>
          </mat-select>
        </mat-form-field>
  ]],
      { i(1), i(2), smn(2), i(3), i(4), smn(3), smn(3) }
    )
  ),
  s(
    "minput",
    fmt(
      [[
          <mat-form-field appearance="outline" class="form-control">
            <mat-label>{}</mat-label>
            <input matInput name="{}" formControlName="{}" />
          </mat-form-field>
  ]],
      { i(1), i(2), smn(2) }
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
      {
        c(1, {
          t(""),
          t([[fxLayout="row"]]),
          t([[fxLayout="column"]]),
        }),
        i(0),
      }
    )
  ),

  s(
    "mtable",
    fmt(
      [[
  <table mat-table [dataSource]="{}" class="mat-elevation-z3">
  <ng-container
  *ngFor="let column of tableColumns$ | async" 
  [matColumnDef]="column.columnDef"
  >
  <th mat-header-cell *matHeaderCellDef>
  {{{{ column.header }}}}
  </th>
  <td mat-cell *matCellDef="let {}">
    <ng-container
      [ngTemplateOutlet]="tdDisplay"
      [ngTemplateOutletContext]="{{
        value: column.cell({}),
        {},
        columnDef: column.columnDef
      }}"
    >
    </ng-container>
  </td>
  </ng-container>
  <tr mat-header-row *matHeaderRowDef="displayedColumns$ | async"></tr>
  <tr mat-row *matRowDef="let row; columns: displayedColumns$ | async"></tr>
  </table>

<ng-template
  #tdDisplay
  let-value="value"
  let-projection="{}"
  let-columnDef="columnDef"
>
<ng-container [ngSwitch]="columnDef">
  <ng-container *ngSwitchDefault>
      <ng-template
        [ngTemplateOutlet]="tdDefault"
        [ngTemplateOutletContext]="{{ value }}"
      >
      </ng-template>
  </ng-container>
</ng-container>
</ng-template>

<ng-template #tdDefault let-value="value">
{{{{ value }}}}
</ng-template>
  ]],
      {
        i(1),
        i(2),
        smn(2),
        smn(2),
        smn(2),
      }
    )
  ),
  s(
    "ngswitch",
    fmt(
      [[
  <ng-container [ngSwitch]="{}">
    <ng-container *ngSwitchCase="'{}'">
      {}
    </ng-container>
    <ng-container *ngSwitchDefault>
      {}
    </ng-container>
  </ng-container>
  ]],
      { i(1), i(2), i(3), i(4) }
    )
  ),
  s(
    "ngcase",
    fmt(
      [[
    <ng-container *ngSwitchCase="'{}'">
      {}
    </ng-container>
  ]],
      { i(1), i(2) }
    )
  ),
  s(
    "ngoutlet",
    fmt(
      [[
  <ng-container
    [ngTemplateOutlet]="{}"
    [ngTemplateOutletContext]="{{ {} }}"
    >
    {}
  </ng-container>
  ]],
      { i(1), i(2), i(3) }
    )
  ),
  s(
    "ngtemplate",
    fmt(
      [[
  <ng-template #{}>
    {}
  </ng-template>
  ]],
      { (i(1)), i(2) }
    )
  ),
  s(
    "async",
    fmta(
      [[
  {{ <>$ <> }}
  ]],
      {
        i(1),
        c(2, {
          t("| async"),
          t("| async | json"),
        }),
      }
    )
  ),
  s(
    "ngcon",
    fmt(
      [[
    <ng-container *ngIf="{}">
    {}
    </ng-container>
     ]],
      { i(1), i(0) }
    )
  ),
}

return snippets
