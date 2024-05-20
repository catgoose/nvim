local colors = require("config.colors")

local opts = {
  autoselect_one = false,
  include_current_win = true,
  filter_rules = {
    bo = {
      filetype = { "neo-tree", "neo-tree-popup", "notify", "quickfix" },
      buftype = { "terminal" },
    },
  },
  selection_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
  use_winbar = "always",
  fg_color = colors.sumiInk2,
  current_win_hl_color = colors.roninYellow,
  other_win_hl_color = colors.oniViolet,
}

return {
  "s1n7ax/nvim-window-picker",
  version = "v1.*",
  opts = opts,
}
