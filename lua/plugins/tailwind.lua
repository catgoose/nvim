local keys = require("util.project").get_keys("twvalues")

local ft = { "vue", "html", "templ" }

return {
  {
    "MaximilianLloyd/tw-values.nvim",
    opts = {
      focus_preview = true,
    },
    lazy = true,
    ft = ft,
    keys = keys,
  },
  {
    "roobert/tailwindcss-colorizer-cmp.nvim",
    opts = {
      color_square_width = 2,
    },
    event = "InsertEnter",
  },
}
