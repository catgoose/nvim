local keys = require("util.project").get_keys("nvim-ts-autotag")

local opts = {
  opts = {
    enable_close = true,
    enable_rename = true,
    enable_close_on_slash = true,
  },
  aliases = {
    ["vue"] = "html",
  },
}

return {
  "windwp/nvim-ts-autotag",
  -- dir = "~/git/nvim-ts-autotag",
  opts = opts,
  keys = keys,
  event = "BufReadPre",
}
