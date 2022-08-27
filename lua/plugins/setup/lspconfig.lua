local utils = require("config.utils")
local plugin = utils.require_plugin

local lspconfig = plugin("lspconfig")
local typescript = plugin("typescript")
local aerial = plugin("aerial")
local cmp = plugin("cmp_nvim_lsp")

-- LSP capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = cmp.update_capabilities(capabilities)
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Diagnostic
vim.diagnostic.config({
	virtual_text = false,
	virtual_lines = {
		only_current_line = true,
	},
	signs = {
		active = utils.diagnostic_signs(),
	},
	update_in_insert = false,
	underline = true,
	severity_sort = true,
	float = {
		focusable = true,
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
	},
})

-- Handlers
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
	border = "rounded",
})
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
	border = "rounded",
})

-- Keybindings
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "[g", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]g", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<space>e", vim.diagnostic.setloclist, opts)

local shared_on_attach = function(client, bufnr)
	aerial.on_attach(client, bufnr)

	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
	vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
	vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
	vim.keymap.set("v", "<space>ca", vim.lsp.buf.code_action, bufopts)
end

-- LSP config

local on_attach = function(client, bufnr)
	shared_on_attach(client, bufnr)
end

typescript.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	disable_commands = false,
	debug = false,
	server = { on_attach = on_attach },
})

lspconfig.sumneko_lua.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			diagnostics = { globals = { "vim" } },
			workspace = { library = vim.api.nvim_get_runtime_file("", true) },
			telemetry = { enable = false },
		},
	},
})

lspconfig.vimls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	diagnostic = { enable = true },
	indexes = {
		count = 3,
		gap = 100,
		projectRootPatterns = { "runtime", "nvim", ".git", "autoload", "plugin" },
		runtimepath = true,
	},
	isNeovim = true,
	iskeyword = "@,48-57,_,192-255,-#",
	runtimepath = "",
	suggest = { fromRuntimepath = true, fromVimruntime = true },
	vimruntime = "",
})

lspconfig.jsonls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		json = {
			schemas = require("schemastore").json.schemas(),
			validate = { enable = true },
		},
	},
})

local lang_servers = {
	"angularls",
	"cssmodules_ls",
	"diagnosticls",
	"dockerls",
	"eslint",
	"cssls",
	"html",
	"marksman",
}

for _, lang in pairs(lang_servers) do
	require("lspconfig")[lang].setup({
		capabilities = capabilities,
		on_attach = on_attach,
	})
end
