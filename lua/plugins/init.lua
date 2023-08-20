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
		"MaximilianLloyd/lazy-reload.nvim",
		config = true,
		lazy = true,
		keys = {
			{ "<leader>rl", "<cmd>lua require('lazy-reload').feed()<cr>" },
		},
	},
	--  TODO: 2023-08-20 - configure this
	-- refer to: https://github.com/lewis6991/hover.nvim/issues/34
	-- {
	-- 	"lewis6991/hover.nvim",
	-- 	lazy = false,
	-- 	config = function()
	-- 		require("hover").setup({
	-- 			init = function()
	-- 				require("hover.providers.lsp")
	-- 			end,
	-- 			preview_opts = {
	-- 				preview_window = false,
	-- 				title = true,
	-- 			},
	-- 		})
	-- 		vim.keymap.set("n", "K", require("hover").hover, { desc = "hover.nvim" })
	-- 		-- vim.keymap.set("n", "gK", require("hover").hover_select, { desc = "hover.nvim (select)" })
	-- 	end,
	-- },
}
