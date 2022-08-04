require("config.utils").plugin_setup("octo", {
	default_remote = { "upstream", "origin" },
	ssh_aliases = {
		["github.com-dsld"] = "github.com",
	},
	reaction_viewer_hint_icon = "",
	user_icon = " ",
	timeline_marker = "",
	timeline_indent = "2",
	right_bubble_delimiter = "",
	left_bubble_delimiter = "",
	github_hostname = "",
	snippet_context_lines = 4,
	file_panel = {
		size = 10,
		use_icons = true,
	},
})
