local k, l, api = vim.keymap.set, vim.lsp, vim.api

local config = function()
	local m = require("util").cmd_map

	local lspc = require("lspconfig")
	local ts = require("typescript")
	local rt = require("rust-tools")
	local ih = require("inlay-hints")
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
	local no_formatting_on_attach = function(client, _)
		client.server_capabilities.documentFormattingProvider = false
	end
	local virtual_types_on_attach = function(client, bufnr)
		if client.server_capabilities.textDocument then
			if client.server_capabilities.textDocument.codeLens then
				vt.on_attach(client, bufnr)
			end
		end
	end
	local on_attach = function(client, bufnr)
		keys_on_attach(client, bufnr)
		no_formatting_on_attach(client, bufnr)
		virtual_types_on_attach(client, bufnr)
	end

	-- LSP config
	ts.setup({
		capabilities = capabilities,
		disable_commands = false,
		debug = false,
		server = {
			on_attach = function(client, bufnr)
				on_attach(client, bufnr)
				m("<leader>rn", "AnglerRenameSymbol", "n", { noremap = true, silent = true, buffer = bufnr })
				client.server_capabilities.renameProvider = true
			end,
		},
	})

	rt.setup({
		server = {
			on_attach = function(client, bufnr)
				on_attach(client, bufnr)
				ih.on_attach(client, bufnr)
				vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
				vim.keymap.set("n", "<leader>u", rt.code_action_group.code_action_group, { buffer = bufnr })
			end,
		},
		tools = {
			on_initialized = function()
				ih.set_all()
			end,
			inlay_hints = {
				auto = false,
			},
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
			ih.on_attach(client, bufnr)
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
		capabilities = capabilities,
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
		"awk_ls",
		"bashls",
		"cmake",
		"cssmodules_ls",
		"docker_compose_language_service",
		"dockerls",
		"jedi_language_server",
		"marksman",
		"neocmake",
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
	lspc.diagnosticls.setup({
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
	clangd_ext.setup({
		server = {
			capabilities = capabilities,
			on_attach = on_attach,
		},
	})

	local lang_servers_snippet_support = {
		"html",
		"cssls",
	}
	for _, lang in pairs(lang_servers_snippet_support) do
		local snippet_capabilities = l.protocol.make_client_capabilities()
		snippet_capabilities.textDocument.completion.completionItem.snippetSupport = true
		local extended_capabilities = vim.tbl_extend("keep", capabilities, snippet_capabilities)
		lspc[lang].setup({
			capabilities = extended_capabilities,
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
		"simrat39/rust-tools.nvim",
		"p00f/clangd_extensions.nvim",
		"jubnzv/virtual-types.nvim",
	},
}
