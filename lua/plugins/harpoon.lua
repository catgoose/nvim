local u = require("util")
local m = u.lazy_map
local scale = u.screen_scale({ width = 1 / 2, height = 1 / 3 })
local opts = {
	menu = scale,
	save_on_toggle = true,
	save_on_change = true,
	enter_on_sendcmd = true,
	tmux_autoclose_windows = true,
	excluded_filetypes = { "harpoon" },
	mark_branch = false,
}

return {
	"ThePrimeagen/harpoon",
	-- opts = opts,
	config = function()
		require("harpoon"):setup()
	end,
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
