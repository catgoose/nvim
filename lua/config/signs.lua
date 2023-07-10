local hl = {
	error = "DiagnosticSignError",
	warn = "DiagnosticSignWarn",
	hint = "DiagnosticSignHint",
	info = "DiagnosticSignInfo",
}

local signs = {
	{ name = hl.error, dict = { text = "", texthl = hl.error } },
	{ name = hl.warn, dict = { text = "", texthl = hl.warn } },
	{ name = hl.hint, dict = { text = "", texthl = hl.hint } },
	{ name = hl.info, dict = { text = "", texthl = hl.info } },
}
for _, sign in ipairs(signs) do
	vim.fn.sign_define(sign.name, sign.dict)
end

return signs
