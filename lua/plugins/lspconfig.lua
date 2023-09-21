local k, l, api = vim.keymap.set, vim.lsp, vim.api

local server_enabled = function(server)
	return not require("neoconf").get("lsp.servers." .. server .. ".disable")
end

local config = function()
	local m = require("util").cmd_map

	local lspconfig = require("lspconfig")
	local ts = require("typescript")
	local cmp = require("cmp_nvim_lsp")
	local clangd_ext = require("clangd_extensions")
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
	---@diagnostic disable-next-line: inject-field
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

	-- on_attach definitions
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
		vim.lsp.inlay_hint(bufnr, true)
	end
	local on_attach = function(client, bufnr)
		base_on_attach(client, bufnr)
	end
	local ts_on_attach = function(client, bufnr)
		base_on_attach(client, bufnr)
		m("<leader>rn", "AnglerRenameSymbol", "n", { noremap = true, silent = true, buffer = bufnr })
		client.server_capabilities.renameProvider = true
	end
	local volar_on_attach = function(client, bufnr)
		ts_on_attach(client, bufnr)
	end

	-- LSP config
	if server_enabled("tsserver") then
		ts.setup({
			capabilities = capabilities,
			debug = false,
			server = {
				on_attach = ts_on_attach,
			},
		})
	end

	local lspconfig_setups = {
		volar = {
			capabilities = capabilities,
			on_attach = volar_on_attach,
			filetypes = { "typescript", "javascript", "vue" },
		},
		jsonls = {
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
		},
		vimls = {
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
		},
		lua_ls = {
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
		},
		angularls = {
			capabilities = capabilities,
			on_attach = function(client, bufnr)
				on_attach(client, bufnr)
				client.server_capabilities.renameProvider = false
			end,
		},
	}

	for srv, cfg in pairs(lspconfig_setups) do
		if server_enabled(srv) then
			lspconfig[srv].setup(cfg)
		end
	end

	local lang_servers = {
		"awk_ls",
		"bashls",
		"csharp_ls",
		"cssmodules_ls",
		"docker_compose_language_service",
		"dockerls",
		"jedi_language_server",
		"marksman",
		"powershell_es",
		"sqlls",
		"tailwindcss",
		"yamlls",
	}
	for _, srv in pairs(lang_servers) do
		if server_enabled(srv) then
			lspconfig[srv].setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})
		end
	end
	if server_enabled("diagnosticls") then
		lspconfig.diagnosticls.setup({
			capabilities = capabilities,
			on_attach = function(client, bufnr)
				local stop_ft = {
					"dap-repl",
				}
				for _, ft in pairs(stop_ft) do
					if vim.bo.filetype == ft then
						if l.buf_is_attached(bufnr, client.id) then
							local notify = vim.notify
							---@diagnostic disable-next-line: duplicate-set-field
							vim.notify = function() end
							l.buf_detach_client(bufnr, client.id)
							vim.notify = notify
						end
					end
				end
				on_attach(client, bufnr)
			end,
		})
	end
	if server_enabled("clangd") then
		clangd_ext.setup({
			server = {
				capabilities = capabilities,
				on_attach = on_attach,
			},
		})
	end

	local lang_servers_snippet_support = {
		"html",
		"cssls",
	}
	for _, lang in pairs(lang_servers_snippet_support) do
		if server_enabled(lang) then
			lspconfig[lang].setup({
				capabilities = snippet_capabilities,
				on_attach = on_attach,
			})
		end
	end
end

return {
	"neovim/nvim-lspconfig",
	init = function()
		require("neoconf").setup({})
	end,
	config = config,
	dependencies = {
		"windwp/nvim-autopairs",
		"jose-elias-alvarez/typescript.nvim",
		"williamboman/mason.nvim",
		"b0o/schemastore.nvim",
		"onsails/lspkind-nvim",
		"litao91/lsp_lines",
		"kevinhwang91/nvim-ufo",
		"p00f/clangd_extensions.nvim",
		"VidocqH/lsp-lens.nvim",
		"jubnzv/virtual-types.nvim",
		"folke/neoconf.nvim",
	},
}
