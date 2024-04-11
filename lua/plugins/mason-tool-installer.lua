local opts = {
	auto_update = true,
	run_on_start = true,
	ensure_installed = {
		"beautysh",
		"eslint_d",
		"hadolint",
		"jsonlint",
		"misspell",
		"prettierd",
		"shellcheck",
		"stylua",
	},
}

return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	opts = opts,
	cmd = "MasonToolsUpdate",
	event = "BufReadPre",
	dependencies = "williamboman/mason.nvim",
}
