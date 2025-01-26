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
      m("<F11>", [[DapClearBreakpoints]]),
      m("<F12>", [[DapDisconnect]]),
    },
    init = function()
      local dap = require("dap")
      require("config.dap.keymaps").setup(dap)
    end,
    cmd = {
      "DapContinue",
      "DapClearBreakpoints",
      "DapConditionalBreakpoints",
    },
    config = function()
      local dap = require("dap")
      require("config.dap.adapters").setup(dap)
    end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    config = true,
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-treesitter/nvim-treesitter",
    },
    event = "BufReadPre",
  },
  {
    "ofirgall/goto-breakpoints.nvim",
    event = "BufReadPre",
    keys = {
      m("]r", [[lua require('goto-breakpoints').next()]]),
      m("[r", [[lua require('goto-breakpoints').prev()]]),
    },
    dependencies = "mfussenegger/nvim-dap",
  },
  {
    "Weissle/persistent-breakpoints.nvim",
    event = "BufReadPre",
    opts = {
      load_breakpoints_event = { "BufReadPost" },
    },
    keys = {
      m("<leader>/", [[lua require('persistent-breakpoints.api').toggle_breakpoint()]]),
    },
    dependencies = "mfussenegger/nvim-dap",
  },
  "jbyuki/one-small-step-for-vimkind",
  {
    -- "igorlfs/nvim-dap-view",
    dir = "~/git/nvim-dap-view",
    opts = {
      winbar = {
        show = true,
        sections = { "watches", "breakpoints", "repl" },
        -- Must be one of the sections declared above
        default_section = "repl",
      },
      windows = {
        height = 12,
        terminal = {
          position = "right",
        },
      },
    },
    enabled = true,
    init = function()
      local dap = require("dap")
      dap.listeners.before.launch["dap-view-custom"] = function()
        require("dap-view").open()
      end
      dap.listeners.before.attach["dap-view-custom"] = function()
        require("dap-view").open()
      end
      dap.listeners.before.event_exited["dap-view-custom"] = function()
        require("dap-view").close()
      end
    end,
    dependencies = "mfussenegger/nvim-dap",
    event = "BufReadPre",
    cmd = {
      "DapViewOpen",
      "DapViewClose",
      "DapViewToggle",
      "DapViewWatch",
    },
    keys = {
      m("<leader>?", [[lua require("dap-view").toggle()]]),
    },
  },
}
