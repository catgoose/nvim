return {
  {
    "Jay-Madden/auto-fix-return.nvim",
    config = function()
      require("auto-fix-return").setup({})
    end,
    lazy = false,
    enabled = true,
  },
  {
    "jack-rabe/impl.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    opts = {
      layout_strategy = "vertical",
      layout_config = {
        width = 0.5,
      },
    },
    ft = { "go" },
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
