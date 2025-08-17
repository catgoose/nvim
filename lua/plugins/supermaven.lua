local u = require("util")
local m = u.lazy_map

local opts = {
  keymaps = {
    accept_suggestion = "<Tab>",
    clear_suggestion = "<C-k>",
    accept_word = "<C-j>",
  },
  ignore_filetypes = {
    help = true,
    gitcommit = true,
    prompt = true,
    oil = true,
  },
  log_level = "off",
  disable_inline_completion = false,
  disable_keymaps = false,
}

return {
  "supermaven-inc/supermaven-nvim",
  opts = opts,
  keys = {
    m("<M-]>", "SupermavenToggle", { "n", "i" }),
  },
  cmd = { "SupermavenStart", "SupermavenToggle" },
  lazy = true,
}
