local M = {}

function M.init()
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
    -- signs = require("config.signs")
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = '',
        [vim.diagnostic.severity.WARN] = '',
        [vim.diagnostic.severity.HINT] = '',
        [vim.diagnostic.severity.INFO] = '',
      }
    }
  })
end

return M
