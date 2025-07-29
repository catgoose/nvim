local M = {}

---@diagnostic disable-next-line: unused-local
function M.on_attach(client, bufnr)
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set("n", "<leader>k", function()
    local clients = vim.lsp.get_clients({ bufnr = bufnr, name = "templ" })
    for _, _client in pairs(clients) do
      if _client.name == "templ" then
        vim.cmd.LspRestart(_client.name)
      end
    end
  end, bufopts)
end

return M
