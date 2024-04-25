local opts = {
  lastplace_ignore_buftype = {
    "quickfix",
    "nofile",
    "help",
    "terminal",
  },
  lastplace_ignore_filetype = {
    "gitcommit",
    "gitrebase",
    "svn",
    "hgcommit",
    "toggleterm",
    "dashboard",
  },
  lastplace_open_folds = false,
}

return {
  "ethanholz/nvim-lastplace",
  opts = opts,
  event = "BufReadPre",
}
