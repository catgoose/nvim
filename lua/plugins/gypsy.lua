local dev = true
local e = vim.tbl_extend

local opts = {
	log_level = "debug",
}

local setup = {
	opts = opts,
}

if dev == true then
	return e("keep", setup, {
		dir = "~/git/gypsy.nvim",
		dev = true,
		lazy = false,
	})
else
	return e("keep", setup, {
		"catgoose/gypsy.nvim",
	})
end
