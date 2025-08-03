local u = require("util")
local c = u.create_cmd
local m = u.lazy_map

return {
  "folke/persistence.nvim",
  event = "BufReadPost",
  config = true,
  init = function()
    local persistence = require("persistence")
    c("PersistenceLoad", persistence.load)
    c("PersistenceSelect", persistence.select)
    c("PersistenceStop", persistence.stop)
  end,
  keys = {
    m("<leader>pl", [[lua require('persistence').load()]]),
    m("<leader>ps", [[lua require('persistence').select()]]),
    m("<leader>pS", [[lua require('persistence').stop()]]),
  },
  dependencies = { "stevearc/dressing.nvim" },
}
