local leap = require("config.utils").require_plugin("leap")

leap.setup({
	highlight_ahead_of_time = true,
	highlight_unlabeled = false,
	case_sensitive = false,
	special_keys = {
		repeat_search = "<enter>",
		next_match = "<enter>",
		prev_match = "<tab>",
		next_group = "<space>",
		prev_group = "<tab>",
		eol = "<space>",
	},
})
leap.set_default_keymaps()
