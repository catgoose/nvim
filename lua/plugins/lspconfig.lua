return {
  "neovim/nvim-lspconfig",
  config = function()
    require("neoconf").setup({})
    require("config.lsp")
  end,
  event = "BufReadPre",
  dependencies = {
    "folke/neoconf.nvim",
    {
      "williamboman/mason-lspconfig.nvim",
      opts = {
        ensure_installed = {
          "angularls",
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
      },
      event = "BufReadPre",
      dependencies = {
        "williamboman/mason.nvim",
        opts = {
          ui = {
            icons = {
              package_installed = "✓",
              package_pending = "➜",
              package_uninstalled = "✗",
            },
          },
        },
        cmd = "Mason",
        event = "BufReadPre",
      },
    },
    {
      "b0o/schemastore.nvim",
      event = "LspAttach",
      ft = { "json" },
    },
    {
      "jubnzv/virtual-types.nvim",
      event = "LspAttach",
    },
    {
      "dmmulroy/ts-error-translator.nvim",
      config = true,
      event = "LspAttach",
      ft = { "typescript", "typescriptreact", "javascript", "javascriptreact", "vue" },
    },
    {
      "chrisgrieser/nvim-lsp-endhints",
      event = "LspAttach",
      opts = {
        icons = {
          type = "󰋙 ",
          parameter = " ",
        },
        label = {
          padding = 1,
          marginLeft = 0,
          bracketedParameters = false,
        },
        autoEnableHints = false,
      },
    },
  },
}
