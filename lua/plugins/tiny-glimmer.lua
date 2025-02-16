local opts = {
  refresh_interval = 3,
  overwrite = {
    undo = {
      enabled = true,
      default_animation = {
        name = "fade",
        settings = {
          from_color = "DiffDelete",
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
        },
      },
      redo_mapping = "<c-r>",
    },
    yank = {
      enabled = true,
      default_animation = "fade",
    },
    paste = {
      enabled = true,
      default_animation = "fade",
      paste_mapping = {
        lhs = "p",
        rhs = "<Plug>(YankyPutAfter)",
      },
      Paste_mapping = {
        lhs = "P",
        rhs = "<Plug>(YankyPutBefore)",
      },
    },
  },
  animations = {
    fade = {
      min_duration = 750,
      max_duration = 1000,
      easing = "outQuad",
      chars_for_max_duration = 10,
      from_color = "Visual",
    },
  },
}

return {
  "rachartier/tiny-glimmer.nvim",
  event = "VeryLazy",
  opts = opts,
}
