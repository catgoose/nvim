local m = require("util").lazy_map

local opts = {
  float_diff = false,
  layout = "left_bottom", -- "left_bottom", "left_left_bottom"
  ignore_filetype = {
    "Undotree",
    "UndotreeDiff",
    "qf",
    "TelescopePrompt",
    "spectre_panel",
    "tsplayground",
  },
  window = {
    winblend = 2,
  },
  keymaps = {
    ["j"] = "move_next",
    ["k"] = "move_prev",
    ["J"] = "move_change_next",
    ["K"] = "move_change_prev",
    ["<cr>"] = "action_enter",
    ["p"] = "enter_diffbuf",
    ["q"] = "quit",
  },
}
return {
  "jiaoshijie/undotree",
  opts = opts,
  event = "BufReadPre",
  keys = {
    m("<leader>u", [[lua require("undotree").toggle()]], { "n", "x" }),
  },
  dependencies = "nvim-lua/plenary.nvim",
}
