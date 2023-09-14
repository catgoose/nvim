local dev = true
local e = vim.tbl_extend
local m = require("util").lazy_map

local opts = {
	dev = dev,
	log_level = "debug",
	ui = {
		prompt = {
			start_insert = false,
		},
	},
	hooks = {
		request = {
			start = function(--[[content]]) end,
			chunk = function(--[[chunk]]) end,
			complete = function(
				response --[[response]]
			)
				vim.print(response)
			end,
		},
	},
	openai_params = {
		model = "gpt-3.5-turbo",
		temperature = 0.7,
		messages = {
			{
				role = "system",
				content = "You are gypsy",
			},
		},
	},
	dev_opts = {
		prompt = {
			user_prompt = "Insert new lines",
			enabled = false,
		},
	},
}

local setup = {
	opts = opts,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
	},
	keys = {
		m("<leader>z", [[Lazy reload chat-gypsy.nvim]]),
		m("<leader>x", [[lua require("chat-gypsy").toggle()]]),
	},
	cmd = { "GypsyToggle" },
}

if dev == true then
	return e("keep", setup, {
		dir = "~/git/chat-gypsy.nvim",
		dev = true,
		lazy = false,
	})
else
	return e("keep", setup, {
		"catgoose/chat-gypsy.nvim",
	})
end
