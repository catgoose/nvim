local opts = {
	ensure_installed = {
		"angularls",
		"awk_ls",
		"bashls",
		"clangd",
		"cssls",
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
		"powershell_es",
		"sqlls",
		"tailwindcss",
		"tsserver",
		"volar",
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
