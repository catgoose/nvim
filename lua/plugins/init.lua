local m = require("util").lazy_map

return {
	{
		"jamessan/vim-gnupg",
		lazy = false,
		ft = "markdown",
	},
	{
		"litao91/lsp_lines",
		priority = 900,
		config = true,
	},
	{
		"axelvc/template-string.nvim",
		config = true,
		event = "BufReadPre",
	},
	{
		"chentoast/marks.nvim",
		config = true,
		event = "BufReadPre",
	},
	{
		"wakatime/vim-wakatime",
		event = "BufReadPre",
	},
	{
		"lambdalisue/suda.vim",
		event = "BufReadPre",
	},
	{
		"romainl/vim-cool",
		event = "BufReadPre",
	},
	{
		"famiu/bufdelete.nvim",
		dependencies = "schickling/vim-bufonly",
		cmd = { "BufOnly", "Bdelete" },
	},
	{
		"nvim-treesitter/playground",
		cmd = "TSPlaygroundToggle",
		keys = {
			m("<leader>tp", [[TSPlaygroundToggle]]),
		},
	},
	{
		"theHamsta/nvim-dap-virtual-text",
		config = true,
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-treesitter/nvim-treesitter",
		},
		event = "BufReadPre",
	},
	{
		"ofirgall/goto-breakpoints.nvim",
		event = "BufReadPre",
		keys = {
			m("]r", [[lua require('goto-breakpoints').next()]]),
			m("[r", [[lua require('goto-breakpoints').prev()]]),
		},
		dependecies = "mfussenegger/nvim-dap",
	},
	{
		"ellisonleao/glow.nvim",
		config = true,
		cmd = "Glow",
		filetypes = { "markdown" },
	},
}
