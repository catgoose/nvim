local M = {}

---@diagnostic disable-next-line: unused-local
function M.on_attach(client, bufnr)
  if not client.server_capabilities.semanticTokensProvider then
    local semantic = client.config.capabilities.textDocument.semanticTokens
    client.server_capabilities.semanticTokensProvider = {
      full = true,
      legend = {
        tokenTypes = semantic.tokenTypes,
        tokenModifiers = semantic.tokenModifiers,
      },
      range = true,
    }
  end

  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set("n", "<leader>k", function()
    local clients = vim.lsp.get_clients({ bufnr = bufnr })
    for _, _client in pairs(clients) do
      if _client.name == "gopls" or _client.name == "golangci_lint_ls" then
        vim.print(string.format("_client.name: %s", vim.inspect(_client.name)))
        vim.cmd.LspRestart(_client.name)
      end
    end
  end, bufopts)
end

return M
