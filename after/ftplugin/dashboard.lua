local dashboard = vim.api.nvim_create_augroup("DashboardWinhighlight", { clear = true })
vim.wo.winhighlight = "NormalNC:Normal"
vim.api.nvim_create_autocmd({ "BufReadPre" }, {
  group = dashboard,
  pattern = { "*" },
  callback = function()
    vim.wo.winhighlight = ""
    vim.api.nvim_create_augroup("DashboardWinhighlight", { clear = true })
  end,
})
