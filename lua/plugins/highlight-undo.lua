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
  commit = "795fc36f8bb7e4cf05e31bd7e354b86d27643a9e",
}
