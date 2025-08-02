return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        "luvit-meta/library",
        "neotest",
        "nvim-dap-ui",
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
    dependencies = {
      "Bilal2453/luvit-meta",
      lazy = true,
    },
  },
}
