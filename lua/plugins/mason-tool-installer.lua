local opts = {
  auto_update = true,
  run_on_start = true,
  ensure_installed = {
    "impl",
    "js-debug-adapter",
    "go-debug-adapter",
    "gomodifytags",
    "iferr",
    "gotests",
    "codespell",
  },
}

return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  opts = opts,
  cmd = "MasonToolsUpdate",
  event = "BufReadPre",
  dependencies = "williamboman/mason.nvim",
}
