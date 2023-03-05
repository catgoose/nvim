local opts = {
	ensure_installed = {
		"bash",
		"chrome",
		"codelldb",
		"cppdbg",
		"js",
		"node2",
		"cpptools",
	},
	automatic_installation = true,
	automatic_setup = true,
}

local handlers = function()
	local dap = require("dap")
	require("mason-nvim-dap").setup_handlers({})
	dap.configurations.cpp = {
		{
			name = "Launch file (cppdbg)",
			type = "cppdbg",
			request = "launch",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			cwd = "${workspaceFolder}",
			stopAtEntry = false,
		},
		{
			name = "Launch file (codelldb)",
			type = "codelldb",
			request = "launch",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			cwd = "${workspaceFolder}",
			stopOnEntry = false,
		},
	}
	dap.configurations.c = dap.configurations.cpp
	dap.configurations.rust = dap.configurations.cpp
end

local listeners = function()
	local dap, dapui = require("dap"), require("dapui")
	dap.listeners.after.event_initialized["dapui_config"] = function()
		dapui.open()
	end
	dap.listeners.before.event_terminated["dapui_config"] = function()
		dapui.close()
	end
	dap.listeners.before.event_exited["dapui_config"] = function()
		dapui.close()
	end
end

return {
	"jay-babu/mason-nvim-dap.nvim",
	config = function()
		require("mason-nvim-dap").setup(opts)
		handlers()
		listeners()
	end,
	event = "BufReadPre",
	dependecies = {
		"williamboman/mason.nvim",
		"mfussenegger/nvim-dap",
	},
}
