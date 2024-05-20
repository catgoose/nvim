local m = require("util").lazy_map

local opts = {
  disable_line_numbers = false,
  integrations = {
    diffview = true,
    telescope = true,
  },
  graph_style = "unicode",
  commit_editor = {
    kind = "tab",
    show_staged_diff = true,
  },
}

return {
  "NeogitOrg/neogit",
  opts = opts,
  config = function()
    local ng = require("neogit")
    ng.setup(opts)
    local neogit_files = { "NeogitStatus", "NeogitPopup" }
    local u = require("util")
    local augroup = u.create_augroup
    local autocmd = vim.api.nvim_create_autocmd
    local neogit = augroup("NeogitCustom")
    autocmd({ "WinEnter", "FileType" }, {
      group = neogit,
      pattern = neogit_files,
      callback = function()
        vim.o.cmdheight = 1
      end,
    })
    autocmd({ "WinLeave" }, {
      group = neogit,
      pattern = neogit_files,
      callback = function()
        u.restore_cmdheight()
      end,
    })
    autocmd({ "User" }, {
      pattern = "NeogitPushComplete",
      group = neogit,
      callback = function()
        require("neogit").close()
      end,
    })
  end,
  lazy = true,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
  },
  cmd = { "Neogit" },
  keys = {
    m("<leader>G", "Neogit"),
    m("<leader>gl", "Neogit kind=vsplit"),
  },
}
