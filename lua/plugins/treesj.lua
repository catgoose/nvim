local m = require("util").lazy_map

local opts = {
  use_default_keymaps = false,
  max_join_length = 512,
}

return {
  "Wansmer/treesj",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  keys = {
    m("<leader>I", [[lua require("treesj").toggle({split = {recursive = true}})]]),
  },
  opts = opts,
  enabled = true,
}
