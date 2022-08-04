local null_ls = require("config.utils").require_plugin("null-ls")

local code_actions = null_ls.builtins.code_actions
local completion = null_ls.builtins.completion
local diagnostics = null_ls.builtins.diagnostics
local formatting = null_ls.builtins.formatting

local md_files = { filetypes = { "markdown", "vimwiki" } }
local cs_ignore = {
	extra_args = { "--ignore-words=~/.config/codespell/ignore_words" },
}

null_ls.setup({
	sources = {
		code_actions.eslint,
		code_actions.refactoring,
		completion.luasnip,
		diagnostics.eslint_d,
		diagnostics.codespell.with(cs_ignore),
		diagnostics.fish,
		diagnostics.hadolint,
		diagnostics.jsonlint,
		diagnostics.markdownlint.with(md_files),
		diagnostics.misspell,
		formatting.beautysh,
		formatting.cbfmt.with(md_files),
		formatting.codespell.with(cs_ignore),
		formatting.fish_indent,
		formatting.fixjson,
		formatting.markdownlint.with(md_files),
		formatting.prettierd,
		formatting.stylua,
	},
})
