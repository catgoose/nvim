local diagnostic_signs = require("util.diagnostic_signs")
local hl = diagnostic_signs.hl

local signs = vim.list_extend(diagnostic_signs.legacy_signs(), {
  {
    name = "DapBreakpoint",
    dict = {
      text = "",
      texthl = hl.error,
      numhl = hl.error,
    },
  },
  {
    name = "DapStopped",
    dict = {
      text = "",
      texthl = hl.warn,
      numhl = hl.warn,
    },
  },
  {
    name = "DapBreakpointCondition",
    dict = {
      text = "󰋗",
      texthl = hl.hint,
      numhl = hl.hint,
    },
  },
  {
    name = "DapBreakpointRejected",
    dict = {
      text = "󰅙",
      texthl = hl.error,
      numhl = hl.error,
    },
  },
})
for _, sign in ipairs(signs) do
  vim.fn.sign_define(sign.name, sign.dict)
end

return signs
