local u = require("util")
local m = u.lazy_map

return {
  "dmtrKovalenko/fff.nvim",
  build = "cargo build --release -Znext-lockfile-bump",
  opts = {
    prompt = " ",
    preview = {
      enabled = true,
      binary_file_threshold = 64,
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
      toggle_debug = nil,
    },
  },
  keys = {
    m("<leader>f", [[lua require("fff").find_files()]]),
  },
  event = "VeryLazy",
  lazy = true,
}
