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
      vim.notify("No available port found for dap adapter")
      return
    end
    local bufnr, winnr = h.get_dap_view_window()
    if not (bufnr and winnr) then
      bufnr, winnr = h.create_manual_window()
    end
    if not (bufnr and winnr) then
      vim.notify("Failed to create manual window for dap adapter")
      return
    end
    vim.api.nvim_buf_call(bufnr, function()
      h.reset_buffer(bufnr) -- reset buffer so a new job can start
      local cmd = { "dlv", "dap", "-l", ("%s:%d"):format(host, port) }
      local jobid = vim.fn.jobstart(cmd, {
        term = true,
      })
      if jobid == 0 then
        vim.notify("Invalid arguments", vim.log.levels.ERROR)
        return
      elseif jobid == -1 then
        vim.notify(("Cmd `%s` is not executable"):format(cmd[1]), vim.log.levels.ERROR)
        return
      end
      vim.cmd("normal! G") -- tail the output without having to startinsert
    end)
    vim.schedule(function()
      callback({ type = "server", host = host, port = port })
    end)
  end

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
    cfg.dlvToolPath = dlvToolPath
  end
end

return M
