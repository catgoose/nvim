require("config.utils").plugin_setup("suit", {
	input = {
		default_prompt = "Input: ",
		border = "single",
		hl_input = "NormalFloat",
		hl_prompt = "NormalFloat",
		hl_border = "FloatBorder",
	},
	select = {
		default_prompt = "Select one of: ",
		border = "single",
		hl_select = "NormalFloat",
		hl_prompt = "NormalFloat",
		hl_selected_item = "PmenuSel",
		hl_border = "FloatBorder",
	},
})
