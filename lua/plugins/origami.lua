return {
  "chrisgrieser/nvim-origami",
  config = true,
  event = "BufReadPost",
  init = function()
    vim.opt.foldlevel = 99
    vim.opt.foldlevelstart = 99
  end,
}
