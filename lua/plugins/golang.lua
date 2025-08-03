return {
  {
    "Jay-Madden/auto-fix-return.nvim",
    ft = { "go" },
    config = true,
    lazy = true,
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
