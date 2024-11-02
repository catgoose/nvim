local u = require("util")
local c, au = u.create_cmd, u.create_augroup

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

local function ts_on_attach(client, bufnr)
  on_attach(client, bufnr)
  vim.cmd.compiler("tsc")
  local t = require("util.typescript")
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set("n", "<leader>k", function()
    t.add_missing_imports(bufnr)
    t.remove_unused_imports(bufnr)
  end, bufopts)
  c("TSSortImports", function()
    t.sort_imports(bufnr)
  end)
  c("TSAddMissingImports", function()
    t.add_missing_imports(bufnr)
  end)
  c("TSRemoveUnused", function()
    t.remove_unused(bufnr)
  end)
  c("TSRemoveUnusedImports", function()
    t.remove_unused_imports(bufnr)
  end)
  vim.api.nvim_create_autocmd({ "BufWrite" }, {
    group = au("TypescriptWriteSortImports"),
    pattern = { "*.ts" },
    callback = function(ev)
      t.sort_imports(ev.bufnr)
    end,
  })
end

local function angular_on_attach(client, bufnr)
  on_attach(client, bufnr)
  client.server_capabilities.renameProvider = false
end

local function go_on_attach(client, bufnr)
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
  on_attach(client, bufnr)
end

function M.get(lsp)
  if lsp == "ts_ls" then
    return ts_on_attach
  end
  if lsp == "angularls" then
    return angular_on_attach
  end
  if lsp == "gopls" then
    return go_on_attach
  end
  return on_attach
end

return M
