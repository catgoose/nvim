local u = require("util")
local c = u.create_cmd
local augroup = u.create_augroup
local autocmd = vim.api.nvim_create_autocmd
local ufo_u = require("util.ufo")

return {
  "folke/persistence.nvim",
  event = "BufReadPre",
  init = function()
    local persistence = require("persistence")
    c("PersistenceLoad", persistence.load)
    c("PersistenceSelect", persistence.select)
    local group = augroup("PersistenceEvents")
    autocmd({ "User" }, {
      pattern = "PersistenceLoadPost",
      group = group,
      callback = ufo_u.set_opts,
    })
    autocmd({ "User" }, {
      pattern = "PersistenceSavePre",
      group = group,
      callback = ufo_u.set_opts,
    })
  end,
  opts = {
    branch = true,
  },
  dependencies = { "stevearc/dressing.nvim" },
}
