return {
  "kevinhwang91/nvim-fundo",
  dependencies = "kevinhwang91/promise-async",
  build = function()
    require("fundo").install()
  end,
  event = "BufReadPre",
  config = true,
}
