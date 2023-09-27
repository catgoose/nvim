local dev = true
local e = vim.tbl_extend
local m = require("util").lazy_map

local opts = {
	dev = dev,
	log_level = "debug",
	ui = {
		behavior = {
			mount = true,
			prompt = {
				start_insert = false,
			},
			layout = {
				type = "float",
			},
		},
		layout = {
			float = {
				size = {
					width = "70%",
					height = "70%",
				},
			},
		},
	},
	hooks = {
		request = {
			start = function(--[[content]]) end,
			chunk = function(--[[chunk]]) end,
			complete = function(response)
				-- require("notify")(response)
			end,
			error = function( --[[source, error_tbl]]) end,
		},
	},
	openai_params = {
		model = "gpt-3.5-turbo",
		temperature = 0.7,
		messages = {
			{
				role = "system",
				content = "You are a programming assistant for " .. vim.bo.filetype,
			},
		},
	},
	dev_opts = {
		prompt = {
			user_prompt = "write hello world in lua",
			enabled = true,
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
		-- m("<leader>x", [[lua require("chat-gypsy").history()]]),
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
