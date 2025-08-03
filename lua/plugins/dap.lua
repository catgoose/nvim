local u = require("util")
local m = u.lazy_map

return {
  {
    "mfussenegger/nvim-dap",
    keys = {
      m("<F1>", [[DapStepInto]]),
      m("<F2>", [[DapStepOver]]),
      m("<F3>", [[DapStepOut]]),
      m("<F4>", [[DapStepBack]]),
      m("<F5>", [[DapContinue]]),
      ---
      m("<F8>", [[DapStepInto]]),
      m("<F9>", [[DapStepOver]]),
      m("<F10>", [[DapStepOut]]),
      ---
      m("<F12>", [[DapDisconnect]]),
    },
    cmd = { "DapContinue" },
    config = function()
      local dap = require("dap")
      require("config.dap.keymaps").setup(dap)
      require("config.dap.adapters").setup(dap)
    end,
    ft = { "go", "javascript", "typescript", "bash", "lua" },
    dependencies = {
      "theHamsta/nvim-dap-virtual-text",
      "jay-babu/mason-nvim-dap.nvim",
      "ofirgall/goto-breakpoints.nvim",
      "Weissle/persistent-breakpoints.nvim",
      "jbyuki/one-small-step-for-vimkind",
    },
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = {
      ensure_installed = {
        "bash",
        "delve",
        "js",
      },
      automatic_installation = true,
      automatic_setup = true,
    },
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    config = true,
  },
  {
    "ofirgall/goto-breakpoints.nvim",
    event = "BufReadPost",
    keys = {
      m("]r", [[lua require('goto-breakpoints').next()]]),
      m("[r", [[lua require('goto-breakpoints').prev()]]),
    },
  },
  {
    "Weissle/persistent-breakpoints.nvim",
    opts = {
      load_breakpoints_event = { "BufReadPost" },
    },
    keys = {
      m("<leader>/", [[lua require('persistent-breakpoints.api').toggle_breakpoint()]]),
      m("<F11>", [[lua require('persistent-breakpoints.api').clear_all_breakpoints()]]),
    },
  },
  {
    "igorlfs/nvim-dap-view",
    opts = {
      winbar = {
        show = true,
        sections = {
          "watches",
          "scopes",
          "breakpoints",
          "threads",
          "repl",
        },
        default_section = "breakpoints",
      },
      windows = {
        height = 12,
        terminal = {
          position = "right",
        },
      },
      help = {
        border = "rounded",
      },
    },
    cmd = {
      "DapViewOpen",
      "DapViewClose",
      "DapViewToggle",
      "DapViewWatch",
    },
    keys = {
      m("<leader>?", [[lua require("dap-view").toggle(true)]]),
    },
  },
}
