return {
  {
    "ellisonleao/glow.nvim",
    config = true,
    cmd = "Glow",
    ft = { "markdown" },
  },
  {
    "MeanderingProgrammer/markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    ft = { "markdown" },
    config = true,
  },
}
