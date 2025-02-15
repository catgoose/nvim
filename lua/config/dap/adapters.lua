local M = {}

local host = "127.0.0.1"
local h = require("config.dap.helpers")

function M.setup(dap)
  dap = dap or require("dap")

  -- Go
  if not dap.adapters.go then
    require("config.dap.go").setup(dap, host)
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
