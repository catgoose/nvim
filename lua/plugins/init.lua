local m = require("util").lazy_map

return {
  {
    "dstein64/vim-startuptime",
  },
  {
    "litao91/lsp_lines",
    priority = 900,
    config = true,
    enabled = false,
  },
  {
    "wakatime/vim-wakatime",
    event = "BufReadPre",
  },
  {
    "lambdalisue/suda.vim",
    event = "BufReadPre",
    enabled = false,
  },
  {
    "romainl/vim-cool",
    event = "BufReadPre",
  },
  {
    "famiu/bufdelete.nvim",
    dependencies = "schickling/vim-bufonly",
    cmd = { "BufOnly", "Bdelete" },
  },
  {
    "folke/neoconf.nvim",
    lazy = true,
  },
  {
    "rest-nvim/rest.nvim",
    lazy = false,
  },
  {
    "seblj/roslyn.nvim",
    ft = "cs",
    config = true,
  },
}
