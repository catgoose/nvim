return {
  "chrisgrieser/nvim-origami",
  opts = {
    autoFold = {
      enabled = true,
      kinds = { "comment", "imports" }, ---@type lsp.FoldingRangeKind[]
    },
  },
  event = "BufReadPost",
  init = function()
    vim.opt.foldlevel = 99
    vim.opt.foldlevelstart = 99
  end,
}
