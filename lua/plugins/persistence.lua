local c = require("util").create_cmd
local ufo_u = require("util.ufo")
local const = require("config.constants").const

return {
  "folke/persistence.nvim",
  event = "BufReadPre",
  init = function()
    c("PersistenceLoad", function()
      require("persistence").load()
    end)
  end,
  opts = {
    options = const.opt.sessionoptions_tbl,
    pre_save = ufo_u.set_opts,
    save_empty = false,
    post_load = ufo_u.set_opts,
  },
  commit = "3d443bd0a7e1d9eebfa37321fc8118d8d538af13",
}
