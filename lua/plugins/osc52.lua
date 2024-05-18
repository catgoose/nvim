local api, v = vim.api, vim.v

local opts = {
  silent = true,
}

--  TODO: 2024-05-18 - Get 0.10 osc52 working

return {
  "ojroques/nvim-osc52",
  event = "BufReadPre",
  opts = opts,
  init = function()
    local au_copy = function()
      if v.event.operator == "y" and v.event.regname == "+" then
        require("osc52").copy_register("+")
      end
      if v.event.operator == "y" and v.event.regname == "" then
        require("osc52").copy_register("")
      end
    end
    api.nvim_create_autocmd("TextYankPost", { callback = au_copy })
  end,
  enabled = true,
}
