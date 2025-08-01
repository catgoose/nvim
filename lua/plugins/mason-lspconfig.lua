local opts = {
  ensure_installed = {
    "angularls",
    "awk_ls",
    "bashls",
    "csharp_ls",
    "cssls",
    "cssmodules_ls",
    "diagnosticls",
    "docker_compose_language_service",
    "dockerls",
    "emmet_ls",
    "eslint",
    "golangci_lint_ls",
    "gopls",
    "html",
    "jsonls",
    "lua_ls",
    "marksman",
    "powershell_es",
    "sqlls",
    "tailwindcss",
    "yamlls",
  },
  automatic_installation = true,
  automatic_enable = false,
}

return {
  "williamboman/mason-lspconfig.nvim",
  opts = opts,
  event = "BufReadPre",
  dependencies = "williamboman/mason.nvim",
}
