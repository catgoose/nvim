local g = vim.g
local is_x_display = require("util").is_x_display

g.mapleader = " "
g.maplocalleader = " "
g.cursorhold_updatetime = 100
g.suda_smart_edit = 1

--  HACK: 2023-09-24 - neovim nightly is broken for python3 provider
g.python3_host_prog = "python3"

if is_x_display() then
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
end
