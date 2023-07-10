local k, l, api = vim.keymap.set, vim.lsp, vim.api

local config = function()
	local m = require("util").cmd_map

	local lspc = require("lspconfig")
	local ts = require("typescript")
	local cmp = require("cmp_nvim_lsp")
	local vt = require("virtualtypes")

	-- LSP capabilities
	local capabilities = l.protocol.make_client_capabilities()
	--  cmp
	capabilities = cmp.default_capabilities(capabilities)
	--  ufo
	capabilities.textDocument.foldingRange = {
		dynamicRegistration = false,
		lineFoldingOnly = true,
	}
	capabilities.offsetEncoding = { "utf-16" }

	local _snippet_capabilities = l.protocol.make_client_capabilities()
	_snippet_capabilities.textDocument.completion.completionItem.snippetSupport = true
	local snippet_capabilities = vim.tbl_extend("keep", capabilities, _snippet_capabilities)

	-- Diagnostic
	vim.diagnostic.config({
		virtual_text = false,
		virtual_lines = {
			only_current_line = true,
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
	l.handlers["textDocument/signatureHelp"] = l.with(l.handlers.signature_help, {
		border = "rounded",
	})
	-- markdown hover with rounded corners
	---@diagnostic disable-next-line: duplicate-set-field
	l.handlers["textDocument/hover"] = function(_, result, ctx, config)
		config = config or { border = "rounded", focusable = false }
		config.focus_id = ctx.method
		if not (result and result.contents) then
			return
		end
		local markdown_lines = l.util.convert_input_to_markdown_lines(result.contents)
		markdown_lines = l.util.trim_empty_lines(markdown_lines)
		if vim.tbl_isempty(markdown_lines) then
			return
		end
		return l.util.open_floating_preview(markdown_lines, "markdown", config)
	end

	-- global keybindings
	local opts = { noremap = true, silent = true }
	k("n", "[g", vim.diagnostic.goto_prev, opts)
	k("n", "]g", vim.diagnostic.goto_next, opts)
	k("n", "<leader>dd", vim.diagnostic.setqflist, opts)

	-- buf keybindings
	local keys_on_attach = function(_, bufnr)
		local bufopts = { noremap = true, silent = true, buffer = bufnr }
		k("n", "gD", l.buf.declaration, bufopts)
		k("n", "gd", l.buf.definition, bufopts)
		k("n", "gi", l.buf.implementation, bufopts)
		k("n", "<leader>D", l.buf.type_definition, bufopts)
		k("n", "gr", l.buf.references, bufopts)
		k("n", "<leader>ca", l.buf.code_action, bufopts)
		k("v", "<leader>ca", l.buf.code_action, bufopts)
	end

	local lsp_formatting = function(bufnr)
		vim.lsp.buf.format({
			filter = function(client)
				return client.name == "null-ls"
			end,
			bufnr = bufnr,
		})
	end
	local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
	local format_on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					lsp_formatting(bufnr)
				end,
			})
		end
	end
	local virtual_types_on_attach = function(client, bufnr)
		if client.server_capabilities.textDocument then
			if client.server_capabilities.textDocument.codeLens then
				vt.on_attach(client, bufnr)
			end
		end
	end
	local base_on_attach = function(client, bufnr)
		keys_on_attach(client, bufnr)
		format_on_attach(client, bufnr)
		virtual_types_on_attach(client, bufnr)
	end
	local on_attach = function(client, bufnr)
		base_on_attach(client, bufnr)
		m("<leader>rn", [[lua require("renamer").rename()]], { "n", "v" })
	end
	local ts_on_attach = function(client, bufnr)
		base_on_attach(client, bufnr)
		m("<leader>rn", "AnglerRenameSymbol", "n", { noremap = true, silent = true, buffer = bufnr })
		client.server_capabilities.renameProvider = true
	end

	-- LSP config
	ts.setup({
		capabilities = capabilities,
		disable_commands = false,
		debug = false,
		server = {
			on_attach = ts_on_attach,
		},
	})

	lspc.angularls.setup({
		capabilities = capabilities,
		on_attach = function(client, bufnr)
			on_attach(client, bufnr)
			client.server_capabilities.renameProvider = false
		end,
	})

	lspc.lua_ls.setup({
		capabilities = capabilities,
		on_attach = function(client, bufnr)
			on_attach(client, bufnr)
		end,
		settings = {
			Lua = {
				runtime = {
					version = "LuaJIT",
				},
				diagnostics = {
					globals = { "vim", "require" },
				},
				workspace = {
					library = api.nvim_get_runtime_file("", true),
					checkThirdParty = false,
				},
				telemetry = { enable = false },
				hint = {
					enable = true,
				},
			},
		},
	})

	lspc.vimls.setup({
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

	lspc.jsonls.setup({
		capabilities = snippet_capabilities,
		on_attach = on_attach,
		settings = {
			json = {
				schemas = require("schemastore").json.schemas({
					select = {
						"package.json",
						".eslintrc",
						"tsconfig.json",
					},
				}),
				validate = { enable = true },
			},
		},
	})

	local lang_servers = {
		"bashls",
		"cssmodules_ls",
		"docker_compose_language_service",
		"dockerls",
		"marksman",
		"powershell_es",
		"rust_analyzer",
		"tailwindcss",
		"yamlls",
	}
	for _, lang in pairs(lang_servers) do
		lspc[lang].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})
	end

	local lang_servers_snippet_support = {
		"html",
		"cssls",
	}
	for _, lang in pairs(lang_servers_snippet_support) do
		lspc[lang].setup({
			capabilities = snippet_capabilities,
			on_attach = on_attach,
		})
	end
end

return {
	"neovim/nvim-lspconfig",
	config = config,
	dependencies = {
		"windwp/nvim-autopairs",
		"jose-elias-alvarez/typescript.nvim",
		"williamboman/mason.nvim",
		"b0o/schemastore.nvim",
		"onsails/lspkind-nvim",
		"litao91/lsp_lines",
		"kevinhwang91/nvim-ufo",
		"VidocqH/lsp-lens.nvim",
		"jubnzv/virtual-types.nvim",
		"filipdutescu/renamer.nvim",
	},
}
