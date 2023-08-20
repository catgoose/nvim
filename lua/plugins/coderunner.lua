local dev = false
local e = vim.tbl_extend
local m = require("util").lazy_map

local opts = {
	dev = dev,
	langs = {
		cpp = {
			{ "clear" },
			{ "compiledb make", { "[#ask]", "compiledb args" } },
			{ { "[#ask]", "Command to run after make" } },
		},
		cs = {
			{ "clear" },
			{ "dotnet run" },
		},
	},
}

local cr_str = [[lua require("coderunner").run]]

local plugin = {
	opts = opts,
	keys = {
		m("<leader>cc", cr_str .. [[({split = "horizontal"})]]),
		m("<leader>cv", cr_str .. [[({split = "vertical"})]]),
	},
}

if dev == true then
	return e("keep", plugin, {
		dir = "~/git/coderunner.nvim",
		dev = true,
		lazy = false,
	})
else
	return e("keep", plugin, {
		"catgoose/coderunner.nvim",
		config = true,
		event = "BufReadPre",
	})
end
