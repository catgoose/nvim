local dev = false
local e = vim.tbl_extend
local m = require("util").lazy_map

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
			id = "list1", -- id is used to reference a task in a job
			name = "List directory 1",
			cmd = "ls -al",
			cwd = "${cwd}",
			tags = { "list", "dir", "open", "pwd" },
			window = {
				close = false,
				keep_current = false,
			},
			hidden = true,
		},
		{
			id = "list2",
			name = "List directory 2",
			cmd = "ls -al",
			cwd = "~",
			tags = { "list", "dir", "close", "home" },
			window = {
				close = false,
				keep_current = false,
			},
			hidden = true,
		},
	},
	jobs = {
		{
			name = "list directories",
			tags = { "job", "list", "directories", "ordered" },
			tasks = { -- task.id to run in order
				"list1",
				"list2",
			},
			-- window = {
			-- 	close = true,
			-- 	keep_current = false,
			-- 	open_relative = true,
			-- 	relative = "before",
			-- },
		},
		{ -- multiple jobs can be created from the same task ids
			name = "list directories",
			tags = { "job", "list", "directories", "reversed" },
			tasks = {
				"list2",
				"list1",
			},
			-- window = {
			-- 	close = false,
			-- 	keep_current = true,
			-- },
		},
	},
}

local plugin = {
	keys = {
		m("<leader>;", [[Telescope do-the-needful please]]),
		m("<leader>:", [[Telescope do-the-needful]]),
		{
			"<leader>z",
			function()
				vim.cmd([[Lazy reload do-the-needful]])
				vim.cmd([[Lazy reload telescope.nvim]])
			end,
		},
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
		"catgoose/do-the-needful.nvim",
		event = "BufReadPre",
	})
end
