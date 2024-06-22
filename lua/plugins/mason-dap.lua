local opts = {
  ensure_installed = {
    "bash",
    "chrome",
    "js",
    "node2",
  },
  automatic_installation = true,
  automatic_setup = true,
}

-- local handlers = function()
-- local dap = require("dap")
-- --  TODO: 2024-06-21 - configure for chrome/js/node
-- dap.configurations.cpp = {
--   {
--     name = "Launch file (cppdbg)",
--     type = "cppdbg",
--     request = "launch",
--     program = function()
--       return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
--     end,
--     cwd = "${workspaceFolder}",
--     stopAtEntry = false,
--   },
--   {
--     name = "Launch file (codelldb)",
--     type = "codelldb",
--     request = "launch",
--     program = function()
--       return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
--     end,
--     cwd = "${workspaceFolder}",
--     stopOnEntry = false,
--   },
-- }
-- dap.configurations.typescript = {
--   {
--     name = "Chrome: Debug",
--     type = "chrome",
--     request = "attach",
--     program = "${file}",
--     cwd = vim.fn.getcwd(),
--     sourceMaps = true,
--     protocol = "inspector",
--     port = 9222,
--     webRoot = "${workspaceFolder}",
--   },
-- }
-- dap.configurations.c = dap.configurations.cpp
-- end

local listeners = function()
  local dap, dapui = require("dap"), require("dapui")
end

--  TODO: 2024-06-22 - can this only be lazy loaded until DAP starts?

return {
  "jay-babu/mason-nvim-dap.nvim",
  opts = opts,
  event = "BufReadPre",
  dependencies = {
    "williamboman/mason.nvim",
    "mfussenegger/nvim-dap",
  },
}
