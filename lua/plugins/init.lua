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
    opts = {
      broad_search = true,
      lock_target = false,
      choose_target = nil,
      ignore_target = nil,
    },
  },
  -- {
  --   "jamessan/vim-gnupg",
  --   config = true,
  -- },
}
