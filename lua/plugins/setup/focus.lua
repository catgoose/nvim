require("config.utils").plugin_setup("focus", {
	width = 145,
	height = 32,
	cursorline = false,
	signcolumn = false,
	number = false,
	bufnew = false,
	autoresize = false,
	winheight = true,
	excluded_buftypes = { "nofile", "prompt", "popup", "quickfix", "packer", "help" },
	excluded_filetypes = { "harpoon" },
	compatible_filetrees = { "neo-tree" },
})
