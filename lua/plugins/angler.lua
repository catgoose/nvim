local dev = true
local e = vim.tbl_extend
local m = require("util").lazy_map

local opts = {
	dev = dev,
}

local angler_str = [[lua require("angler")]]

local plugin = {
	opts = opts,
	keys = {
		m("<leader>z", [[Lazy reload angler.nvim]]),
		m("<leader>gc", angler_str .. [[.open({extension = "ts"})]]),
		m("<leader>gh", angler_str .. [[.open({extension = "html"})]]),
		m("<leader>gt", angler_str .. [[.open({extension = "html", split = true})]]),
		m("<leader>gd", angler_str .. [[.open({extension = "scss"})]]),
		m("<leader>gs", angler_str .. [[.open({extension = "scss", split = true})]]),
		m("<leader>gf", angler_str .. [[.open({extension = "spec.ts"})]]),
		m("gn", [[AnglerOpenNext]]),
		m("gp", [[AnglerOpenPrev]]),
		m("<leader>tc", [[AnglerCompile]]),
		m("<leader>tf", [[AnglerRenameFile]]),
		m("<leader>k", [[AnglerFixAll]]),
	},
	ft = { "typescript", "vue" },
	dependencies = "jose-elias-alvarez/typescript.nvim",
}

if dev == true then
	return e("keep", plugin, {
		dir = "~/git/angler.nvim",
		lazy = false,
	})
else
	return e("keep", plugin, {
		"catgoose/angler.nvim",
	})
end
