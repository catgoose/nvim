local opts = {
  show_numbers = true,
  show_cursorline = true,
  number_only = false,
  centered_peeking = true,
}

return {
  "nacro90/numb.nvim",
  opts = opts,
  event = "BufReadPre",
}
