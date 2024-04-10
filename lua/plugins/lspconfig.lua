local km, l, api = vim.keymap.set, vim.lsp, vim.api

local config = function()
	local lspconfig = require("lspconfig")
	local vt = require("virtualtypes")

	local capabilities = vim.tbl_deep_extend(
		"force",
		vim.lsp.protocol.make_client_capabilities(),
		require("cmp_nvim_lsp").default_capabilities()
	)

	-- ufo
	capabilities.textDocument.foldingRange = {
		dynamicRegistration = false,
		lineFoldingOnly = true,
	}
	---@diagnostic disable-next-line: inject-field
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
			header = "",
			prefix = "",
		},
	})

	---@diagnostic disable-next-line: duplicate-set-field
	vim.lsp.handlers["textDocument/hover"] = function(_, result, ctx, config)
		if not (result and result.contents) then
			return
		end
		config = config or {}
		config.border = "rounded"
		l.handlers.hover(_, result, ctx, config)
	end
	l.handlers["textDocument/signatureHelp"] = l.with(l.handlers.signature_help, {
		border = "rounded",
	})
	---@diagnostic disable-next-line: duplicate-set-field
	l.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
		local ts_lsp = { "tsserver", "angularls", "volar" }
		local clients = l.get_clients({ id = ctx.client_id })
		if vim.tbl_contains(ts_lsp, clients[1].name) then
			local filtered_result = {
				diagnostics = vim.tbl_filter(function(d)
					return d.severity == 1
				end, result.diagnostics),
			}
			require("ts-error-translator").translate_diagnostics(err, filtered_result, ctx, config)
		end
		vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
	end

	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("UserLspConfig", {}),
		callback = function(event)
			local bufopts = { noremap = true, silent = true, buffer = event.bufnr }
			km("n", "[g", vim.diagnostic.goto_prev, bufopts)
			km("n", "]g", vim.diagnostic.goto_next, bufopts)
			km("n", "<leader>dd", vim.diagnostic.setqflist, bufopts)
			km("n", "gD", l.buf.declaration, bufopts)
			if not require("neoconf").get("lsp.keys.goto_definition.disable") then
				km("n", "gd", l.buf.definition, bufopts)
			end
			km("n", "gi", l.buf.implementation, bufopts)
			km("n", "<leader>D", l.buf.type_definition, bufopts)
			km("n", "gr", l.buf.references, bufopts)
			km({ "n", "v" }, "<leader>ca", l.buf.code_action, bufopts)
			km("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
			km("n", "L", vim.lsp.buf.hover, bufopts)
		end,
	})

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
	local on_attach = function(client, bufnr)
		format_on_attach(client, bufnr)
		virtual_types_on_attach(client, bufnr)
	end

	-- LSP config

	local ts_ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" }
	local vue_ft = { unpack(ts_ft) }
	table.insert(vue_ft, "vue")
	local css_ft = { "css", "scss", "less", "sass", "vue" }
	local html_ft = { "html", "vue" }

	local server_enabled = function(server)
		return not require("neoconf").get("lsp.servers." .. server .. ".disable")
	end

	local lspconfig_setups = {
		language_servers = {
			"awk_ls",
			"bashls",
			"docker_compose_language_service",
			"dockerls",
			"emmet_ls",
			"marksman",
			"sqlls",
			"tailwindcss",
			"yamlls",
		},
		csharp_ls = {
			capabilities = snippet_capabilities,
		},
		cssls = {
			capabilities = snippet_capabilities,
			filetypes = css_ft,
		},
		html = {
			capabilities = snippet_capabilities,
			filetypes = html_ft,
		},
		cssmodules_ls = {
			filetypes = vue_ft,
		},
		tsserver = {
			filetypes = ts_ft,
			init_options = {
				typescript = {
					tsdk = vim.fn.getcwd() .. "/node_modules/typescript/lib",
				},
			},
		},
		volar = {
			filetypes = { "vue" },
			init_options = {
				vue = {
					hybridMode = false,
				},
				typescript = {
					tsdk = vim.fn.getcwd() .. "/node_modules/typescript/lib",
				},
			},
		},
		jsonls = {
			capabilities = snippet_capabilities,
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
			on_attach = function(client, bufnr)
				on_attach(client, bufnr)
				client.server_capabilities.renameProvider = false
			end,
		},
	}

	for srv, cfg in pairs(lspconfig_setups) do
		if srv == "language_servers" then
			for _, ls in ipairs(cfg) do
				lspconfig[ls].setup({
					capabilities = capabilities,
					on_attach = on_attach,
				})
			end
		elseif server_enabled(srv) then
			if not cfg.on_attach then
				cfg.on_attach = on_attach
			end
			if not cfg.capabilities then
				cfg.capabilities = capabilities
			end
			lspconfig[srv].setup(cfg)
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
end

return {
	"neovim/nvim-lspconfig",
	init = function()
		require("neoconf").setup({})
	end,
	config = config,
	dependencies = {
		"windwp/nvim-autopairs",
		"williamboman/mason.nvim",
		"b0o/schemastore.nvim",
		"litao91/lsp_lines",
		"kevinhwang91/nvim-ufo",
		"VidocqH/lsp-lens.nvim",
		"jubnzv/virtual-types.nvim",
		"folke/neoconf.nvim",
		-- "pmizio/typescript-tools.nvim",
		"dmmulroy/ts-error-translator.nvim",
	},
}
