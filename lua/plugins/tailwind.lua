local keys = require("util.project").get_keys("twvalues")

return {
  {
    "MaximilianLloyd/tw-values.nvim",
    -- dir = "~/git/tw-values.nvim",
    opts = {
      show_unknown_classes = true,
      focus_preview = true,
      hover_single_class = true,
    },
    keys = keys,
    ft = { "vue", "html", "templ" },
    lazy = true,
  },
  {
    "roobert/tailwindcss-colorizer-cmp.nvim",
    opts = {
      color_square_width = 2,
    },
    event = "InsertEnter",
    lazy = true,
  },
}
