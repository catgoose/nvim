local M = {}

function M.setup(dap)
  dap = dap or require("dap")
  local function get_install_path(package)
    return require("mason-registry").get_package(package):get_install_path()
  end
  -- Go
  if not dap.adapters.go then
    dap.adapters.go = {
      type = "executable",
      command = "node",
      args = { get_install_path("go-debug-adapter") .. "/extension/dist/debugAdapter.js" },
    }
    -- dlv debug main.go --headless --listen=:2345 --api-version=2 --accept-multiclient
    -- dap.adapters.go = {
    --   type = "server",
    --   host = "127.0.0.1",
    --   port = 2345,
    -- }
    local dlvToolPath = vim.fn.exepath("dlv")
    dap.configurations.go = {
      {
        type = "go",
        name = "Debug main.go",
        request = "launch",
        showLog = true,
        program = "${workspaceFolder}/main.go",
        dlvToolPath = dlvToolPath,
      },
      {
        type = "go",
        name = "Debug current file",
        request = "launch",
        showLog = true,
        program = "${file}",
        dlvToolPath = dlvToolPath,
      },
      -- {
      --   type = "go",
      --   name = "Attach to running process",
      --   request = "attach",
      --   mode = "remote",
      --   pid = "${command:pickProcess}",
      --   host = "127.0.0.1",
      --   port = 2345,
      --   dlvToolPath = dlvToolPath,
      -- },
      {
        type = "go",
        name = "Debug test", -- configuration for debugging test files
        request = "launch",
        showLog = true,
        mode = "test",
        program = "${file}",
        dlvToolPath = dlvToolPath,
      },
      {
        type = "go",
        name = "Debug package",
        request = "launch",
        showLog = true,
        program = "./${relativeFileDirname}",
        dlvToolPath = dlvToolPath,
      },
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
    ---@diagnostic disable-next-line: undefined-field
    callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
  end
end

return M
