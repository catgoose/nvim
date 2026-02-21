local M = {}

function M.init()
  require("config.lsp.handlers.hover").init()

  ---@diagnostic disable-next-line: duplicate-set-field
  vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx)
    vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx)
  end
  ---@diagnostic disable-next-line: duplicate-set-field

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
