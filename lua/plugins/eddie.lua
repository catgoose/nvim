local dev = true
local enabled = true
local e = vim.tbl_extend
local m = require("util").lazy_map
local project = require("util.project")

local opts = {
  log_level = "debug",
}

local keys = {
  -- m("<leader>;", [[]]),
}
keys = project.get_keys("eddie", keys)

local plugin = {
  dependencies = "nvim-lua/plenary.nvim",
  opts = opts,
  keys = keys,
  enabled = enabled,
}

if dev == true then
  return e("keep", plugin, {
    dir = "~/git/eddie.nvim",
    lazy = false,
  })
else
  return e("keep", plugin, {
    "catgoose/eddie.nvim",
    event = "BufReadPre",
  })
end
