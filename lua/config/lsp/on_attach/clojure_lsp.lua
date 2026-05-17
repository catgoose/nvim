local M = {}

local function eval_current_form()
  local ok, eval = pcall(require, "conjure.eval")
  if ok and eval and eval["current-form"] then
    eval["current-form"]()
    return
  end

  vim.notify("Conjure current-form eval is unavailable", vim.log.levels.WARN)
end

---@diagnostic disable-next-line: unused-local
function M.on_attach(client, bufnr)
  local bufopts = {
    noremap = true,
    silent = true,
    buffer = bufnr,
    desc = "Conjure eval current form",
  }

  vim.keymap.set("n", "<leader>k", eval_current_form, bufopts)
end

return M
