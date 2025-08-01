local opts = {
  quiet_mode = true,
}

return {
  "rshkarin/mason-nvim-lint",
  opts = opts,
  event = "BufReadPre",
  dependencies = {
    "williamboman/mason.nvim",
    "mfussenegger/nvim-lint",
  },
}
