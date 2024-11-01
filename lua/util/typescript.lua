local M = {}

local ACTIONS = {
  sort = "source.sortImports.ts",
  add_missing = "source.addMissingImports.ts",
  remove = "source.removeUnused.ts",
}

--  TODO: 2024-11-01 - create TS query to remove unused imports over line range

local function code_action(actions, bufnr)
  if not actions then
    return
  end
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({
    name = "ts_ls",
    bufnr = bufnr,
  })
  if #clients == 0 then
    return
  end

  if type(actions) == "string" then
    actions = { actions }
  end

  for _, only in ipairs(actions) do
    local params = vim.lsp.util.make_range_params()
    params.context = { only = { only } }
    local result = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, 1000)
    if result then
      for _, res in pairs(result) do
        if res.result then
          for _, r in ipairs(res.result) do
            if r.edit then
              vim.lsp.util.apply_workspace_edit(r.edit, "utf-8")
            else
              vim.lsp.buf.execute_command(r.command)
            end
          end
        end
      end
    end
  end
end

function M.fix(bufnr)
  local actions = {
    ACTIONS.add_missing,
    ACTIONS.sort,
  }
  code_action(actions, bufnr)
end

function M.add_missing_imports(bufnr)
  code_action(ACTIONS.add_missing, bufnr)
end

function M.sort_imports(bufnr)
  code_action(ACTIONS.sort, bufnr)
end

function M.remove_unused(bufnr)
  code_action(ACTIONS.remove, bufnr)
end

return M
