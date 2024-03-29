local dev = true
local enabled = true
local e = vim.tbl_extend
local m = require("util").lazy_map
local project = require("util.project")

local opts = {
	dev = dev,
	log_level = "warn",
	edit_mode = "split",
	config_order = {
		"project",
		"global",
		"opts",
	},
	tasks = {
		{
			name = "push dotfiles",
			cmd = "fish -c 'dotfiles_push'",
			cwd = "~/git/dotfiles",
			tags = { "dotfiles", "update", "nvim", "repo", "sync" },
			window = {
				close = true,
				keep_current = true,
			},
		},
	},
}

local keys = {
	m("<leader>;", [[Telescope do-the-needful please]]),
	m("<leader>:", [[Telescope do-the-needful]]),
}
keys = project.get_keys("do-the-needful", keys)

local plugin = {
	dependencies = "nvim-lua/plenary.nvim",
	opts = opts,
	keys = keys,
	enabled = enabled,
}

if dev == true then
	return e("keep", plugin, {
		dir = "~/git/do-the-needful.nvim",
		lazy = false,
	})
else
	return e("keep", plugin, {
		"catgoose/do-the-needful.nvim",
		event = "BufReadPre",
	})
end
