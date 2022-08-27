local illuminate = require("config.utils").require_plugin("illuminate")

illuminate.configure({
	providers = {
		"regex",
	},
	delay = 100,
	filetypes_denylist = {
		"neo-tree",
		"harpoon",
		"help",
	},
	filetypes_allowlist = {},
	modes_denylist = {},
	modes_allowlist = {},
	providers_regex_syntax_denylist = {},
	providers_regex_syntax_allowlist = {},
	under_cursor = true,
})
