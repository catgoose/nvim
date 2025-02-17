local opts = {
  bigfile = { enabled = true },
  input = { enabled = true },
  ---
  dashboard = { enabled = false },
  explorer = { enabled = false },
  indent = { enabled = false },
  notifier = { enabled = false },
  picker = { enabled = false },
  quickfile = { enabled = false },
  scope = { enabled = false },
  scroll = { enabled = false },
  statuscolumn = { enabled = false },
  words = { enabled = false },
}

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = opts,
}
