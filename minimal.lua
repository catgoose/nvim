-- Run this file as `nvim --clean -u minimal.lua`

for name, url in pairs({
  -- ADD PLUGINS _NECESSARY_ TO REPRODUCE THE ISSUE, e.g:
  -- some_plugin = 'https://github.com/author/plugin.nvim'
  lspconfig = "neovim/nvim-lspconfig",
}) do
  local install_path = vim.fn.fnamemodify("nvim_issue/" .. name, ":p")
  if vim.fn.isdirectory(install_path) == 0 then
    vim.fn.system({ "git", "clone", "--depth=1", url, install_path })
  end
  vim.opt.runtimepath:append(install_path)
end

-- ADD INIT.LUA SETTINGS _NECESSARY_ FOR REPRODUCING THE ISSUE

-- local lspconfig = require("lspconfig")
-- local templ_opts = {
--   cmd = { "templ", "lsp", "-http=localhost:7474", "-log=/home/jtye/templ.log" },
--   filetypes = { "templ" },
--   root_dir = lspconfig.util.root_pattern("go.mod", ".git"),
--   settings = {},
-- }
-- lspconfig.templ.setup(templ_opts)
