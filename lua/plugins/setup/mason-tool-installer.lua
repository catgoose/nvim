local utils = require("config.utils")
local get_mason_tools = utils.get_mason_tools

utils.plugin_setup("mason-tool-installer", {
	ensure_installed = get_mason_tools(),
	auto_update = true,
	run_on_start = false,
})
