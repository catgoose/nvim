local M = {}

M.eslint_d = function()
	local eslint_d = {
		name = "eslint_d",
		meta = {
			url = "https://github.com/mantoni/eslint_d.js/",
			description = "Like ESLint, but faster.",
			notes = {
				"Once spawned, the server will continue to run in the background. This is normal and not related to null-ls. You can stop it by running `eslint_d stop` from the command line.",
			},
		},
		command = "eslint_d",
	}
	return eslint_d
end

M.beauty_sh = function()
	local h = require("null-ls.helpers")
	local methods = require("null-ls.methods")

	local FORMATTING = methods.internal.FORMATTING

	return h.make_builtin({
		name = "beautysh",
		meta = {
			url = "https://github.com/lovesegfault/beautysh",
			description = "A Bash beautifier for the masses.",
			notes = { "In addition to Bash, Beautysh can format csh, ksh, sh and zsh." },
		},
		method = FORMATTING,
		filetypes = { "bash", "csh", "ksh", "sh", "zsh" },
		generator_opts = { command = "beautysh", args = { "$FILENAME" }, to_temp_file = true },
		factory = h.formatter_factory,
	})
end

return M
