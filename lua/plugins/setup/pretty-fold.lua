require("config.utils").plugin_setup("pretty-fold", {
  keep_indentation = false,
  fill_char = "━",
  sections = {
    left = {
      "━ ",
      function()
        return string.rep("*", vim.v.foldlevel)
      end,
      " ━┫",
      "content",
      "┣",
    },
    right = {
      "┫ ",
      "number_of_folded_lines",
      ": ",
      "percentage",
      " ┣━━",
    },
  },
})
