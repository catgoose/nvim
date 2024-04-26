local opts = {
  panel = {
    enabled = false,
    auto_refresh = true,
    keymap = {
      jump_prev = false,
      jump_next = false,
      accept = false,
      refresh = false,
      open = false,
    },
    layout = {
      position = "bottom",
      ratio = 0.4,
    },
  },
  suggestion = {
    enabled = true,
    -- auto_trigger = false,
    auto_trigger = false,
    debounce = 75,
    keymap = {
      -- accept = "<S-Tab>",
      accept = "<Tab>",
      -- accept_line = "<M-o>",
      accept_line = "<S-Tab>",
      next = "<M-]>",
      prev = "<M-[>",
      -- dismiss = "<C-]>",
      dismiss = "<M-o>",
    },
  },
  filetypes = {
    help = false,
    gitcommit = false,
    prompt = false,
    TelescopePrompt = false,
    DressingInput = false,
    DressingSelect = false,
    harpoon = false,
    neorepl = false,
    lua = true,
    oil = false,
    typescript = true,
    ["dap-repl"] = false,
    sh = function()
      ---@diagnostic disable-next-line: param-type-mismatch
      return not string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), "^%.env.*")
    end,
    ["."] = false,
  },
  copilot_node_command = "node",
  server_opts_overrides = {},
}

return {
  -- "zbirenbaum/copilot.lua",
  "mosheavni/copilot.lua",
  opts = opts,
  cmd = "Copilot",
  event = "InsertEnter",
  enabled = true,
}
