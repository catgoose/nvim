return {
	"glepnir/lspsaga.nvim",
	event = "BufRead",
	config = function()
		require("lspsaga").setup({
			lightbulb = {
				enable = false,
				enable_in_insert = true,
				sign = true,
				sign_priority = 40,
				virtual_text = true,
			},
			symbol_in_winbar = {
				enable = false,
				separator = " ",
				ignore_patterns = {},
				hide_keyword = true,
				show_file = true,
				folder_level = 2,
				respect_root = false,
				color_mode = true,
			},
		})
	end,
	dependencies = {
		{ "kyazdani42/nvim-web-devicons" },
		{ "nvim-treesitter/nvim-treesitter" },
	},
}
