local dev = true
local e = vim.tbl_extend
local m = require("util").lazy_map

local opts = {
	log_level = "debug",
	dev = dev,
}

local setup = {
	opts = opts,
}

if dev == true then
	return e("keep", setup, {
		dir = "~/git/gypsy.nvim",
		dev = true,
		lazy = false,
		keys = {
			m("<leader>rl", [[Lazy reload gypsy.nvim]]),
		},
	})
else
	return e("keep", setup, {
		"catgoose/gypsy.nvim",
	})
end
