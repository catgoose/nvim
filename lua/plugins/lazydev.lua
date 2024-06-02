return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        "luvit-meta/library",
        plugins = { "neotest" },
        types = true,
      },
    },
    dependencies = {
      "Bilal2453/luvit-meta",
      lazy = true,
    },
  },
}
