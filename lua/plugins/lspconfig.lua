local config = function()
  require("config.lsp")
end

return {
  "neovim/nvim-lspconfig",
  init = function()
    require("neoconf").setup({})
  end,
  config = config,
  dependencies = {
    "folke/neoconf.nvim",
    "williamboman/mason-lspconfig.nvim",
    {
      "b0o/schemastore.nvim",
      event = "LspAttach",
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
