local opts = {
	ensure_installed = {
		"angularls",
		"awk_ls",
		"bashls",
		"cssls",
		"clangd",
		"cmake",
		"cssmodules_ls",
		"diagnosticls",
		"docker_compose_language_service",
		"dockerls",
		"eslint",
		"html",
		"jedi_language_server",
		"jsonls",
		"lua_ls",
		"marksman",
		"neocmake",
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
