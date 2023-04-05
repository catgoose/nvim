local m = require("util").lazy_map
local palette = require("kanagawa.colors").setup({ theme = "wave" }).palette

local opts = {
	buffers = {
		colors = {
			background = palette.sumiInk0,
			text = palette.sumiInk0,
		},
	},
}

return {
	"shortcuts/no-neck-pain.nvim",
	version = "*",
	opts = opts,
	event = "BufReadPre",
	keys = {
		m("<leader>v", [[NoNeckPain]]),
	},
}
