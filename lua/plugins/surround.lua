local opts = {
  aliases = {
    ["a"] = "<",
    ["b"] = "(",
    ["B"] = "{",
    ["r"] = "[",
    ["q"] = { '"', "'", "`" },
    ["s"] = { "{", "[", "(", "<", '"', "'", "`" },
  },
  highlight = {
    duration = 500,
  },
}

return {
  "kylechui/nvim-surround",
  opts = opts,
  event = "InsertEnter",
  version = "*",
  lazy = true,
}
