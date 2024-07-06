local m = require("util").lazy_map

return {
  {
    "dstein64/vim-startuptime",
    lazy = false,
  },
  {
    "litao91/lsp_lines",
    priority = 900,
    config = true,
  },
  {
    "wakatime/vim-wakatime",
    event = "BufReadPre",
  },
  {
    "lambdalisue/suda.vim",
    event = "BufReadPre",
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
    "leoluz/nvim-dap-go",
    config = true,
  },
  -- {
  --   "mistricky/codesnap.nvim",
  --   build = "make",
  --   config = true,
  -- },
}
