local t = require("util.toggle")
local u = require("util")
local m = u.lazy_map
local opts = t.toggleterm_opts
local modes = { "n", "t" }

return {
  "akinsho/toggleterm.nvim",
  opts = opts,
  event = "VeryLazy",
  version = "*",
  keys = {
    m("[1", "ToggleTermSpotify", modes),
    m("[2", "ToggleTermLazyDocker", modes),
    m("[3", "ToggleTermLazyGit", modes),
    m("[4", "ToggleTermFish", modes),
    m("[5", "ToggleTermWeeChat", modes),
    m("[8", "ToggleTermRepl", modes),
    m("[0", "ToggleTermPowershell", modes),
  },
  branch = "main",
}
