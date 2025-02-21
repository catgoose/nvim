local m = require("util").lazy_map

local opts = {
  scope = "git_branch",
  icons = true,
  status = true,
  win_opts = {
    border = "rounded",
  },
  default_scopes = {
    lsp = false,
    static = false,
  },
}

local function switch(scope, direction)
  return function()
    vim.cmd(("silent! Grapple use_scope %s"):format(scope or "git_branch"))
    vim.cmd(("silent! Grapple cycle_tags %s"):format(direction or "next"))
  end
end

return {
  "cbochs/grapple.nvim",
  opts = opts,
  keys = {
    m("<leader>a", "Grapple toggle"),
    m("<leader>A", "Grapple toggle_scopes"),
    m("<leader>l", "Grapple open_tags"),
    m("<leader>L", "Grapple open_loaded"),
    m("<leader>.", "Grapple cycle_tags next"),
    m("<leader>>", switch("git_branch", "next")),
    m("<leader>,", "Grapple cycle_tags previous"),
    m("<leader><", switch("git", "next")),
  },
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },
}
