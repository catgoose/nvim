local m = require("util").lazy_map

return {
  "folke/trouble.nvim",
  opts = {},
  cmd = "Trouble",
  keys = {
    m("<leader>xx", [[Trouble diagnostics toggle]]),
    m("<leader>xX", [[Trouble diagnostics toggle filter.buf=0]]),
    m("<leader>cs", [[Trouble symbols toggle focus=false]]),
    m("<leader>cl", [[Trouble lsp toggle focus=false win.position=right]]),
    m("<leader>xL", [[Trouble loclist toggle]]),
    m("<leader>xQ", [[Trouble qflist toggle]]),
  },
}
