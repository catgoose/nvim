local opts = {
  auto_enable = true,
  auto_resize_height = true,
  func_map = {
    open = "<cr>",
    openc = "o",
    vsplit = "v",
    split = "s",
    tab = "t",
    tabc = "T",
    stoggledown = "<Tab>",
    stoggleup = "<S-Tab>",
    stogglevm = "<Tab>",
    sclear = "z<Tab>",
    pscrollup = "<C-f>",
    pscrolldown = "<C-b>",
    fzffilter = "zf",
    ptogglemode = "zp",
    filter = "zn",
    filterr = "zr",
    prevfile = "<C-p>",
    nextfile = "<C-n>",
    prevhist = "<",
    nexthist = ">",
  },
}

return {
  "kevinhwang91/nvim-bqf",
  opts = opts,
  ft = "qf",
  dependencies = {
    "junegunn/fzf",
    build = function()
      vim.fn["fzf#install"]()
    end,
  },
  enabled = true,
}
