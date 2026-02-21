local M = {}

---@diagnostic disable-next-line: unused-local
function M.on_attach(client, bufnr)
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set("n", "<leader>k", require("config.lsp.util").restart, bufopts)
end

return M
