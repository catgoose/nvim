local opts = {
	auto_enable = true,
	enable_incsearch = true,
	nearest_only = false,
	nearest_float_when = "auto",
	float_shadow_blend = 50,
	virt_priority = 100,
	override_lens = function(render, posList, nearest, idx, relIdx)
		local sfw = vim.v.searchforward == 1
		local indicator, text, chunks
		local absRelIdx = math.abs(relIdx)
		if absRelIdx > 1 then
			indicator = ("%d%s"):format(absRelIdx, sfw ~= (relIdx > 1) and "▲" or "▼")
		elseif absRelIdx == 1 then
			indicator = sfw ~= (relIdx == 1) and "▲" or "▼"
		else
			indicator = ""
		end
		local lnum, col = unpack(posList[idx])
		if nearest then
			local cnt = #posList
			if indicator ~= "" then
				text = ("[%s %d/%d]"):format(indicator, idx, cnt)
			else
				text = ("[%d/%d]"):format(idx, cnt)
			end
			chunks = { { " ", "Ignore" }, { text, "HlSearchLensNear" } }
		else
			text = ("[%s %d]"):format(indicator, idx)
			chunks = { { " ", "Ignore" }, { text, "HlSearchLens" } }
		end
		render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
	end,
	-- build_position_cb = function(plist, _, _, _)
	-- require("scrollbar.handlers.search").handler.show(plist.start_pos)
	-- end,
}

return {
	"kevinhwang91/nvim-hlslens",
	opts = opts,
	event = "BufReadPre",
	keys = {
		{
			"n",
			[[<cmd>execute('normal! ' . v:count1 . 'n')<cr>]] .. [[<cmd>lua require("hlslens").start()<cr>]],
		},
		{
			"N",
			[[<cmd>execute('normal! ' . v:count1 . 'N')<cr>]] .. [[<cmd>lua require("hlslens").start()<cr>]],
		},
		{ "*", "*" .. [[<cmd>lua require("hlslens").start()<cr>]] },
		{ "#", "#" .. [[<cmd>lua require("hlslens").start()<cr>]] },
		{ "g*", "g*" .. [[<cmd>lua require("hlslens").start()<cr>]] },
		{ "g#", "g#" .. [[<cmd>lua require("hlslens").start()<cr>]] },
	},
}
