require("config.utils").plugin_setup("focus", {
	width = 145,
	height = 32,
	cursorline = true,
	signcolumn = false,
	number = false,
	bufnew = false,
	autoresize = true,
	winheight = true,
	excluded_buftypes = { "nofile", "prompt", "popup", "quickfix", "packer" },
	compatible_filetrees = { "neo-tree" },
})
