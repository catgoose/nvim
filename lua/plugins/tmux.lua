local opts = {
  copy_sync = {
    enable = false,
  },
  navigation = {
    cycle_navigation = true,
    enable_default_keybindings = true,
    persist_zoom = true,
  },
  resize = {
    enable_default_keybindings = false,
    resize_step_x = 1,
    resize_step_y = 1,
  },
}

return {
  "aserowy/tmux.nvim",
  event = "BufReadPre",
  opts = opts,
}
