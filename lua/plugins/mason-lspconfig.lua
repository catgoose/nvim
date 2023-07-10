local opts = {
	ensure_installed = {
		"angularls",
		"bashls",
		"cssls",
		"clangd",
		"cssmodules_ls",
		"diagnosticls",
		"docker_compose_language_service",
		"dockerls",
		"eslint",
		"html",
		"jsonls",
		"lua_ls",
		"marksman",
		"powershell_es",
		"rust_analyzer",
		"tailwindcss",
		"tsserver",
		"yamlls",
	},
	automatic_installation = true,
}

return {
	"williamboman/mason-lspconfig.nvim",
	opts = opts,
	event = "BufReadPre",
	dependencies = "williamboman/mason.nvim",
}
