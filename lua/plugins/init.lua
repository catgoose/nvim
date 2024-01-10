local m = require("util").lazy_map
local leet_arg = "leetcode.nvim"

return {
	{
		"dstein64/vim-startuptime",
		lazy = false,
	},
	{
		"litao91/lsp_lines",
		priority = 900,
		config = true,
		-- enabled = true,
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
	{
		"zeioth/garbage-day.nvim",
		dependencies = "neovim/nvim-lspconfig",
		event = "VeryLazy",
		config = true,
	},
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		opts = {},
	},
	{
		"ariel-frischer/bmessages.nvim",
		event = "CmdlineEnter",
		config = true,
	},
	{
		"3rd/image.nvim",
		event = "VeryLazy",
		enabled = false,
		opts = {
			-- backend = "kitty",
			tmux_show_only_in_active_window = true,
			-- kitty_method = "normal",
			integrations = {
				markdown = {
					enabled = true,
					clear_in_insert_mode = false,
					download_remote_images = true,
					only_render_image_at_cursor = false,
					filetypes = { "markdown", "vimwiki" },
				},
			},
		},
	},
}
