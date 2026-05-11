local use_local_plugin = require("util").use_local_plugin

local auto_fix_return_path = "~/git/auto-fix-return.nvim"
local auto_fix_return = {
  ft = { "go" },
  config = true,
  opts = {
    -- log_level = vim.log.levels.DEBUG,
  },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  lazy = true,
  event = "VeryLazy",
}

auto_fix_return = vim.tbl_extend(
  "keep",
  auto_fix_return,
  use_local_plugin(auto_fix_return_path) and {
    dir = auto_fix_return_path,
  } or {
    "Jay-Madden/auto-fix-return.nvim",
  }
)

return {
  auto_fix_return,
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
