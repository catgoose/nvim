local m = require("util").lazy_map

return {
	{
		"dstein64/vim-startuptime",
		lazy = false,
	},
	{
		"jamessan/vim-gnupg",
		lazy = false,
		ft = "markdown",
	},
	{
		"litao91/lsp_lines",
		priority = 900,
		config = true,
		enabled = true,
	},
	{
		"axelvc/template-string.nvim",
		opts = {
			filetypes = { "html", "typescript", "javascript", "typescriptreact", "javascriptreact", "python", "vue" },
		},
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
		"lukas-reineke/virt-column.nvim",
		config = true,
		event = "BufReadPre",
		ft = { "markdown" },
	},
	{
		"ellisonleao/glow.nvim",
		config = true,
		cmd = "Glow",
		ft = { "markdown" },
	},
	{
		"folke/neodev.nvim",
		config = true,
		lazy = true,
	},
	{
		"folke/neoconf.nvim",
		lazy = true,
	},
	{
		"MaximilianLloyd/tw-values.nvim",
		config = true,
		lazy = true,
		ft = { "typescript", "typescriptreact", "vue", "html", "svelt", "astro" },
	},
	{
		"tpope/vim-fugitive",
		cmd = { "Git" },
		keys = {
			m("<leader>gi", "Git"),
		},
	},
}
