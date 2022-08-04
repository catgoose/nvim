require("config.utils").plugin_setup("yanky", {
	ring = {
		history_length = 100,
		storage = "shada",
		sync_with_numbered_registers = true,
	},
	system_clipboard = {
		sync_with_ring = true,
	},
	highlight = {
		on_put = true,
		on_yank = true,
		timer = 500,
	},
	preserve_cursor_position = {
		enabled = true,
	},
})
