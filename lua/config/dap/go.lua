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

local use_executable = false

function M.setup(dap, host)
  if use_executable then
    dap.adapters.go = {
      type = "executable",
      command = "node",
      args = { h.get_install_path("go-debug-adapter") .. "/extension/dist/debugAdapter.js" },
    }
  else
    dap = dap or require("dap")
    host = host or "127.0.0.1"
    dap.adapters.go = function(callback, config)
      local port = config.port or h.get_unused_port(host)
      if not port then
        vim.notify("No available port found for dap adapter")
        return
      end
      local bufnr = h.get_dap_view_window()
      if not bufnr then
        bufnr = h.create_manual_window()
      end
      if not bufnr then
        vim.notify("Failed to create manual window for dap adapter")
        return
      end
      vim.api.nvim_buf_call(bufnr, function()
        h.reset_buffer(bufnr)
        local cmd = { "dlv", "dap", "-l", ("%s:%d"):format(host, port) }
        vim.g.catgoose_terminal_enable_startinsert = 0
        local jobid = vim.fn.jobstart(cmd, {
          term = true,
        })
        vim.g.catgoose_terminal_enable_startinsert = 1
        if jobid == 0 then
        elseif jobid == -1 then
          vim.notify(("Cmd `%s` is not executable"):format(cmd[1]), vim.log.levels.ERROR)
          return
        end
        vim.cmd("normal! G") -- tail the output without having to startinsert
        local augroup = vim.api.nvim_create_augroup("nvim-dap-view-term", { clear = true })
        vim.api.nvim_create_autocmd({ "winnew" }, { -- required to tail output on first window open
          group = augroup,
          callback = function(evt)
            if evt.buf == bufnr then
              local code_term_esc = vim.api.nvim_replace_termcodes("<c-\\><c-n>", true, true, true)
              vim.keymap.set("t", "<esc>", function()
                vim.api.nvim_feedkeys(code_term_esc, "t", true)
              end, { noremap = true, buffer = evt.buf })
              vim.schedule(function()
                vim.api.nvim_buf_call(bufnr, function()
                  vim.cmd("normal! G")
                end)
              end)
              vim.api.nvim_create_augroup("nvim-dap-view-term", { clear = true })
            end
          end,
        })
      end)
      vim.schedule(function()
        callback({ type = "server", host = host, port = port })
      end)
    end
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
