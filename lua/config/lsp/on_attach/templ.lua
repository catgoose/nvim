local M = {}

---@diagnostic disable-next-line: unused-local
function M.on_attach(client, bufnr)
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set("n", "<leader>k", vim.cmd.LspRestart, bufopts)
end

return M
