require("config.utils").plugin_setup("harpoon", {
	menu = {
		width = vim.api.nvim_win_get_width(0) - 10,
		height = vim.api.nvim_win_get_height(0) - 10,
	},
	save_on_toggle = true,
	save_on_change = true,
	enter_on_sendcmd = false,
	tmux_autoclose_windows = false,
	excluded_filetypes = { "harpoon" },
	mark_branch = true,
})
