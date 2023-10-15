local opts = {
	edit_with_instructions = {
		diff = false,
		keymaps = {
			close = "<C-c>",
			accept = "<C-y>",
			toggle_diff = "<C-d>",
			toggle_settings = "<C-i>",
			cycle_windows = "<Tab>",
			use_output_as_input = "<C-o>",
		},
	},
}
return {
	"jackMort/ChatGPT.nvim",
	event = "VeryLazy",
	opts = opts,
	dependencies = {
		"MunifTanjim/nui.nvim",
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	},
	enabled = false,
}
