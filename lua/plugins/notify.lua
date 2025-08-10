local opts = {
  timeout = 100,
  stages = "fade_in_slide_out",
  top_down = true,
  render = "simple",
  fps = 120,
}

return {
  "rcarriga/nvim-notify",
  opts = opts,
  event = "BufReadPre",
}
