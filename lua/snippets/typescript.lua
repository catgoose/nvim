local ls = require("luasnip")
local s, t, i, c, r, f = ls.snippet, ls.text_node, ls.insert_node, ls.choice_node, ls.restore_node, ls.function_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local utils = require("config.luasnip_utils")

ls.add_snippets("typescript", {
  s(
    "cl",
    c(1, {
      fmt([[console.log({});]], i(1)),
      fmt(
        [[
console.group('{}');
console.log({});
console.groupEnd();
  ]]     ,
        { i(1), i(2) }
      ),
    })
  ),
  s(
    "cyg",
    fmt([[cy.get({}).{}]], { c(1, {
      fmt([['[data-test={}]']], i(1)),
      t(""),
    }), i(2) })
  ),
  s("exp", fmt("expect({}).{}", { i(1), i(2) })),
  s(
    "de",
    fmta(
      [[describe('<>', () =>> {
   <> 
  });]],
      { i(1), i(2) }
    )
  ),
  s(
    "nspy",
    fmt([[const {} = jest.spyOn({}, '{}');]], {
      i(1, "spy"),
      i(2, "service"),
      i(3, "method"),
    })
  ),
  s(
    "expspy",
    fmt(
      [[
expect({}).toHaveBeenCalled();
  ]]   ,
      i(1, "spy")
    )
  ),
  s(
    "it",
    fmta(
      [[it('<>', <>() =>> {
    <>
  })]] ,
      { i(1), c(2, {
        t(" "),
        t("async"),
      }), i(3) }
    )
  ),
  s(
    "be",
    fmta(
      [[beforeEach(<> () =>> {
  <>
})
  ]]   ,
      { c(1, {
        t(" "),
        t("async"),
      }), i(2) }
    )
  ),
  s(
    "nlogger",
    fmta(
      [[#logger(error: any, ...args: any) {
      this.logger.error(error, { context: <>.name, ...args, });
      };
      ]],
      i(1, "ServiceName")
    )
  ),
  s(
    "ntry",
    fmta(
      [[try {

      } catch (error) {
        this.#logger(error, { function: '<>' });
      };
    ]] ,
      i(1, "MethodName")
    )
  ),
  s(--  TODO: 2022-08-09 - make this better
    "output",
    fmt(
      [[
@Output()
{} = new EventEmitter<string>();

{}({}: {}) {{
  this.{}.emit({});
}}
  ]]   ,
      { i(1, "event"), i(2, "eventFunction"), i(3, "eventValue"), i(4, "string"), i(5, "event"), i(6, "emit") }
    )
  ),
  s(
    "input",
    fmt(
      [[
@Input()
{} = '{}';
]]     ,
      { i(1, "event"), i(2, "eventValue") }
    )
  ),
  s(
    "con",
    fmta(
      [[
  constructor(<>) {
   <> 
  }
  ]]   ,
      { i(1), i(2) }
    )
  ),
  s(
    "inj",
    fmt([[{}{}: {},]], {
      c(1, {
        t("private "),
        t(""),
      }),
      i(2, "service"),
      f(function(args, snip)
        return utils.capitalize(args[1][1])
      end, { 2 }),
    })
  ),
  s("angenv", t([[import { environment } from 'src/environments/environment';]])),
  s(
    "tbi",
    fmt(
      [[
  {} = TestBed.inject({});
  ]]   ,
      { i(1), i(2) }
    )
  ),
})
