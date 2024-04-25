local m = require("util").lazy_map

local opts = {
  highlight_moving_win = true,
  focused_hl_group = "Visual",
  moving_win_options = {
    wrap = false,
    cursorline = false,
    cursorcolumn = false,
    colorcolumn = "",
  },
  picker_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
  filter_rules = {
    cur_win = true,
    floats = true,
    buftype = {
      "terminal",
    },
    bufname = {},
  },
}

return {
  "sindrets/winshift.nvim",
  opts = opts,
  cmd = "WinShift",
  keys = {
    m("<leader>sd", [[WinShift<cr>]]),
    m("<leader>sa", [[WinShift swap]]),
    m("<leader>sh", [[WinShift left]]),
    m("<leader>sj", [[WinShift down]]),
    m("<leader>sk", [[WinShift up]]),
    m("<leader>sl", [[WinShift right]]),
  },
}
