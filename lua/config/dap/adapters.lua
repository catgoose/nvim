local M = {}

local host = "127.0.0.1"
local h = require("config.dap.helpers")

local function get_install_path(package)
  return require("mason-registry").get_package(package):get_install_path()
end

local use_fallback = false

function M.setup(dap)
  dap = dap or require("dap")

  -- Go
  if not dap.adapters.go then
    if not use_fallback then
      require("config.dap.go").setup(dap, host)
    else
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
          name = "Debug main.go test",
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
  end

  -- javascript/typescript
  if not dap.adapters["pwa-chrome"] then
    dap.adapters["pwa-chrome"] = {
      type = "server",
      host = host,
      port = "${port}",
      executable = {
        command = "node",
        args = {
          h.get_install_path("js-debug-adapter") .. "/js-debug/src/dapDebugServer.js",
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
    -- table.insert(dap.configurations[lang], {
    --   type = "pwa-chrome",
    --   request = "launch",
    --   name = "Launch Chrome",
    --   url = string.format("http://%s:4200", "localhost"),
    --   sourceMaps = true,
    --   resolveSourceMapLocations = { "${workspaceFolder}/**", "!**/node_modules/**" },
    --   protocol = "inspector",
    --   port = 9222,
    -- })
    dap.configurations[lang] = {
      -- {
      --   type = "pwa-node",
      --   request = "launch",
      --   name = "Launch file",
      --   program = "${file}",
      --   cwd = "${workspaceFolder}",
      -- },
      -- {
      --   type = "pwa-node",
      --   request = "attach",
      --   name = "Attach",
      --   processId = require("dap.utils").pick_process,
      --   cwd = "${workspaceFolder}",
      -- },
      {
        type = "pwa-chrome",
        request = "launch",
        name = 'Start Chrome with "localhost"',
        url = "http://localhost:4200",
        webRoot = "${workspaceFolder}",
        userDataDir = "${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir",
        sourceMaps = true,
      },
    }
  end

  -- lua
  dap.configurations.lua = {
    {
      type = "nlua",
      request = "attach",
      name = "Neovim lua",
    },
  }
  dap.adapters.nlua = function(callback, config)
    callback({ type = "server", host = config.host or host, port = config.port or 8086 })
  end
end

return M
