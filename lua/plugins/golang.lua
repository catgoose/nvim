return {
  {
    "Jay-Madden/auto-fix-return.nvim",
    config = function()
      require("auto-fix-return").setup({})
    end,
    ft = "go",
    lazy = true,
  },
  {
    "catgoose/templ-goto-definition",
    ft = { "go", "templ" },
    config = true,
  },
  {
    "fredrikaverpil/godoc.nvim",
    version = "*",
    dependencies = {
      { "nvim-telescope/telescope.nvim" },
      {
        "nvim-treesitter/nvim-treesitter",
        opts = {
          ensure_installed = { "go" },
        },
      },
    },
    build = "go install github.com/lotusirous/gostdsym/stdsym@latest", -- optional
    cmd = { "GoDoc" },
    opts = {
      picker = {
        type = "telescope",
      },
    },
  },
}
