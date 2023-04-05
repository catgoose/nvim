local g = vim.g

g.mapleader = " "
g.maplocalleader = " "
g.cursorhold_updatetime = 100
g.suda_smart_edit = 1
g.clipboard = { -- install xclip
	name = "xclip",
	copy = {
		["+"] = "xclip -f -sel clip",
		["*"] = "xclip -f -sel clip",
	},
	paste = {
		["+"] = "xclip -o -sel clip",
		["*"] = "xclip -o -sel clip",
	},
	cache_enabled = 1,
}
