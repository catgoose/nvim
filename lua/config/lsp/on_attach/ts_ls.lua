local u = require("util")
local c, au = u.create_cmd, u.create_augroup

local M = {}

local ACTIONS = {
  sort = "source.sortImports.ts",
  add_missing = "source.addMissingImports.ts",
  remove = "source.removeUnused.ts",
}

local function apply_code_actions(result, client)
  if not result then
    return
  end
  for _, res in pairs(result) do
    if res.result then
      for _, r in ipairs(res.result) do
        if r.edit then
          vim.lsp.util.apply_workspace_edit(r.edit, client.offset_encoding)
        else
          client.exec_command(r.command)
        end
      end
    end
  end
end

local function get_client(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ name = "ts_ls", bufnr = bufnr })
  if not #clients == 1 then
    return
  end
  return clients[1]
end

local function code_action(action, bufnr)
  if not action then
    return
  end
  local client = get_client(bufnr)
  if not client then
    return
  end
  local params = vim.lsp.util.make_range_params(0, "utf-16")
  params.context = { only = { action } }
  pcall(function()
    local result = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, 1000)
    if result then
      apply_code_actions(result, client)
    end
  end)
end

--  TODO: 2024-11-02 - Handle blocks of imports
function M.remove_unused_imports(bufnr)
  local client = get_client(bufnr)
  if not client then
    return
  end
  local ts_query = "(import_statement) @is"
  local parser = vim.treesitter.get_parser(0, "typescript")
  if not parser then
    return
  end
  local tstree = parser:parse()[1]
  local node = tstree:root()
  if not node then
    return
  end
  local ranges = {}
  local query = vim.treesitter.query.parse("typescript", ts_query)
  for child in node:iter_children() do
    for _, arg in query:iter_captures(child, 0) do
      local start_row, start_col, end_row, end_col = arg:range()
      table.insert(
        ranges,
        { start_row = start_row, start_col = start_col, end_row = end_row, end_col = end_col }
      )
    end
  end
  if next(ranges) == nil then
    return
  end
  local range = {
    start_row = ranges[1].start_row,
    start_col = ranges[1].start_col,
    end_row = ranges[#ranges].end_row,
    end_col = ranges[#ranges].end_col,
  }
  local params = vim.lsp.util.make_given_range_params(
    { range.start_row, range.start_col },
    { range.end_row, range.end_col },
    bufnr,
    client.offset_encoding
  )
  params.context = { only = { ACTIONS.remove } }
  local result = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, 1000)
  apply_code_actions(result, client)
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

---@diagnostic disable-next-line: unused-local
function M.on_attach(client, bufnr)
  vim.cmd.compiler("tsc")
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set("n", "<leader>k", function()
    M.add_missing_imports(bufnr)
    M.remove_unused_imports(bufnr)
  end, bufopts)
  c("TSSortImports", function()
    M.sort_imports(bufnr)
  end)
  c("TSAddMissingImports", function()
    M.add_missing_imports(bufnr)
  end)
  c("TSRemoveUnused", function()
    M.remove_unused(bufnr)
  end)
  c("TSRemoveUnusedImports", function()
    M.remove_unused_imports(bufnr)
  end)
  -- vim.api.nvim_create_autocmd({ "BufWrite" }, {
  --   group = au("TypescriptWriteSortImports"),
  --   pattern = { "*.ts" },
  --   callback = function(ev)
  --     M.sort_imports(ev.bufnr)
  --   end,
  -- })
end

return M
