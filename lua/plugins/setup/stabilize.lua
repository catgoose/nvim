require("config.utils").plugin_setup("stabilize", {
	force = true,
	forcemark = nil,
	ignore = {
		filetype = { "help", "list", "Trouble" },
		buftype = { "terminal", "quickfix", "loclist", "command" },
	},
	nested = nil,
})
