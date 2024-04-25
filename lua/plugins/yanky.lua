local opts = {
  ring = {
    history_length = 1000,
    storage = "shada",
    sync_with_numbered_registers = true,
  },
  system_clipboard = {
    sync_with_ring = true,
  },
  highlight = {
    on_put = true,
    on_yank = true,
    timer = 500,
  },
  preserve_cursor_position = {
    enabled = true,
  },
}

return {
  "gbprod/yanky.nvim",
  opts = opts,
  keys = {
    { "y", "<Plug>(YankyYank)", mode = { "n", "x" } },
    { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" } },
    { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" } },
    { "<c-p>", "<Plug>(YankyCycleForward)" },
    { "<c-n>", "<Plug>(YankyCycleBackward)" },
    { "<leader>pp", "<cmd>YankyRingHistory<cr>" },
  },
  event = "BufReadPre",
}
