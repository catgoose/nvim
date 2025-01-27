local opts = {
  selection_chars = "FJDKSLA;CMRUEIWOQP",
  show_prompt = false,
  hint = "floating-big-letter",
  filter_rules = {
    bo = {
      filetype = { "notify", "quickfix" },
      buftype = { "terminal" },
    },
    wo = {},
    file_path_contains = {},
    file_name_contains = {},
  },
}

return {
  "s1n7ax/nvim-window-picker",
  event = "VeryLazy",
  version = "2.*",
  opts = opts,
}
