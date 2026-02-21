local M = {}

function M.restart()
  local bufnr = vim.api.nvim_get_current_buf()
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
    client:stop()
  end
  vim.cmd("edit")
end

return M
