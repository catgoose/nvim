local dev = true
local enabled = true
local e = vim.tbl_extend
local project = require("util.project")

local opts = {
	filters = {
		auto_imports = true,
		auto_components = true,
		same_file = true,
		declaration = true,
	},
}

local keys = project.get_keys("vue-goto-definition")

local plugin = {
	keys = keys,
	opts = opts,
	enabled = enabled,
}

if dev == true then
	return e("keep", plugin, {
		dir = "~/git/vue-goto-definition.nvim",
		lazy = false,
	})
else
	return e("keep", plugin, {
		"catgoose/vue-goto-definition.nvim",
		event = "BufReadPre",
	})
end
