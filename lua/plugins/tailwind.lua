local keys = require("util.project").get_keys("twvalues")

local ft = { "vue", "html", "templ" }

return {
  {
    -- "MaximilianLloyd/tw-values.nvim",
    dir = "~/git/tw-values.nvim",
    opts = {
      show_unknown_classes = true,
      focus_preview = true,
    },
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
