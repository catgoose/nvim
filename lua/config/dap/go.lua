local M = {}

function M.setup(dap)
  local dlvToolPath = vim.fn.exepath("dlv")

  dap.adapters.go = function(callback)
    require("dap-view").open()
    callback({
      type = "executable",
      command = vim.fn.expand("$MASON") .. "/packages/go-debug-adapter/go-debug-adapter",
      executable = {
        command = dlvToolPath,
        args = { "dap", "-l", "${host}:${port}", "--log", "--log-output=dap" },
      },
    })
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

  for _, cfg in pairs(dap.configurations.go) do
    cfg.type = "go"
    cfg.request = "launch"
    cfg.dlvToolPath = dlvToolPath
  end
end

return M
