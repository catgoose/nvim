local u = require("util")
local c = u.create_cmd
local m = u.lazy_map

return {
  {
    "mfussenegger/nvim-dap",
    event = "BufReadPre",
    keys = {
      m("<F1>", [[DapContinue]]),
      m("<F2>", [[DapStepInto]]),
      m("<F3>", [[DapStepOver]]),
      m("<F4>", [[DapStepOut]]),
      m("<F5>", [[DapStepBack]]),
      m("<F7>", [[DapRestartFrame]]),
      m("<leader>/", [[DapToggleBreakpoint]]),
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

      dap.listeners.after.event_initialized["dapui_config"] = function()
        vim.cmd("silent! tabnew %")
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        vim.cmd("silent! tabclose")
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        vim.cmd("silent! tabclose")
        dapui.close()
      end

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
            showLog = false,
            program = "${file}",
            dlvToolPath = vim.fn.exepath("dlv"),
          },
        }
      end
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
    "rcarriga/nvim-dap-ui",
    config = true,
    keys = {
      m("<leader>?", [[lua require("dapui").toggle()]]),
    },
    dependencies = {
      "mfussenegger/nvim-dap",
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
    "leoluz/nvim-dap-go",
    opts = {
      dap_configurations = {
        {
          -- Must be "go" or it will be ignored by the plugin
          type = "go",
          name = "Attach remote",
          mode = "remote",
          request = "attach",
        },
      },
    },
    dependencies = "mfussenegger/nvim-dap",
    enabled = false,
  },
}
