local dev = false
local enabled = true
local e = vim.tbl_extend
local m = require("util").lazy_map
local project = require("util.project")

local opts = {
	log_level = "info",
}

local keys = {
	-- m("<leader>;", [[Telescope do-the-needful please]]),
}
keys = project.get_keys("class-warfare", keys)

local plugin = {
	dependencies = "nvim-lua/plenary.nvim",
	opts = opts,
	keys = keys,
	enabled = enabled,
}

if dev == true then
	return e("keep", plugin, {
		dir = "~/git/class-warfare",
		lazy = false,
	})
else
	return e("keep", plugin, {
		"catgoose/class-warfare",
		event = "BufReadPre",
	})
end
