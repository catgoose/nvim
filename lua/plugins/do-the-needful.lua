local dev = true
local e = vim.tbl_extend
local m = require("util").lazy_map

local opts = {
	dev = dev,
	log_level = "debug",
	config_order = {
		"opts",
		"project",
		"global",
	},
	tasks = {
		{
			name = "eza from opts", -- name of task
			-- cmd = "eza ${dir}", -- command to run
			cmd = "eza ${needful} ${cwd}", -- command to run
			cwd = "~", -- working directory to run task
			tags = { "eza", "home", "files" }, -- task metadata used for searching
			ask_tokens = { -- Used to prompt for input to be passed into task
				["${dir}"] = {
					ask = "Which directory to search", -- defaults to the name of token
					default = "", -- defaults to "".  A function can be supplied to
					-- evaluate the default
				},
			},
			window = { -- all window options are optional
				name = "Eza ~", -- name of tmux window
				close = false, -- close window after execution
				keep_current = false, -- switch to window when running task
				open_relative = true, -- open window after/before current window
				relative = "after", -- relative direction
			},
		},
	},
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
