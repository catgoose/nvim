local opts = {
  opts = {
    enable_close = true,
    enable_rename = true,
    enable_close_on_slash = true,
  },
  aliases = {
    ["vue"] = "html",
    ["templ"] = "html",
  },
}

return {
  "windwp/nvim-ts-autotag",
  opts = opts,
  event = "BufReadPre",
}
