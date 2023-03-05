local m = require("util").lazy_map
local cmd = vim.cmd

local opts = {
	autoresize = false,
	excluded_buftypes = { "nofile", "prompt", "popup", "quickfix" },
	excluded_filetypes = { "harpoon" },
	compatible_filetrees = { "neo-tree" },
	quickfixheight = 60,
}

return {
	"beauwilliams/focus.nvim",
	opts = opts,
	cmd = {
		"FocusSplitDown",
		"FocusSplitRight",
		"FocusMaximise",
		"FocusEqualise",
		"FocusToggle",
	},
	keys = {
		m("<leader>ss", [[FocusSplitDown]]),
		m("<leader>sv", [[FocusSplitRight]]),
		m("<leader>sm", [[FocusMaximise]]),
		m("<leader>se", [[FocusEqualise]]),
		m("<leader>st", [[FocusToggle]]),
		{
			"<leader>tv",
			function()
				cmd.FocusSplitRight()
				cmd.terminal()
			end,
		},
		{
			"<leader>ts",
			function()
				cmd.FocusSplitDown()
				cmd.terminal()
			end,
		},
	},
}
