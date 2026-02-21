return {
  {
    "Jay-Madden/auto-fix-return.nvim",
    ft = { "go" },
    config = true,
    opts = {
      log_level = vim.log.levels.DEBUG,
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    lazy = true,
    event = "VeryLazy",
  },
  {
    "catgoose/templ-goto-definition",
    ft = { "go", "templ" },
    config = true,
  },
  {
    "fredrikaverpil/godoc.nvim",
    ft = { "go" },
    version = "*",
    build = "go install github.com/lotusirous/gostdsym/stdsym@latest", -- optional
    cmd = { "GoDoc" },
    opts = {
      picker = {
        type = "telescope",
      },
    },
  },
}
