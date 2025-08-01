local m = require("util").lazy_map

return {
  {
    "lambdalisue/suda.vim",
    event = "BufReadPre",
    enabled = false,
  },
  {
    "famiu/bufdelete.nvim",
    dependencies = "schickling/vim-bufonly",
    cmd = { "BufOnly", "Bdelete" },
  },
  {
    "romainl/vim-cool",
    event = "BufReadPre",
  },
  {
    "folke/neoconf.nvim",
    lazy = true,
  },
  {
    "seblj/roslyn.nvim",
    ft = "cs",
    config = true,
  },
}
