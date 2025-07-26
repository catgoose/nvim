local opts = {
  NeoColumn = { "80" },
  always_on = true,
  custom_NeoColumn = {
    go = { "120" },
  },
  excluded_ft = {
    "text",
    "markdown",
    "dashboard",
    "templ",
  },
}

return {
  "ecthelionvi/NeoColumn.nvim",
  opts = opts,
  lazy = false,
}
