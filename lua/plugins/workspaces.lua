local m = require("util").lazy_map

local opts = {
  hooks = {
    open = { "Telescope find_files" },
  },
}

return {
  "natecraddock/workspaces.nvim",
  opts = opts,
  cmd = { "Telescope", "WorkspacesAdd" },
  keys = {
    m("<leader>tw", "Telescope workspaces"),
  },
  enabled = false,
}
