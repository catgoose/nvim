local fn, cmd = vim.fn, vim.cmd

local M = {}

M.toggle_fold = function()
	local foldclosed = vim.fn.foldclosed(vim.fn.line("."))
	if foldclosed == -1 then
		cmd("silent! normal! zc")
	else
		cmd("silent! normal! zo")
		-- vim.o.statuscolumn = ""
		-- vim.o.statuscolumn = "%!v:lua.StatusCol()"
	end
end

M.handler = function(virtText, lnum, endLnum, width, truncate)
	local newVirtText = {}
	local suffix = ("  %d "):format(endLnum - lnum)
	local sufWidth = fn.strdisplaywidth(suffix)
	local targetWidth = width - sufWidth
	local curWidth = 0
	for _, chunk in ipairs(virtText) do
		local chunkText = chunk[1]
		local chunkWidth = fn.strdisplaywidth(chunkText)
		if targetWidth > curWidth + chunkWidth then
			table.insert(newVirtText, chunk)
		else
			chunkText = truncate(chunkText, targetWidth - curWidth)
			local hlGroup = chunk[2]
			table.insert(newVirtText, { chunkText, hlGroup })
			chunkWidth = fn.strdisplaywidth(chunkText)
			if curWidth + chunkWidth < targetWidth then
				suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
			end
			break
		end
		curWidth = curWidth + chunkWidth
	end
	table.insert(newVirtText, { suffix, "UfoFoldedVirtText" })
	return newVirtText
end

return M
