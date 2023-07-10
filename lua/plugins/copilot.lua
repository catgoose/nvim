local opts = {
	panel = {
		enabled = true,
		auto_refresh = true,
		keymap = {
			jump_prev = false,
			jump_next = false,
			accept = false,
			refresh = false,
			open = false,
		},
		layout = {
			position = "bottom",
			ratio = 0.4,
		},
	},
	suggestion = {
		enabled = true,
		auto_trigger = false,
		debounce = 75,
		keymap = {
			accept = "<S-Tab>",
			accept_line = "<M-o>",
			next = "<M-]>",
			prev = "<M-[>",
			dismiss = "<C-]>",
		},
	},
	filetypes = {
		help = false,
		gitcommit = false,
		prompt = false,
		TelescopePrompt = false,
		DressingInput = false,
		DressingSelect = false,
		harpoon = false,
		neorepl = false,
		sh = function()
			if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), "^%.env.*") then
				return false
			end
			return true
		end,
		["."] = false,
	},
	copilot_node_command = "node",
	server_opts_overrides = {},
}

return {
	"zbirenbaum/copilot.lua",
	opts = opts,
	cmd = "Copilot",
	event = "InsertEnter",
}
