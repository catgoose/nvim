local m = require("util").lazy_map

local opts = {
	models = {
		{
			name = "openai",
			model = "gpt-3.5-turbo",
			params = nil,
		},
	},
	open_api_key_env = "$env:OPENAI_API_KEY",
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
                ]] .. vim.fn.system("git diff --cached")
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
		m("<leader>ga", [[NeoAIToggle]]),
		m("<leader>gg", [[NeoAIContext]]),
	},
	opts = opts,
}
