local m = require("util").lazy_map

local opts = {
  enable = false,
  include_declaration = true,
  sections = {
    definition = false,
    references = true,
    implements = true,
  },
  ignore_filetype = {
    "prisma",
  },
}

return {
  "VidocqH/lsp-lens.nvim",
  opts = opts,
  event = "BufReadPre",
  keys = {
    m("<leader>dl", "LspLensToggle"),
  },
}
