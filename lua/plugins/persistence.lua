local u = require("util")
local c = u.create_cmd

return {
  "folke/persistence.nvim",
  event = "VeryLazy",
  config = true,
  init = function()
    local persistence = require("persistence")
    c("PersistenceLoad", persistence.load)
    c("PersistenceSelect", persistence.select)
    c("PersistenceStop", persistence.stop)
  end,
  dependencies = { "stevearc/dressing.nvim" },
  lazy = true,
}
