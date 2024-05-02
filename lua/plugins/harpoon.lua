local u = require("util")
local m = u.lazy_map
local opts = {
  settings = {
    sync_on_ui_close = true,
    save_on_toggle = true,
  },
}

return {
  "ThePrimeagen/harpoon",
  opts = opts,
  keys = {
    m("<leader>a", function()
      require("harpoon"):list():add()
    end, { "n", "x" }),
    m("<leader>l", function()
      local harpoon = require("harpoon")
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { "n", "x" }),
    m("]]", function()
      require("harpoon"):list():next({
        ui_nav_wrap = true,
      })
    end, { "n", "x" }),
    m("[[", function()
      require("harpoon"):list():prev({
        ui_nav_wrap = true,
      })
    end, { "n", "x" }),
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "pockata/harpoon-highlight-current-file",
      config = true,
    },
  },
  branch = "harpoon2",
}
