local dev = true
local e = vim.tbl_extend
local m = require("util").lazy_map

local opts = {
	dev = dev,
	log_level = "trace",
	config_order = {
		"project",
		"opts",
		"global",
	},
	tasks = {
		{
			name = "List directory",
			cmd = "ls",
			window = {
				close = false,
			},
		},
	},
}

local plugin = {
	keys = {
		m("<leader>;", [[Telescope do-the-needful please]]),
		m("<leader>:", [[Telescope do-the-needful]]),
		m("<leader>x", [[Lazy reload do-the-needful]]),
	},
	dependencies = "nvim-lua/plenary.nvim",
	opts = opts,
	enabled = true,
}

if dev == true then
	return e("keep", plugin, {
		dir = "~/git/do-the-needful",
		lazy = false,
	})
else
	return e("keep", plugin, {
		"catgoose/do-the-needful.nvim",
		event = "BufReadPre",
	})
end
