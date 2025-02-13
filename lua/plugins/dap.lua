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
    init = function()
      local dap = require("dap")
      require("config.dap.keymaps").setup(dap)
    end,
    cmd = { "DapContinue" },
    config = function()
      local dap = require("dap")
      require("config.dap.adapters").setup(dap)
      dap.defaults.go.autostart = "Debug main.go"
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
    enabled = true,
  },
  {
    "Weissle/persistent-breakpoints.nvim",
    event = "BufReadPre",
    opts = {
      load_breakpoints_event = { "BufReadPost" },
    },
    keys = {
      m("<leader>/", [[lua require('persistent-breakpoints.api').toggle_breakpoint()]]),
      m("<F11>", [[lua require('persistent-breakpoints.api').clear_all_breakpoints()]]),
    },
    dependencies = "mfussenegger/nvim-dap",
  },
  {
    "igorlfs/nvim-dap-view",
    commit = "7d75930dc7203eef924079df75c2393f4d3180d9",
    -- dir = "~/git/nvim-dap-view",
    opts = {
      winbar = {
        show = true,
        sections = { "watches", "breakpoints", "repl" },
        default_section = "breakpoints",
      },
      windows = {
        height = 12,
        -- terminal = {
        --   position = "right",
        --   hide = {},
        -- },
      },
    },
    enabled = true,
    init = function()
      -- local dap = require("dap")
      -- dap.listeners.before.launch["catgoose_dap"] = function()
      --   require("dap-view").open()
      -- end
      -- dap.listeners.before.attach["catgoose_dap"] = function()
      --   require("dap-view").open()
      -- end
      -- dap.listeners.after.event_exited["catgoose_dap"] = function()
      --   require("dap-view").close()
      -- end
      -- dap.listeners.after.event_terminated["catgoose_dap"] = function()
      --   require("dap-view").close()
      -- end
      -- dap.defaults.fallback.switchbuf = "useopen"
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
  "jbyuki/one-small-step-for-vimkind",
}
