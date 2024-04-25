vim.filetype.add({
  extension = {
    env = "env",
    rasi = "sass",
  },
  pattern = {
    [".*%.md%.gpg"] = "markdown",
  },
})
