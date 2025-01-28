local M = {}
local h = require("config.dap.helpers")

-- -- split
-- dap.adapters.go = function(callback, config)
--   local port = 38697
--   local term_buf = vim.api.nvim_create_buf(false, true)
--   vim.api.nvim_command("split")
--   vim.api.nvim_set_current_buf(term_buf)
--   vim.fn.jobstart({ "dlv", "dap", "-l", string.format("%s:%d", host, port) }, { term = true })
--   vim.defer_fn(function()
--     callback({ type = "server", host = host, port = port })
--   end, 100)
-- end

function M.setup(dap, host)
  dap = dap or require("dap")
  host = host or "127.0.0.1"
  dap.adapters.go = function(callback, config)
    local port = config.port or h.get_unused_port(host)
    if not port then
      print("No available port found for dap adapter")
      return
    end
    local bufnr, winnr = h.get_dap_view_window()
    if not (bufnr and winnr) then
      bufnr, winnr = h.create_manual_window()
    end
    if not (bufnr and winnr) then
      print("Failed to create manual window for dap adapter")
      return
    end
    local current_winnr = vim.api.nvim_get_current_win()
    vim.api.nvim_set_current_win(winnr)
    -- reset buffer so a new job can start
    h.reset_buffer(bufnr)
    vim.fn.jobstart({ "dlv", "dap", "-l", string.format("%s:%d", host, port) }, {
      term = true,
    })
    -- end
    vim.api.nvim_set_current_win(current_winnr)
    vim.defer_fn(function()
      callback({ type = "server", host = host, port = port })
    end, 100)
  end
  -- dap.defaults.go.switchbuf = "useopen"

  dap.configurations.go = {
    {
      name = "Debug main.go",
      program = "${workspaceFolder}/main.go",
    },
    {
      name = "Debug current file",
      program = "${file}",
    },
    {
      name = "Debug test",
      mode = "test",
      program = "${file}",
    },
    {
      name = "Debug package",
      program = "./${relativeFileDirname}",
    },
  }

  local dlvToolPath = h.get_install_path("delve")
  for _, cfg in pairs(dap.configurations.go) do
    cfg.type = "go"
    cfg.request = "launch"
    cfg.showLog = true
    cfg.dlvToolPath = dlvToolPath
  end
end

return M
