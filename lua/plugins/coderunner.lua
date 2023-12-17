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
		typescript = {
			{ "ts-node", "[#file]" },
		},
	},
}

local cr_str = [[lua require("coderunner").run]]

local plugin = {
	opts = opts,
	keys = {
		-- m("<leader>z", [[Lazy reload coderunner]]),
		-- m("<leader>cc", cr_str .. [[({split = "horizontal"})]]),
		-- m("<leader>cv", cr_str .. [[({split = "vertical"})]]),
	},
	cmd = {
		"Coderunner",
		"CoderunnerHorizontal",
		"CoderunnerVertical",
	},
}

if dev == true then
	return e("keep", plugin, {
		dir = "~/git/coderunner.nvim",
		lazy = false,
	})
else
	return e("keep", plugin, {
		"catgoose/coderunner.nvim",
		config = true,
		event = "BufReadPre",
	})
end
