local u = require("util")
local m = u.lazy_map
local c = u.create_cmd

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
    "dmtrKovalenko/fff.nvim",
    build = "cargo build --release",
    init = function()
      c("FFF", require("fff").find_files)
    end,
    opts = {
      prompt = " ",
      preview = {
        enabled = false,
      },
      keymaps = {
        close = "<Esc>",
        select = "<CR>",
        select_split = "<C-s>",
        select_vsplit = "<C-v>",
        select_tab = "<C-t>",
        move_up = { "<C-k>" },
        move_down = { "<C-j>" },
        preview_scroll_up = "<C-u>",
        preview_scroll_down = "<C-d>",
      },
    },
    keys = {
      m("<leader>f", [[lua require("fff").find_files()]]),
    },
  },
}
