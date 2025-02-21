local M = {}

local function inlay_hints_on_attach(client, bufnr)
  local inlay_lsp = {
    "gopls",
  }
  if vim.tbl_contains(inlay_lsp, client.name) then
    vim.lsp.inlay_hint.enable()
    require("config.lsp.autocmd").inlay_hints()(bufnr)
  else
    vim.lsp.inlay_hint.enable(false)
  end
end

local function virtual_types_on_attach(client, bufnr)
  if client.server_capabilities.textDocument then
    if client.server_capabilities.textDocument.codeLens then
      require("virtualtypes").on_attach(client, bufnr)
    end
  end
end

local function on_attach(client, bufnr)
  virtual_types_on_attach(client, bufnr)
  inlay_hints_on_attach(client, bufnr)
end

function M.get(lsp)
  if not lsp then
    return on_attach
  end
  local ok, f = pcall(require, "config.lsp.on_attach." .. lsp, "on_attach")
  return ok
      and function(client, bufnr)
        on_attach(client, bufnr)
        f.on_attach(client, bufnr)
      end
    or on_attach
end

return M
