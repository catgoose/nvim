require("config.utils").plugin_setup("winshift", {
	highlight_moving_win = true,
	focused_hl_group = "Visual",
	moving_win_options = {
		wrap = false,
		cursorline = false,
		cursorcolumn = false,
		colorcolumn = "",
	},
	picker_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
	filter_rules = {
		cur_win = true,
		floats = true,
		buftype = {
			"terminal",
		},
		bufname = {},
	},
})
