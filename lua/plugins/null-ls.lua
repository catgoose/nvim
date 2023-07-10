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
		},
		disabled_filetypes = { "lua", "yaml" },
	}
	local rustywind_ft = { filetypes = { "html", "javascript", "typescript", "typescriptreact" } }

	local sources = {
		ca.eslint_d,
		ca.refactoring,
		ca.shellcheck,
		d.eslint_d,
		d.fish,
		d.hadolint,
		d.jsonlint,
		d.markdownlint.with(md_ft),
		d.shellcheck,
		d.tsc,
		f.cbfmt.with(md_ft),
		f.fish_indent,
		f.fixjson,
		f.markdownlint.with(md_ft),
		f.prettierd.with(prettier_ft),
		f.rustfmt,
		f.rustywind.with(rustywind_ft),
		f.stylua.with({ filetypes = { "lua" } }),
		f.yamlfmt.with({ filetypes = { "yaml" } }),
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
	"jose-elias-alvarez/null-ls.nvim",
	config = config,
	event = "BufReadPre",
}
