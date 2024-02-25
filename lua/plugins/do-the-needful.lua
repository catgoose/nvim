local dev = true
local e = vim.tbl_extend
local m = require("util").lazy_map
vim.g.do_the_needful_log_level = "debug"

local opts = {
	tasks = {},
	config = ".tasks.json",
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
		"catgoose/do-the-needful",
		event = "BufReadPre",
	})
end
