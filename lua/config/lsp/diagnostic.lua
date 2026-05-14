local M = {}

function M.init()
  local diagnostic_signs = require("util.diagnostic_signs")
  vim.diagnostic.config({
    virtual_text = false,
    virtual_lines = {
      current_line = true,
    },
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
      focusable = true,
      border = "rounded",
      header = "",
      prefix = "",
    },
    signs = {
      text = diagnostic_signs.sign_text(),
    },
  })
end

return M
