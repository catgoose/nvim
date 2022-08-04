require("config.utils").plugin_setup("workspaces", {
		hooks = {
			open = { "Telescope find_files" },
		},
})
