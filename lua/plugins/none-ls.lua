local config = function()
	local null_ls = require("null-ls")

	local d = null_ls.builtins.diagnostics
	local f = null_ls.builtins.formatting
	local md_ft = { filetypes = { "markdown" } }
	local prettier_ft = {
		filetypes = {
			"css",
			"html",
			"javascript",
			"json",
			"jsonc",
			"markdown",
			"scss",
			"typescript",
			"typescriptreact",
			"vue",
		},
		disabled_filetypes = {
			"lua",
			"yaml",
			-- "csharp"
		},
	}
	local biome_ft = {
		filetypes = {
			-- "lua",
			-- "javascript",
			-- "typescript",
			-- "typescriptreact",
			-- "vue",
		},
	}
	local rustywind_ft = {
		filetypes = {
			"html",
			"javascript",
			"typescript",
			"typescriptreact",
			"vue",
		},
	}
	local cs_ignore = {
		extra_args = { "--ignore-words=~/.config/codespell/ignore_words" },
	}

	local sources = {
		require("none-ls.diagnostics.eslint_d"),
		d.codespell.with(cs_ignore),
		d.fish,
		d.hadolint,
		d.markdownlint.with(md_ft),
		f.shfmt,
		f.cbfmt.with(md_ft),
		require("none-ls.formatting.beautysh"),
		-- f.markdownlint.with(md_ft),
		f.codespell.with(cs_ignore),
		f.prettierd.with(prettier_ft),
		-- f.biome.with(biome_ft),
		f.rustywind.with(rustywind_ft),
		f.stylua.with({ filetypes = { "lua" } }),
		f.yamlfmt.with({ filetypes = { "yaml" } }),
		f.fish_indent,
		f.shellharden,
		-- require("typescript.extensions.null-ls.code-actions"),
	}

	null_ls.setup({
		sources = sources,
		should_attach = function(bufnr)
			return not vim.api.nvim_buf_get_name(bufnr):match(".env$")
		end,
		on_init = function(new_client, _)
			new_client.offset_encoding = "utf-16"
		end,
		temp_dir = "/tmp",
	})

	null_ls.register(require("none-ls-shellcheck.diagnostics"))
	null_ls.register(require("none-ls-shellcheck.code_actions"))
end

return {
	"nvimtools/none-ls.nvim",
	config = config,
	event = "BufReadPre",
	dependencies = {
		"gbprod/none-ls-shellcheck.nvim",
		"nvimtools/none-ls-extras.nvim",
	},
}
