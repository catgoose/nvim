local utils = require("config.utils")
local get_mason_tools = utils.get_mason_tools

utils.plugin_setup("mason", {
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})

utils.plugin_setup("mason-lspconfig", {
	ensure_installed = get_mason_tools(),
	automatic_installation = true,
})
