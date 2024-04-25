local m = require("util").lazy_map

local factor = { width = 0.5, height = 0.5 }
local scale = require("util").screen_scale(factor)

local opts = {
  keymaps = {
    ["g?"] = "actions.show_help",
    ["<CR>"] = "actions.select",
    ["<C-s>"] = "actions.select_split",
    ["<C-v>"] = "actions.select_vsplit",
    ["<C-t>"] = "actions.select_tab",
    ["<C-p>"] = "actions.preview",
    ["q"] = "actions.close",
    ["<C-c>"] = "actions.close",
    ["<C-r>"] = "actions.refresh",
    ["-"] = "actions.parent",
    ["_"] = "actions.open_cwd",
    ["`"] = "actions.cd",
    ["~"] = "actions.tcd",
    ["gs"] = "actions.change_sort",
    ["gx"] = "actions.open_external",
    ["g."] = "actions.toggle_hidden",
    ["g\\"] = "actions.toggle_trash",
  },
  win_options = {
    cursorline = true,
  },
  use_default_keymaps = false,
  float = {
    padding = 8,
    max_width = scale.width,
    max_height = scale.height,
  },
  view_options = {
    show_hidden = true,
  },
}

return {
  "stevearc/oil.nvim",
  opts = opts,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "antosha417/nvim-lsp-file-operations",
  },
  keys = {
    m("<leader>o", [[lua require("oil").toggle_float()]]),
  },
  lazy = false,
  commit = "8bb35eb81a48f14c4a1ef480c2bbb87ceb7cd8bb",
}
