local m = require("util").lazy_map

local opts = {
	debug = false,
	silent = false,
	short_paths = true,
	search_paths = {
		"toggletasks",
		".toggletasks",
		".nvim/toggletasks",
	},
	scan = {
		global_cwd = true,
		tab_cwd = true,
		win_cwd = true,
		lsp_root = true,
		dirs = {},
		rtp = false,
		rtp_ftplugin = false,
	},
	tasks = function(win)
		return require("util.toggle").toggle_tasks(win)
	end,
	lsp_priorities = {
		["null-ls"] = -10,
	},
	toggleterm = {
		close_on_exit = true,
		hidden = true,
	},
	telescope = {
		spawn = {
			open_single = true,
			show_running = true,
			mappings = {
				select_float = "<C-f>",
				spawn_smart = "<C-a>",
				spawn_all = "<M-a>",
				spawn_selected = nil,
			},
		},
		select = {
			mappings = {
				select_float = "<C-f>",
				open_smart = "<C-a>",
				open_all = "<M-a>",
				open_selected = nil,
				kill_smart = "<C-q>",
				kill_all = "<M-q>",
				kill_selected = nil,
				respawn_smart = "<C-s>",
				respawn_all = "<M-s>",
				respawn_selected = nil,
			},
		},
	},
}

return {
	"jedrzejboczar/toggletasks.nvim",
	opts = opts,
	keys = {
		m("<leader>;", "Telescope toggletasks spawn", { "n", "x" }),
	},
	dependencies = "akinsho/toggleterm.nvim",
}
