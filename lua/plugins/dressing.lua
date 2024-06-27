local opts = {
  input = {
    enabled = true,
    default_prompt = "Input:",
    title_pos = "center",
    insert_only = false,
    start_in_insert = false,
    prefer_width = 60,
    width = nil,
    max_width = { 140, 0.9 },
    min_width = { 20, 0.2 },
    buf_options = {},
    win_options = {
      winhighlight = "",
      winblend = 0,
      wrap = false,
    },
    mappings = {
      n = {
        ["<Esc>"] = "Close",
        ["<CR>"] = "Confirm",
      },
      i = {
        ["<C-c>"] = "Close",
        ["<CR>"] = "Confirm",
        ["<Up>"] = "HistoryPrev",
        ["<Down>"] = "HistoryNext",
      },
    },
    override = function(conf)
      return conf
    end,
    get_config = nil,
  },
  select = {
    enabled = true,
    backend = { "telescope", "fzf_lua", "fzf", "builtin", "nui" },
    trim_prompt = true,
    telescope = nil,
    fzf = {
      window = {
        width = 0.5,
        height = 0.4,
      },
    },
    fzf_lua = {
      winopts = {
        width = 0.5,
        height = 0.4,
      },
    },
    nui = {
      position = "50%",
      size = nil,
      relative = "editor",
      border = {
        style = "rounded",
      },
      buf_options = {
        swapfile = false,
        filetype = "DressingSelect",
      },
      win_options = {
        --
        winblend = 2,
      },
      max_width = 80,
      max_height = 40,
      min_width = 40,
      min_height = 10,
    },
    builtin = {
      border = "rounded",
      relative = "editor",
      win_options = {
        winblend = 2,
        winhighlight = "",
      },
      width = nil,
      max_width = { 140, 0.8 },
      min_width = { 40, 0.2 },
      height = nil,
      max_height = 0.9,
      min_height = { 10, 0.2 },
      mappings = {
        ["<Esc>"] = "Close",
        ["<C-c>"] = "Close",
        ["<CR>"] = "Confirm",
      },
      override = function(conf)
        return conf
      end,
    },
    format_item_override = {},
    get_config = nil,
  },
}

return {
  "stevearc/dressing.nvim",
  opts = opts,
  event = "BufReadPre",
  enabled = true,
}
