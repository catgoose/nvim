local dev = false
local e = vim.tbl_extend
local m = require("util").lazy_map
-- vim.g.tmux_tasks_log_level = "debug"

local opts = {
	tasks = {},
}

local plugin = {
	keys = {
		m("<leader>;", [[Telescope tmux-tasks tasks]]),
		m("<leader>:", [[Telescope tmux-tasks]]),
	},
	dependencies = "nvim-lua/plenary.nvim",
	opts = opts,
	enabled = true,
}

if dev == true then
	return e("keep", plugin, {
		dir = "~/git/tmux-tasks.nvim",
		dev = true,
		lazy = false,
	})
else
	return e("keep", plugin, {
		"catgoose/tmux-tasks.nvim",
		event = "BufReadPre",
	})
end
