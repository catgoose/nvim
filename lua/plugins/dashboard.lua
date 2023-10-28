local header = {
	[[]],
	[[]],
	[[]],
	[[]],
	[[]],
	[[╔══╗ ╔╗   ╔═══╗╔═══╗╔╗╔═╗    ╔═══╗╔═══╗╔═══╗╔═══╗╔═══╗╔═╗ ╔╗    ╔═══╗╔════╗╔╗ ╔╗ ╔═══╗ ╔═══╗]],
	[[║╔╗║ ║║   ║╔═╗║║╔═╗║║║║╔╝    ║╔═╗║║╔═╗║║╔═╗║║╔══╝║╔══╝║║╚╗║║    ║╔═╗║║╔╗╔╗║║║ ║║ ║╔══╝ ║╔══╝]],
	[[║╚╝╚╗║║   ║║ ║║║║ ╚╝║╚╝╝     ║╚══╗║║ ╚╝║╚═╝║║╚══╗║╚══╗║╔╗╚╝║    ║╚══╗╚╝║║╚╝║║ ║║ ║╚══╗ ║╚══╗]],
	[[║╔═╗║║║ ╔╗║╚═╝║║║ ╔╗║╔╗║     ╚══╗║║║ ╔╗║╔╗╔╝║╔══╝║╔══╝║║╚╗║║    ╚══╗║  ║║  ║║ ║║ ║╔══╝ ║╔══╝]],
	[[║╚═╝║║╚═╝║║╔═╗║║╚═╝║║║║╚╗    ║╚═╝║║╚═╝║║║║╚╗║╚══╗║╚══╗║║ ║║║    ║╚═╝║ ╔╝╚╗ ║╚═╝║╔╝╚╗  ╔╝╚╗  ]],
	[[╚═══╝╚═══╝╚╝ ╚╝╚═══╝╚╝╚═╝    ╚═══╝╚═══╝╚╝╚═╝╚═══╝╚═══╝╚╝ ╚═╝    ╚═══╝ ╚══╝ ╚═══╝╚══╝  ╚══╝  ]],
	[[]],
	[[]],
	[[]],
	[[]],
	[[]],
	[[]],
}

local opts = {
	theme = "doom",
	hide = {
		statusline = true,
		tabline = true,
		winbar = true,
	},
	config = {
		header = header,
		center = {
			{
				icon = "",
				desc = "Lazy sync / TSUpdate / MasonToolsUpdate",
				key = "s",
				action = "UpdateAndSyncAll",
			},
			{
				icon = "",
				desc = "Lazy sync",
				key = "l",
				action = "Lazy sync",
			},
			{
				icon = "",
				desc = "Find files",
				key = "f",
				action = "Telescope find_files",
			},
			{
				icon = "",
				desc = "Neogit",
				key = "g",
				action = "Neogit",
			},
			{
				icon = "",
				desc = "Mason",
				key = "m",
				action = "Mason",
			},
			{
				icon = "",
				desc = "Telescope",
				key = "t",
				action = "Telescope",
			},
			{
				icon = "",
				desc = "Harpoon",
				key = "h",
				action = "require('harpoon.ui').toggle_quick_menu()",
			},
			{
				icon = "",
				desc = "Restore session",
				key = "r",
				action = "SessionRestore",
			},
			{
				icon = "",
				desc = "Workspaces",
				key = "w",
				action = "Telescope workspaces",
			},
			{
				icon = "",
				desc = "Empty buffer",
				key = "e",
				action = "enew",
			},
			{
				icon = "",
				desc = "Quit",
				key = "q",
				action = "q",
			},
		},
	},
}

local padding = {
	left = 3,
	right = 3,
}
for _, i in ipairs(opts.config.center) do
	i.desc = string.rep(" ", padding.left) .. i.desc .. string.rep(" ", padding.right)
end

return {
	"nvimdev/dashboard-nvim",
	event = "VimEnter",
	opts = opts,
	dependencies = "nvim-tree/nvim-web-devicons",
}
