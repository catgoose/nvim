local dev = false
local e = vim.tbl_extend
local m = require("util").lazy_map
vim.g.tmux_tasks_log_level = "trace"

local opts = {
	tasks = {},
	config = ".tasks.json",
}

local plugin = {
	keys = {
		m("<leader>;", [[Telescope do-the-needful please]]),
		m("<leader>:", [[Telescope do-the-needful]]),
	},
	dependencies = "nvim-lua/plenary.nvim",
	opts = opts,
	enabled = true,
}

if dev == true then
	return e("keep", plugin, {
		dir = "~/git/do-the-needful",
		dev = true,
		lazy = false,
	})
else
	return e("keep", plugin, {
		"catgoose/do-the-needful",
		event = "BufReadPre",
	})
end
