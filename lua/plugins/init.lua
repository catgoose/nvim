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
    "MeanderingProgrammer/markdown.nvim",
    -- name = "render-markdown", -- Only needed if you have another plugin named markdown.nvim
    dependencies = {
      "nvim-treesitter/nvim-treesitter", -- Mandatory
      "nvim-tree/nvim-web-devicons", -- Optional but recommended
    },
    config = true,
    lazy = false,
    -- config = function()
    --   require("render-markdown").setup({})
    -- end,
  },
}
