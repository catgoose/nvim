local opts = {
  filetypes = {
    "*",
    ps1 = {
      RGB = false,
      css = false,
      names = false,
    },
    typescript = {
      css = false,
      names = true,
    },
    javascript = {
      css = false,
      names = false,
    },
    json = {
      css = false,
      names = false,
    },
    sh = {
      css = false,
      names = false,
    },
    mason = {
      css = false,
      names = false,
    },
    markdown = {
      names = false,
    },
    help = {
      names = false,
    },
    terminal = {
      names = false,
    },
    lazy = {
      RGB = false,
      css = false,
      names = false,
    },
    dbout = {
      names = false,
    },
    cmp_docs = {
      always_update = true,
    },
    cmp_menu = {
      always_update = true,
    },
    NeogitLogView = {
      names = false,
    },
    NeogitCommitMessage = {
      names = false,
    },
    TelescopeResults = {
      names = false,
      RGB = false,
    },
  },
  user_default_options = {
    RGB = true,
    RRGGBB = true,
    names = true,
    RRGGBBAA = true,
    AARRGGBB = true,
    rgb_fn = true,
    hsl_fn = true,
    css = true,
    css_fn = true,
    mode = "background",
    method = "lsp",
    tailwind = true,
    sass = { enable = true, parsers = { "css" } },
    virtualtext = "■",
  },
  buftypes = { "!prompt", "!popup" },
}

return {
  -- "NvChad/nvim-colorizer.lua",
  "catgoose/nvim-colorizer.lua",
  branch = "tailwind_add_ring_prefixes",
  opts = opts,
  event = "BufReadPre",
  enabled = true,
}
