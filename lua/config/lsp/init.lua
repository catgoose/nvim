local f = {
  "autocmd",
  "diagnostic",
  "servers"
}

for _, module in ipairs(f) do
  local ok, m = pcall(require, "config.lsp." .. module)
  if not ok then
    vim.notify("Failed to load config.lsp." .. module .. ": " .. m, vim.log.levels.ERROR)
  else
    m.init()
  end
end
