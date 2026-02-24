local opts = {
  timeout = 100,
  stages = "fade_in_slide_out",
  top_down = true,
  render = "simple",
  fps = 120,
  level = vim.log.levels.DEBUG,
}

return {
  "rcarriga/nvim-notify",
  opts = opts,
  event = "BufReadPost",
  lazy = true,
}
