local m = require("util").lazy_map

local opts = {
  global = {
    movement = {
      next = { "<C-n>", "<C-j>" },
      previous = { "<C-p>", "<C-k>" },
    },
  },
  namu_symbols = {
    enable = true,
    options = {
      auto_select = true,
      AllowKinds = {
        default = {
          "Function",
          "Method",
          "Class",
          "Module",
          "Property",
          "Variable",
          -- "Constant",
          -- "Enum",
          -- "Interface",
          -- "Field",
          -- "Struct",
        },
        go = {
          "Function",
          "Method",
          "Struct",
          "Field",
          "Interface",
          "Constant",
          -- "Variable",
          "Property",
          -- "TypeParameter",
        },
        lua = { "Function", "Method", "Table", "Module" },
      },
    },
  },
}

return {
  "bassamsdata/namu.nvim",
  opts = opts,
  keys = {
    m("<leader>y", [[lua require("namu.namu_symbols").show()]]),
  },
  lazy = true,
}
