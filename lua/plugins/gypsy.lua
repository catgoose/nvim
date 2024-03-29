local dev = false
local e = vim.tbl_extend
local m = require("util").lazy_map

local opts = {
	dev = dev,
	log_level = "debug",
	ui = {
		prompt = {
			start_insert = false,
		},
		layout_placement = "center",
		-- layout_placement = "right",
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
			-- model = "gpt-4",
			temperature = 0.7,
			messages = {
				{
					role = "system",
					content = "You are a programming assistant",
				},
			},
		},
	},
	dev_opts = {
		prompt = {
			user_prompt = "summarize this code",
			enabled = true,
		},
	},
}

local setup = {
	opts = opts,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"kkharji/sqlite.lua",
	},
	keys = {
		-- m("<leader>z", [[Lazy reload chat-gypsy.nvim]]),
		-- m("<leader>x", [[lua require("chat-gypsy").toggle()]], { "n", "x" }),
		m("<leader>cc", [[lua require("chat-gypsy").history()]]),
		m("<leader>cv", [[lua require("chat-gypsy").models()]]),
	},
	cmd = { "GypsyToggle" },
	-- enabled = false,
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
