-- local opts = {
-- 	disable_filetype = { "TelescopePrompt" },
-- }

-- return {
-- 	"windwp/nvim-autopairs",
-- 	opts = opts,
-- 	event = "InsertEnter",
-- }

return {
	"altermo/ultimate-autopair.nvim",
	event = { "InsertEnter", "CmdlineEnter" },
	-- branch = "v0.6", --recommended as each new version will have breaking changes
	opts = {
		--Config goes here
	},
}
