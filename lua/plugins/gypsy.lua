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
				direction = "right",
			},
		},
		layout = {
			center = {
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
	openai = {
		openai_params = {
			model = "gpt-3.5-turbo",
			temperature = 0.7,
			messages = {
				{
					role = "system",
					content = "Reply with the next number",
				},
			},
		},
	},
	dev_opts = {
		prompt = {
			user_prompt = "1",
			enabled = true,
		},
	},
}

local setup = {
	-- opts = opts,
	config = function()
		require("chat-gypsy").setup(opts)
	end,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"kkharji/sqlite.lua",
	},
	keys = {
		m("<leader>z", [[Lazy reload chat-gypsy.nvim]]),
		m("<leader>x", [[lua require("chat-gypsy").toggle()]]),
		m("<leader>cc", [[lua require("chat-gypsy").history()]]),
	},
	cmd = { "GypsyToggle" },
}

if dev == true then
	return e("keep", setup, {
		dir = "~/git/chat-gypsy.nvim",
		lazy = true,
	})
else
	return e("keep", setup, {
		"catgoose/chat-gypsy.nvim",
	})
end
