local m = require("util").lazy_map
local palette = require("kanagawa.colors").setup({ theme = "wave" }).palette

local opts = {
  buffers = {
    colors = {
      background = palette.sumiInk0,
      text = palette.sumiInk0,
    },
    -- wo = {
    --   winbar = "",
    -- },
  },
}

return {
  "shortcuts/no-neck-pain.nvim",
  version = "*",
  opts = opts,
  event = "BufReadPre",
  cmd = { "NoNeckPain" },
  keys = {
    m("<leader>v", [[NoNeckPain]]),
  },
}
