local ufo_u = require("util.ufo")
local const = require("config.constants").const

--  TODO: 2024-06-02 -  close windows with a table of filetypes, e.g.
--  {"neotest-output-panel"}

return {
  "folke/persistence.nvim",
  event = "BufReadPre",
  opts = {
    dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),
    options = const.opt.sessionoptions_tbl,
    pre_save = ufo_u.set_opts,
    save_empty = false,
    post_load = ufo_u.set_opts,
  },
}
