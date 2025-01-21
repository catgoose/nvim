return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        "luvit-meta/library",
        "neotest",
        "nvim-dap-ui",
      },
    },
    dependencies = {
      "Bilal2453/luvit-meta",
      lazy = true,
    },
  },
}
