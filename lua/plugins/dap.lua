local u = require("util")
local c = u.create_cmd
local m = u.lazy_map

return {
  {
    "mfussenegger/nvim-dap",
    event = "BufReadPre",
    keys = {
      m("<F1>", [[DapStepInto]]),
      m("<F2>", [[DapStepOver]]),
      m("<F3>", [[DapStepOut]]),
      m("<F4>", [[DapStepBack]]),
      m("<F5>", [[DapContinue]]),
      m("<F11>", [[DapRestartFrame]]),
    },
    init = function()
      c("DapClearBreakpoints", require("dap").clear_breakpoints)
      c("DapConditionalBreakpoints", function()
        require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end)
    end,
    cmd = { "DapClearBreakpoints", "DapConditionalBreakpoints" },
    config = function()
      local dap, dapui, mason = require("dap"), require("dapui"), require("mason-registry")
      local function get_install_path(package)
        return mason.get_package(package):get_install_path()
      end

      dap.listeners.before.attach.dapui_config = function()
        vim.cmd("silent! tabnew %")
        dapui.open()
      end
      -- dap.listeners.before.launch.dapui_config = function()
      --   vim.cmd("silent! tabnew %")
      --   dapui.open()
      -- end
      dap.listeners.before.event_terminated.dapui_config = function()
        vim.cmd("silent! tabclose")
        dapui.close()
      end
      -- dap.listeners.before.event_exited.dapui_config = function()
      --   vim.cmd("silent! tabclose")
      --   dapui.close()
      -- end

      -- Go
      if not dap.adapters.go then
        dap.adapters.go = {
          type = "executable",
          command = "node",
          args = { get_install_path("go-debug-adapter") .. "/extension/dist/debugAdapter.js" },
        }
        dap.configurations.go = {
          {
            type = "go",
            name = "Debug",
            request = "launch",
            showLog = true,
            program = "${file}",
            dlvToolPath = vim.fn.exepath("dlv"),
          },
          -- {
          --   type = "go",
          --   name = "Debug",
          --   request = "launch",
          --   program = "${file}",
          --   dlvToolPath = vim.fn.exepath("dlv"),
          -- },
          -- {
          --   type = "delve",
          --   name = "Debug test", -- configuration for debugging test files
          --   request = "launch",
          --   mode = "test",
          --   program = "${file}",
          -- },
          -- -- works with go.mod packages and sub packages
          -- {
          --   type = "delve",
          --   name = "Debug test (go.mod)",
          --   request = "launch",
          --   mode = "test",
          --   program = "./${relativeFileDirname}",
          -- },
        }
      end

      -- javascript/typescript
      if not dap.adapters["pwa-chrome"] then
        dap.adapters["pwa-chrome"] = {
          type = "server",
          host = "127.0.0.1",
          port = "${port}",
          executable = {
            command = "node",
            args = {
              get_install_path("js-debug-adapter") .. "/js-debug/src/dapDebugServer.js",
              "${port}",
            },
          },
        }
      end
      for _, lang in ipairs({
        "typescript",
        "javascript",
      }) do
        dap.configurations[lang] = dap.configurations[lang] or {}
        table.insert(dap.configurations[lang], {
          type = "pwa-chrome",
          request = "launch",
          name = "Launch Chrome",
          url = "http://127.0.0.1:4200",
          sourceMaps = false,
        })
      end

      -- lua
      dap.configurations.lua = {
        {
          type = "nlua",
          request = "attach",
          name = "Attach to running Neovim instance",
        },
      }
      dap.adapters.nlua = function(callback, config)
        callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
      end
      -- TODO: 2025-01-19 - Update this keybinding and only set it in lua files?
      vim.keymap.set("n", "<leader>du", function()
        require("osv").launch({ port = 8086 })
      end, { noremap = true })
    end,
  },
  -- {
  --   "igorlfs/nvim-dap-view",
  --   opts = {},
  --   dependencies = {
  --     "nvim-treesitter/nvim-treesitter",
  --   },
  -- },
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
    "rcarriga/nvim-dap-ui",
    opts = {
      layouts = {
        {
          elements = {
            {
              id = "scopes",
              size = 0.50,
            },
            {
              id = "breakpoints",
              size = 0.25,
            },
            {
              id = "stacks",
              size = 0.25,
            },
            -- {
            --   id = "watches",
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
              size = 0.5,
            },
            {
              id = "console",
              size = 0.5,
            },
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
}
