local keys = require("util.project").get_keys("twvalues")

local ft = { "vue", "html" }

return {
  {
    "MaximilianLloyd/tw-values.nvim",
    -- dir = "~/git/tw-values.nvim",
    -- "catgoose/tw-values.nvim",
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
