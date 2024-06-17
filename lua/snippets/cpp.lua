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
    "main",
    fmt(
      [[
#include <iostream>

using namespace std;

int main(int argc, char *argv[]) {{
  {} 
  cout << "" << endl;
  return 0;
}}
    ]],
      { i(1) }
    )
  ),
  s(
    "cl",
    fmta(
      [[
class <> {
public:
  <>() {}
  ~<>() {}
protected:
private:
<>
};
  ]],
      { i(1, "ClassName"), smn(1), smn(1), i(0) }
    )
  ),
  s({ trig = "cou?n?t?", regTrig = true }, fmt([[cout << {} << endl;]], { i(1) })),
}

return snippets
