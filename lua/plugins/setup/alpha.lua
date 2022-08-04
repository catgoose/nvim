local utils = require("config.utils")
local plugin = utils.require_plugin
local updates = utils.plugin_updates

local alpha = plugin("alpha")

local dashboard = require("alpha.themes.dashboard")
dashboard.section.header.val = {
	[[]],
	[[]],
	[[]],
	[[]],
	[[]],
	[[ ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗]],
	[[ ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║]],
	[[ ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║]],
	[[ ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║]],
	[[ ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║]],
	[[ ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝]],
	[[]],
	[[]],
	[[]],
	[[]],
}

dashboard.section.buttons.val = {
	dashboard.button("s", "  Sync plugins", updates),
	dashboard.button("f", "  Find files", [[<cmd>Telescope find_files<cr>]]),
	dashboard.button("r", "  Restore session", [[<cmd>silent! RestoreSession<cr>]]),
	dashboard.button("h", "  Harpoon", [[<cmd>:lua require("harpoon.ui").toggle_quick_menu()<cr>]]),
	dashboard.button("w", "  Workspaces", [[<cmd>Telescope workspaces<cr>]]),
	dashboard.button("t", "  Telescope", [[<cmd>Telescope<cr>]]),
	dashboard.button("z", "  Full screen", [[<cmd>lua require("config.functions").ToggleZenMode()<cr>]]),
	dashboard.button("e", "  Empty buffer", [[<cmd>new<cr>]]),
	dashboard.button("q", "  Quit NVIM", [[<cmd>qa<cr>]]),
}
dashboard.config.opts.noautocmd = true
alpha.setup(dashboard.config)
