local opts = {
  duration = 500,
  undo = {
    hlgroup = "HighlightUndo",
    mode = "n",
    lhs = "u",
    map = "undo",
    opts = {},
  },
  redo = {
    hlgroup = "HighlightUndo",
    mode = "n",
    lhs = "<C-r>",
    map = "redo",
    opts = {},
  },
  highlight_for_count = true,
}

return {
  "tzachar/highlight-undo.nvim",
  opts = opts,
  event = { "BufReadPre" },
}
