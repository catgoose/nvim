return {
  "nvim-treesitter/nvim-treesitter-context",
  config = true,
  event = "BufReadPre",
  --  TODO: 2024-09-01 - enable this when treesitter stops throwing errors
  enabled = false,
}
