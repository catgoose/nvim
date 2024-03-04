local m = require("util").lazy_map

local opts = {
	popup_type = "popup",
	openai_model_id = "gpt-3.5-turbo",
	language = "english",
	-- additional_instructions = "Start the reply with 'OH HAI THERE'",
	search_engine = "google",
}
return {
	"piersolenski/wtf.nvim",
	dependencies = {
		"MunifTanjim/nui.nvim",
	},
	event = "VeryLazy",
	opts = opts,
	keys = {
		m("gw", [[lua require("wtf").ai()]]),
		m("gW", [[lua require("wtf").search()]]),
	},
	enabled = false,
}
