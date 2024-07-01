local m = require("util").lazy_map

local text = "┃"
local opts = {
  signs = {
    add = {
      text = text,
    },
    change = {
      text = text,
    },
    delete = {
      text = text,
    },
    topdelete = {
      text = text,
    },
    changedelete = {
      text = text,
    },
    untracked = {
      text = text,
    },
  },
  attach_to_untracked = true,
  current_line_blame_opts = {
    virt_text_pos = "right_align",
  },
  current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
  sign_priority = 1,
  on_attach = function()
    vim.cmd("redrawstatus")
  end,
}

return {
  "lewis6991/gitsigns.nvim",
  opts = opts,
  event = "BufReadPre",
  keys = {
    m("]h", "Gitsigns nav_hunk next"),
    m("[h", "Gitsigns nav_hunk prev"),
  },
}
