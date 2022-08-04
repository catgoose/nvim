require("config.utils").plugin_setup("kanagawa", {
	undercurl = true,
	commentStyle = {
		italic = true,
	},
	functionStyle = {},
	keywordStyle = {
		italic = true,
	},
	statementStyle = {
		bold = true,
	},
	typeStyle = {},
	variablebuiltinStyle = {
		italic = true,
	},
	specialReturn = true,
	specialException = true,
	transparent = false,
	dimInactive = true,
	globalStatus = true,
	terminalColors = true,
	colors = {},
	overrides = {},
})

vim.cmd.colorscheme("kanagawa")
