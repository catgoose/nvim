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
    layout = {
      height = 0.4,
      width = 0.5,
      prompt_position = "top", -- or 'top'
      preview_position = "right", -- or 'left', 'right', 'top', 'bottom'
      preview_size = 0.4,
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
    -- height = "0.5",
    -- width = "0.6",
  },
  keys = {
    m("<leader>f", [[lua require("fff").find_files()]]),
  },
  event = "VeryLazy",
  lazy = true,
}
