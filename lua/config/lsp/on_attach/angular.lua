local M = {}

--  TODO: 2024-11-03 - How to use vim.lsp.buf.rename to rename
--  component/template symbols correctly.
---@diagnostic disable-next-line: unused-local
function M.on_attach(client, bufnr)
  client.server_capabilities.renameProvider = false
end

return M
