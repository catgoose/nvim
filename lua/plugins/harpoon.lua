local u = require("util")
local m = u.lazy_map
local opts = {
	settings = {
		ui_fallback_width = 39,
		ui_width_ratio = 0.45,
	},
}

return {
	"ThePrimeagen/harpoon",
	opts = opts,
	keys = {
		m("<leader>a", function()
			require("harpoon"):list():append()
		end, { "n", "x" }),
		m("<leader>l", function()
			local harpoon = require("harpoon")
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, { "n", "x" }),
		m("]]", function()
			require("harpoon"):list():next()
		end, { "n", "x" }),
		m("[[", function()
			require("harpoon"):list():prev()
		end, { "n", "x" }),
	},
	dependencies = "nvim-lua/plenary.nvim",
	branch = "harpoon2",
}
