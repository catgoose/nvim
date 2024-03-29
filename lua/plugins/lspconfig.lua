local km, l, api = vim.keymap.set, vim.lsp, vim.api

local config = function()
	local lspconfig = require("lspconfig")
	local vt = require("virtualtypes")

	local capabilities = vim.tbl_deep_extend(
		"force",
		vim.lsp.protocol.make_client_capabilities(),
		require("cmp_nvim_lsp").default_capabilities()
	)

	--  ufo
	-- capabilities.textDocument.foldingRange = {
	-- 	dynamicRegistration = false,
	-- 	lineFoldingOnly = true,
	-- }
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
			-- source = "always",
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

	-- buf keybindings
	local keys_on_attach = function(_, bufnr)
		local bufopts = { noremap = true, silent = true, buffer = bufnr }
		km("n", "[g", vim.diagnostic.goto_prev, bufopts)
		km("n", "]g", vim.diagnostic.goto_next, bufopts)
		km("n", "<leader>dd", vim.diagnostic.setqflist, bufopts)
		km("n", "gD", l.buf.declaration, bufopts)
		km("n", "gd", l.buf.definition, bufopts)
		km("n", "gi", l.buf.implementation, bufopts)
		km("n", "<leader>D", l.buf.type_definition, bufopts)
		km("n", "gr", l.buf.references, bufopts)
		km({ "n", "v" }, "<leader>ca", l.buf.code_action, bufopts)
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
		-- vim.lsp.inlay_hint(bufnr, true)
	end
	--  TODO: 2024-03-21 - Reimplement angler
	local rename_on_attach = function(client, bufnr)
		local bufopts = { noremap = true, silent = true, buffer = bufnr }
		km("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
		base_on_attach(client, bufnr)
	end
	local on_attach = function(client, bufnr)
		base_on_attach(client, bufnr)
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

	-- if server_enabled("tsserver") then
	-- 	local ts_config = {
	-- 		capabilities = capabilities,
	-- 		on_attach = rename_on_attach,
	-- 		filetypes = ts_ft,
	-- 		separate_diagnostic_server = true,
	-- 		tsserver_max_memory = "auto",
	-- 		code_lens = "all",
	-- 		settings = {
	-- 			tsserver_file_preferences = {
	-- 				includeInlayParameterNameHints = "all",
	-- 				includeInlayParameterNameHintsWhenArgumentMatchesName = false,
	-- 				includeInlayFunctionParameterTypeHints = false,
	-- 				includeInlayVariableTypeHints = false,
	-- 				includeInlayVariableTypeHintsWhenTypeMatchesName = false,
	-- 				includeInlayPropertyDeclarationTypeHints = true,
	-- 				includeInlayFunctionLikeReturnTypeHints = true,
	-- 				includeInlayEnumMemberValueHints = true,
	-- 				includeCompletionsForModuleExports = true,
	-- 				quotePreference = "auto",
	-- 			},
	-- 			tsserver_format_options = {
	-- 				allowIncompleteCompletions = true,
	-- 				allowRenameOfImportPath = true,
	-- 			},
	-- 			tsserver_plugins = {
	-- 				"@vue/typescript-plugin",
	-- 			},
	-- 		},
	-- 	}
	-- 	require("typescript-tools").setup(ts_config)
	-- end

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
			on_attach = rename_on_attach,
		},
		cssls = {
			capabilities = snippet_capabilities,
			on_attach = on_attach,
			filetypes = css_ft,
		},
		html = {
			capabilities = snippet_capabilities,
			on_attach = on_attach,
			filetypes = html_ft,
		},
		cssmodules_ls = {
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = vue_ft,
		},
		-- volar = {
		-- 	capabilities = capabilities,
		-- 	on_attach = rename_on_attach,
		-- 	filetypes = vue_ft,
		-- 	init_options = {
		-- 		vue = {
		-- 			hybridMode = false,
		-- 		},
		-- 	},
		-- },
		tsserver = {
			capabilities = capabilities,
			on_attach = rename_on_attach,
			-- filetypes = ts_ft,
			filetypes = vue_ft,
			-- init_options = {
			-- 	plugins = {
			-- 		{
			-- 			"@vue/typescript-plugin",
			-- 			location = "node_modules/@vue/typescript-plugin",
			-- 			languages = { "vue" },
			-- 		},
			-- 	},
			-- },
		},
		volar = {
			capabilities = capabilities,
			on_attach = rename_on_attach,
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
			on_attach = rename_on_attach,
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
			on_attach = rename_on_attach,
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
			on_attach = rename_on_attach,
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
				rename_on_attach(client, bufnr)
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
		"pmizio/typescript-tools.nvim",
		"dmmulroy/ts-error-translator.nvim",
	},
}
