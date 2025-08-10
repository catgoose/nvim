return {
  "zapling/mason-conform.nvim",
  event = "BufReadPre",
  config = true,
  dependencies = {
    "williamboman/mason.nvim",
    "stevearc/conform.nvim",
  },
}
