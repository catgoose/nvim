-- local u = require("util")
-- local m = u.lazy_map

return {
  {
    "lambdalisue/suda.vim",
    event = "BufReadPost",
    enabled = false,
  },
  {
    "famiu/bufdelete.nvim",
    dependencies = "schickling/vim-bufonly",
    cmd = { "BufOnly", "Bdelete" },
  },
  {
    "romainl/vim-cool",
    event = "BufReadPost",
  },
  {
    "folke/neoconf.nvim",
    lazy = true,
  },
  {
    "seblj/roslyn.nvim",
    ft = "cs",
    config = true,
  },
  {
    {
      "Olical/conjure",
      ft = { "clojure", "fennel", "python", "lisp" },
      lazy = true,
    },
    {
      "gpanders/nvim-parinfer",
      config = true,
    },
  },
}
