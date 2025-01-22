local M = {}

function M.init()
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx)
    local ts_lsp = { "ts_ls", "angularls", "volar" }
    local clients = vim.lsp.get_clients({ id = ctx.client_id })
    if clients and clients[1] and vim.tbl_contains(ts_lsp, clients[1].name) then
      local err_diag = {
        diagnostics = vim.tbl_filter(function(d)
          return d.severity == vim.diagnostic.severity.ERROR
        end, result.diagnostics),
      }
      require("ts-error-translator").translate_diagnostics(err, err_diag, ctx)
    end
    vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx)
  end
  local inlay_hint_handler = vim.lsp.handlers[vim.lsp.protocol.Methods["textDocument_inlayHint"]]
  vim.lsp.handlers[vim.lsp.protocol.Methods["textDocument_inlayHint"]] = function(err, result, ctx)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if not result then
      result = {}
    end
    if client then
      local row = unpack(vim.api.nvim_win_get_cursor(0))
      result = vim
        .iter(result)
        :filter(function(hint)
          -- return math.abs(hint.position.line - row) <= 5
          return hint.position.line + 1 == row and vim.api.nvim_get_mode().mode == "i"
        end)
        :totable()
    end
    inlay_hint_handler(err, result, ctx)
  end
end

return M
