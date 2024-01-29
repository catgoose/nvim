local config = function()
	local null_ls = require("null-ls")

	local ca = null_ls.builtins.code_actions
	local d = null_ls.builtins.diagnostics
	local f = null_ls.builtins.formatting
	local md_ft = { filetypes = { "markdown", "vimwiki" } }
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
		disabled_filetypes = { "lua", "yaml", "csharp" },
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
		ca.eslint_d,
		ca.refactoring,
		ca.shellcheck,
		d.codespell.with(cs_ignore),
		d.clang_check,
		d.eslint_d,
		d.fish,
		d.hadolint,
		d.jsonlint,
		d.markdownlint.with(md_ft),
		d.misspell,
		d.shellcheck,
		d.tsc,
		f.autopep8,
		f.beautysh,
		f.black,
		f.cbfmt.with(md_ft),
		f.markdownlint.with(md_ft),
		f.codespell.with(cs_ignore),
		f.prettierd.with(prettier_ft),
		f.rustywind.with(rustywind_ft),
		f.stylua.with({ filetypes = { "lua" } }),
		f.yamlfmt.with({ filetypes = { "yaml" } }),
		f.clang_format,
		f.fish_indent,
		f.fixjson,
		f.reorder_python_imports,
		f.shellharden,
		f.erb_format,
		require("typescript.extensions.null-ls.code-actions"),
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
end

return {
	"nvimtools/none-ls.nvim",
	config = config,
	event = "BufReadPre",
}
