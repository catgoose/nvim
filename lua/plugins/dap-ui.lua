local m = require("util").lazy_map

return {
  "rcarriga/nvim-dap-ui",
  opts = {
    floating = {
      border = "rounded",
    },
    layouts = {
      {
        elements = {
          {
            id = "scopes",
            size = 0.75,
          },
          {
            id = "breakpoints",
            size = 0.25,
          },
          -- {
          --   id = "stacks",
          --   size = 0.25,
          -- },
        },
        position = "left",
        size = 40,
      },
      {
        elements = {
          {
            id = "repl",
            size = 0.75,
          },
          -- {
          --   id = "console",
          --   size = 0.25,
          -- },
          -- {
          --   id = "watches",
          --   size = 0.25,
          -- },
        },
        position = "bottom",
        size = 10,
      },
    },
  },
  keys = {
    m("<leader>?", [[lua require("dapui").toggle()]]),
  },
  dependencies = {
    "mfussenegger/nvim-dap",
    "nvim-neotest/nvim-nio",
  },
  enabled = false,
}
