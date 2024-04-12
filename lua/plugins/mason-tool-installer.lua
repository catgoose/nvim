local opts = {
	auto_update = true,
	run_on_start = true,
	ensure_installed = {
		"beautysh",
		"codespell",
		"eslint_d",
		"hadolint",
		"jsonlint",
		"markdownlint",
		"misspell",
		"prettierd",
		"shellcheck",
		"shellharden",
		"shfmt",
		"stylua",
		"yamlfmt",
	},
}

return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	opts = opts,
	cmd = "MasonToolsUpdate",
	event = "BufReadPre",
	dependencies = "williamboman/mason.nvim",
}
