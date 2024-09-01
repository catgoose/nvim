return {
  "andymass/vim-matchup",
  init = function()
    vim.g.matchup_matchparen_offscreen = { method = "popup" }
  end,
  event = "BufReadPre",
  --  TODO: 2024-09-01 - enable this when treesitter stops throwing errors
  enabled = false,
}
