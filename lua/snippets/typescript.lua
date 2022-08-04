local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local r = ls.restore_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("typescript", {
	s("cl", fmt("console.log({});", i(1))),
	s("cyg", fmt("cy.get({}).{}", { i(1), i(2) })),
	s("cygd", fmt("cy.get('[data-test={}]').{}", { i(1), i(2) })),
	s("exp", fmt("expect({}).{}", { i(1), i(2) })),
	s(
		"de",
		fmt(
			[[describe('{}', () => {{
    {}
  }});]],
			{ i(1), i(2) }
		)
	),
	s("nspy", {
		t("const "),
		i(1, "spy"),
		t(" = jest.spyOn("),
		i(2, "service"),
		t(", '"),
		i(3, "method"),
		t("');"),
	}),
	s("expspy", {
		t("expect("),
		i(1, "spy"),
		t(").toHaveBeenCalled();"),
	}),
	s("it", {
		t("it('"),
		i(1),
		t("', "),
		c(2, {
			t(" "),
			t("async "),
		}),
		t({ "() => {", "\t" }),
		i(3),
		t({ "", "});" }),
	}),
	s("be", {
		t("beforeEach("),
		c(1, {
			t(" "),
			t("async "),
		}),
		t({ "() => {", "\t" }),
		i(2),
		t({ "", "})" }),
	}),
	s("cg", {
		t("console.group('"),
		i(1),
		t({ "');", "" }),
		t("console.log("),
		i(2),
		t({ ");", "" }),
		t("console.groupEnd();"),
	}),
})
