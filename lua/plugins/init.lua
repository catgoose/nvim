local m = require("util").lazy_map

return {
  {
    "dstein64/vim-startuptime",
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
    "folke/neoconf.nvim",
    lazy = true,
  },
  {
    "seblj/roslyn.nvim",
    ft = "cs",
    config = true,
  },
}
