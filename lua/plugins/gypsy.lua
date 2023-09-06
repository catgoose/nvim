local dev = true
local e = vim.tbl_extend
local m = require("util").lazy_map

local opts = {
	dev = dev,
	log_level = "debug",
	ui = {
		prompt = {
			start_insert = true,
		},
	},
}

local setup = {
	opts = opts,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
	},
}

if dev == true then
	return e("keep", setup, {
		dir = "~/git/gypsy.nvim",
		dev = true,
		lazy = false,
		keys = {
			m("<leader>z", [[Lazy reload gypsy.nvim]]),
			m("<leader>x", [[lua require("gypsy").toggle()]]),
		},
	})
else
	return e("keep", setup, {
		"catgoose/gypsy.nvim",
	})
end
