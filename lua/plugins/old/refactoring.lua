local m = require("util").lazy_map

local opts = {
	prompt_func_return_type = {
		go = false,
		java = false,
		cpp = false,
		c = false,
		h = false,
		hpp = false,
		cxx = false,
	},
	prompt_func_param_type = {
		go = false,
		java = false,
		cpp = false,
		c = false,
		h = false,
		hpp = false,
		cxx = false,
	},
	printf_statements = {},
	print_var_statements = {},
}

return {
	"ThePrimeagen/refactoring.nvim",
	opts = opts,
	keys = {
		m("<leader>rv", [[Refactor extract_var]], { "n", "x" }),
		m("<leader>ri", [[Refactor inline_var]], { "n", "x" }),
		m("<leader>rI", [[Refactor inline_func]], { "n", "x" }),
		m("<leader>rt", function()
			require("telescope").extensions.refactoring.refactors()
		end, { "n", "x" }),
		m("<leader>rb", function()
			require("refactoring").refactor("Extract Block")
		end, { "n", "x" }),
		m("<leader>rf", function()
			require("refactoring").refactor("Extract Function")
		end, { "n", "x" }),
	},
	event = "BufReadPre",
}
