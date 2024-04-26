local char = { "▏", "▎", "▍" }

local opts = {
  indent = {
    char = char[1],
    tab_char = char[1],
  },
  scope = {
    enabled = false,
    char = char[2],
    show_start = false,
    show_end = false,
  },
}

local config = function()
  local hooks = require("ibl.hooks")
  hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
  hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_tab_indent_level)
  require("ibl").setup(opts)
end

return {
  "lukas-reineke/indent-blankline.nvim",
  opts = opts,
  config = config,
  event = "BufReadPre",
  main = "ibl",
  enabled = true,
}
