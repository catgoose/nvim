local keybinding, l, api = vim.keymap.set, vim.lsp, vim.api

local server_enabled = function(server)
	return not require("neoconf").get("lsp.servers." .. server .. ".disable")
end

local config = function()
	local lspconfig = require("lspconfig")
	local clangd_ext = require("clangd_extensions")
	local vt = require("virtualtypes")
	-- local ts = require("typescript")

	local capabilities = vim.tbl_deep_extend(
		"force",
		vim.lsp.protocol.make_client_capabilities(),
		require("cmp_nvim_lsp").default_capabilities()
	)

	--  ufo
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
			-- source = "always",
			header = "",
			prefix = "",
		},
	})

	-- Handlers
	l.handlers["textDocument/hover"] = l.with(l.handlers.hover, {
		border = "rounded",
	})
	l.handlers["textDocument/signatureHelp"] = l.with(l.handlers.signature_help, {
		border = "rounded",
	})

	-- global keybindings
	local opts = { noremap = true, silent = true }
	keybinding("n", "[g", vim.diagnostic.goto_prev, opts)
	keybinding("n", "]g", vim.diagnostic.goto_next, opts)
	keybinding("n", "<leader>dd", vim.diagnostic.setqflist, opts)

	-- buf keybindings
	local keys_on_attach = function(_, bufnr)
		local bufopts = { noremap = true, silent = true, buffer = bufnr }
		keybinding("n", "gD", l.buf.declaration, bufopts)
		keybinding("n", "gd", l.buf.definition, bufopts)
		keybinding("n", "gi", l.buf.implementation, bufopts)
		keybinding("n", "<leader>D", l.buf.type_definition, bufopts)
		keybinding("n", "gr", l.buf.references, bufopts)
		keybinding({ "n", "v" }, "<leader>ca", l.buf.code_action, bufopts)
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
	local rename_on_attach = function(client, bufnr)
		keybinding("n", "<leader>rn", vim.lsp.buf.rename, opts)
		base_on_attach(client, bufnr)
	end
	local on_attach = function(client, bufnr)
		base_on_attach(client, bufnr)
	end

	-- LSP config

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
			filetypes = { "css", "scss", "less", "sass", "vue" },
		},
		html = {
			capabilities = snippet_capabilities,
			on_attach = on_attach,
			filetypes = { "html", "vue" },
		},
		cssmodules_ls = {
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
		},
		tsserver = {
			capabilities = capabilities,
			on_attach = rename_on_attach,
			init_options = {
				plugins = {
					{
						name = "@vue/typescript-plugin",
						location = "node_modules/@vue/typescript-plugin",
						languages = {
							--  TODO: 2024-03-20 - build this based on neoconf vue detection
							"typescript",
							"javascript",
							"vue",
						},
					},
				},
			},
			filetypes = {
				"typescript",
				"javascript",
				"vue",
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
	if server_enabled("clangd") then
		clangd_ext.setup({
			server = {
				capabilities = capabilities,
				on_attach = on_attach,
			},
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
		-- "jose-elias-alvarez/typescript.nvim",
		"williamboman/mason.nvim",
		"b0o/schemastore.nvim",
		"litao91/lsp_lines",
		"kevinhwang91/nvim-ufo",
		"p00f/clangd_extensions.nvim",
		"VidocqH/lsp-lens.nvim",
		"jubnzv/virtual-types.nvim",
		"folke/neoconf.nvim",
		-- "pmizio/typescript-tools.nvim",
	},
}
