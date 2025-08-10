local opts = {
  disable_filetype = { "TelescopePrompt" },
}

return {
  "windwp/nvim-autopairs",
  opts = opts,
  event = "InsertEnter",
}
