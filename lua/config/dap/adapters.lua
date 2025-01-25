local M = {}

function M.setup(dap)
  dap = dap or require("dap")
  local function get_install_path(package)
    return require("mason-registry").get_package(package):get_install_path()
  end
  -- Go

  -- -- split
  -- dap.adapters.go = function(callback, config)
  --   local port = 38697
  --   local term_buf = vim.api.nvim_create_buf(false, true)
  --   vim.api.nvim_command("split")
  --   vim.api.nvim_command("buffer " .. term_buf)
  --   vim.fn.jobstart({ "dlv", "dap", "-l", "127.0.0.1:" .. port }, { term = true })
  --   vim.defer_fn(function()
  --     callback({ type = "server", host = "127.0.0.1", port = port })
  --   end, 100)
  -- end

  if not dap.adapters.go then
    local function get_unused_port()
      local server = vim.uv.new_tcp()
      assert(server:bind("127.0.0.1", 0)) -- OS allocates an unused port
      local tcp_t = server:getsockname()
      server:close()
      assert(tcp_t and tcp_t.port > 0, "Failed to get an unused port")
      return tcp_t.port
    end
    dap.adapters.go = function(callback, config)
      get_unused_port()
      local port = config.port or get_unused_port()
      if not port then
        print("No available port found for dap adapter")
        return
      end
      local state = require("dap-view.state")
      local bufnr = state.term_bufnr
      local winnr = state.term_winnr
      if not bufnr or not winnr then
        require("dap-view").open()
        bufnr = state.term_bufnr
        winnr = state.term_winnr
        -- dap-view not available, create window manually
        if not bufnr or not winnr then
          bufnr = vim.api.nvim_create_buf(true, false)
          winnr = vim.api.nvim_open_win(bufnr, false, {
            split = "below",
            win = -1,
            height = 12,
          })
        end
      end
      -- job start runs in current window.  Is there a way to start it in target
      -- window without switching?
      local current_winnr = vim.api.nvim_get_current_win()
      vim.api.nvim_set_current_win(winnr)
      vim.fn.jobstart({ "dlv", "dap", "-l", string.format("127.0.0.1:%d", port) }, {
        term = true,
      })
      vim.api.nvim_set_current_win(current_winnr)
      vim.defer_fn(function()
        callback({ type = "server", host = "127.0.0.1", port = port })
      end, 100)
    end

    dap.configurations.go = {
      {
        type = "go",
        name = "Debug main.go",
        request = "launch",
        showLog = true,
        program = "${workspaceFolder}/main.go",
      },
      {
        type = "go",
        name = "Debug current file",
        request = "launch",
        showLog = true,
        program = "${file}",
      },
      {
        type = "go",
        name = "Debug test", -- configuration for debugging test files
        request = "launch",
        showLog = true,
        mode = "test",
        program = "${file}",
      },
      {
        type = "go",
        name = "Debug package",
        request = "launch",
        showLog = true,
        program = "./${relativeFileDirname}",
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
