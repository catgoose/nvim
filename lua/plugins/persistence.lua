local ufo_u = require("util.ufo")
local const = require("config.constants").const

return {
  "folke/persistence.nvim",
  event = "BufReadPre",
  opts = {
    dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),
    options = const.opt.sessionoptions_tbl,
    pre_save = ufo_u.set_opts,
    save_empty = false,
    post_load = function()
      -- vim.opt.formatoptions = vim.opt.formatoptions
      --   + "j" -- remove comment when joining lines
      --   + "l" -- long lines are not broken
      --   + "c" -- wrap comments
      --   + "n" -- recognized numbered lists
      --   - "t" -- wrap with text width
      --   - "r" -- insert comment after enter
      --   - "o" -- insert comment after o/O
      --   - "q" -- allow formatting of comments with gq
      --   - "a" -- format paragraphs
      --   - "2" -- use indent of second line for paragraph

      ufo_u.set_opts()
    end,
  },
}
