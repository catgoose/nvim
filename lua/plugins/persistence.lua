local u = require("util")
local c = u.create_cmd
local m = u.lazy_map
local augroup = u.create_augroup
local autocmd = vim.api.nvim_create_autocmd
local ufo_u = require("util.ufo")

return {
  "folke/persistence.nvim",
  event = "BufReadPre",
  config = true,
  init = function()
    local persistence = require("persistence")
    c("PersistenceLoad", persistence.load)
    c("PersistenceSelect", persistence.select)
    c("PersistenceStop", persistence.stop)
    local group = augroup("PersistenceEvents")
    local patterns = { "PersistenceLoad", "PersistenceSavePre" }
    for _, pattern in ipairs(patterns) do
      autocmd({ "User" }, {
        pattern = pattern,
        group = group,
        callback = ufo_u.set_opts,
      })
    end
  end,
  keys = {
    m("<leader>pl", [[lua require('persistence').load()]]),
    m("<leader>ps", [[lua require('persistence').select()]]),
    m("<leader>pS", [[lua require('persistence').stop()]]),
  },
  dependencies = { "stevearc/dressing.nvim" },
}
