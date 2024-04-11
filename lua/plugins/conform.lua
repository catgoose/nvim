local opts = {
	formatters_by_ft = {
		lua = { "stylua" },
		javascript = {
			{
				"prettierd",
				"prettier",
			},
		},
	},
	format_on_save = { timeout_ms = 500, lsp_fallback = true },
	formatters = {
		shfmt = {
			prepend_args = { "-i", "2" },
		},
	},
}
return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	opts = opts,
	cmd = { "ConformInfo" },
}
