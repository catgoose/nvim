return {
  {
    "MeanderingProgrammer/markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    ft = { "markdown" },
    opts = {
      code_style = "normal",
      highlights = {
        code = "MarkdownFence",
      },
    },
  },
}
