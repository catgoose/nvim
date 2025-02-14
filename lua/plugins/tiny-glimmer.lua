local opts = {
  overwrite = {
    undo = {
      enabled = true,
      default_animation = {
        name = "fade",
        settings = {
          from_color = "DiffDelete",
          max_duration = 750,
          min_duration = 500,
        },
      },
      undo_mapping = "u",
    },
    redo = {
      enabled = true,
      default_animation = {
        name = "fade",
        settings = {
          from_color = "DiffAdd",
          max_duration = 750,
          min_duration = 500,
        },
      },
      redo_mapping = "<c-r>",
    },
    paste = {
      enabled = true,
      default_animation = {
        name = "fade",
        settings = {
          max_duration = 750,
          min_duration = 500,
        },
      },
      paste_mapping = {
        lhs = "p",
        rhs = "<Plug>(YankyPutAfter)",
      },
      Paste_mapping = {
        lhs = "P",
        rhs = "<Plug>(YankyPutBefore)",
      },
    },
    animations = {
      fade = {
        max_duration = 750,
        min_duration = 500,
        easing = "outQuad",
        chars_for_max_duration = 10,
      },
    },
  },
}

return {
  "rachartier/tiny-glimmer.nvim",
  event = "VeryLazy",
  opts = opts,
}
