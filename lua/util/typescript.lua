local M = {}

function M.actions(bufnr)
  local clients = vim.lsp.get_clients({
    name = "ts_ls",
    bufnr = bufnr,
  })
  if #clients == 0 then
    return
  end

  local onlies = {
    "source.addMissingImports.ts",
    "source.sortImports.ts",
  }

  for _, only in ipairs(onlies) do
    local params = vim.lsp.util.make_range_params()
    params.context = { only = { only } }
    local result = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, 1000)
    if result then
      for _, res in pairs(result) do
        if res.result then
          for _, action in ipairs(res.result) do
            if action.edit then
              vim.lsp.util.apply_workspace_edit(action.edit, "utf-8")
            else
              vim.lsp.buf.execute_command(action.command)
            end
          end
        end
      end
    end
  end
end

return M
