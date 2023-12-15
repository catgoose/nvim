local m = require("util").lazy_map

local opts = {
	ui = {
		output_popup_text = "NeoAI",
		input_popup_text = "Prompt",
		width = 50, -- As percentage eg. 30%
		output_popup_height = 80, -- As percentage eg. 80%
		submit = "<Enter>", -- Key binding to submit the prompt
	},
	models = {
		{
			name = "openai",
			-- model = "gpt-3.5-turbo",
			model = "gpt-4",
			params = nil,
		},
	},
	shortcuts = {
		{
			name = "textify",
			key = "<leader>as",
			desc = "fix text with AI",
			use_context = true,
			prompt = [[
                Please rewrite the text to make it more readable, clear,
                concise, and fix any grammatical, punctuation, or spelling
                errors
            ]],
			modes = { "v" },
			strip_function = nil,
		},
		{
			name = "gitcommit",
			key = "<leader>ag",
			desc = "generate git commit message",
			use_context = false,
			prompt = function()
				return [[
                    Using the following git diff generate a consise and
                    clear git commit message, with a short title summary
                    that is 75 characters or less:
                ]] .. vim.fn.system("git diff --cached") .. [[
                Only respond with the git commit message, not the
                diff above.
                ]]
			end,
			modes = { "n" },
			strip_function = nil,
		},
	},
}

return {
	"Bryley/neoai.nvim",
	dependencies = {
		"MunifTanjim/nui.nvim",
	},
	cmd = {
		"NeoAI",
		"NeoAIOpen",
		"NeoAIClose",
		"NeoAIToggle",
		"NeoAIContext",
		"NeoAIContextOpen",
		"NeoAIContextClose",
		"NeoAIInject",
		"NeoAIInjectCode",
		"NeoAIInjectContext",
		"NeoAIInjectContextCode",
		"NeoAIShortcut",
	},
	keys = {
		m("<leader>ga", [[NeoAIToggle]], { "n", "v" }),
		m("<leader>gg", [[NeoAIContext]], { "n", "v" }),
	},
	opts = opts,
}
