local m = require("util").lazy_map
local c = require("util").create_cmd

local opts = {
	formatters_by_ft = {
		css = { "prettierd" },
		html = { "prettierd" },
		javascript = { "prettierd" },
		json = { "prettierd" },
		jsonc = { "prettierd" },
		lua = { "stylua" },
		scss = { "prettierd" },
		typescript = { "prettierd" },
		vue = { "prettierd" },
		fish = { "fish_indent" },
		--  TODO: 2024-04-12 - test beautysh for sh and bash
		-- sh = { "shfmt", "shellharden" },
		-- bash = { "shfmt", "shellharden" },
		sh = { "beautysh", "shellharden" },
		bash = { "beautysh", "shellharden" },
		-- markdown = { "prettierd", "cbfmt", "markdownlint" },
		markdown = { "cbfmt", "prettierd" },
	},
	format_on_save = function(bufnr)
		if vim.b[bufnr].disable_autoformat or vim.g.disable_autoformat then
			return
		end
		return { timeout_ms = 500, lsp_fallback = true }
	end,
	formatters = {
		shfmt = {
			prepend_args = { "-i", "2" },
		},
		shellharden = {
			prepend_args = { "--transform" },
		},
		cbfmt = {
			prepend_args = { "--config", os.getenv("HOME") .. "/.config/cbfmt/cbfmt.toml" },
		},
	},
}

local function init()
	local function get_level(args)
		return args.bang and "g" or "b"
	end
	local function notify(args)
		local level = get_level(args)
		require("notify").notify(
			string.format(
				"Auto formatting %s %s",
				vim[level].disable_autoformat and "enabled" or "disabled",
				level == "b" and string.format("for buffer id: %s", vim.api.nvim_get_current_buf()) or "globally"
			),
			vim.log.levels.info,
			{ title = "conform.nvim formatting" }
		)
	end
	c("ConformFormatToggle", function(args)
		notify(args)
		local level = get_level(args)
		vim[level].disable_autoformat = not vim[level].disable_autoformat
	end, {
		bang = true,
	})
end

return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	opts = opts,
	cmd = { "ConformInfo" },
	keys = {
		m("<leader>ci", [[ConformInfo]]),
	},
	init = init,
}
