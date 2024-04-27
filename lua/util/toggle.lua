local utils = require("util.utils")

local M = {}

function M.toggleterm_opts(added_opts)
  local scale = 0.85
  local scale = utils.screen_scale({ width = scale, height = scale })
  local toggleterm_opts = {
    auto_scroll = true,
    direction = "float",
    float_opts = {
      border = "curved",
      width = scale.width,
      height = scale.height,
      winblend = 2,
    },
    winbar = {
      enabled = false,
    },
    shade_terminals = true,
    hide_numbers = false,
    on_open = function(term)
      vim.api.nvim_buf_set_keymap(
        term.bufnr,
        "n",
        "q",
        [[<cmd>close<cr>]],
        { noremap = true, silent = true }
      )
    end,
    on_close = function() end,
  }
  if not added_opts then
    return toggleterm_opts
  end
  return vim.tbl_deep_extend("force", toggleterm_opts, added_opts)
end

return M
