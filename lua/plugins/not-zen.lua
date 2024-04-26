local dev = false
local e = vim.tbl_extend
local cmd = vim.cmd
local m = require("util").lazy_map

local opts = {
	padding = {
		width = 0.2,
	},
	on_open = function()
		cmd("silent !tmux set status off")
		cmd("silent !i3-msg fullscreen enable")
	end,
	on_close = function()
		cmd("silent !tmux set status on")
		cmd("silent !i3-msg fullscreen disable")
	end,
}

local plugin = {
	opts = opts,
	keys = {
		m("<leader>v", [[NotZenToggleNoCb]]),
		-- m("<leader>z", [[NotZenToggle]]),
	},
}

if dev == true then
	return e("keep", plugin, {
		dir = "~/git/not-zen.nvim",
		dev = true,
		lazy = false,
	})
else
	return e("keep", plugin, {
		"catgoose/not-zen.nvim",
		event = "BufReadPre",
		enabled = false,
	})
end
