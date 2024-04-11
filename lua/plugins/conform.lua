local c = require("util").create_cmd

local prettier = {
  "prettierd",
  "prettier",
}
local opts = {
  formatters_by_ft = {
    lua = { "stylua" },
    javascript = { prettier },
    typescript = { prettier },
    vue = { prettier },
  },
  format_on_save = function(bufnr)
    if vim.b[bufnr].disable_autoformat then
      return
    end
    return { timeout_ms = 500, lsp_fallback = true }
  end,
  formatters = {
    shfmt = {
      prepend_args = { "-i", "2" },
    },
  },
}

local function init()
  local function notify()
    require("notify").notify(
      string.format("Auto formatting %s", vim.b.disable_autoformat and "enabled" or "disabled"),
      vim.log.levels.info,
      { title = "conform.nvim formatting" }
    )
  end
  c("ConformFormatDisable", function()
    if not vim.b.disable_autoformat then
      notify()
    end
    vim.b.disable_autoformat = true
  end)
  c("ConformFormatEnable", function()
    if vim.b.disable_autoformat then
      notify()
    end
    vim.b.disable_autoformat = false
  end)
end

return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  opts = opts,
  cmd = { "ConformInfo" },
  init = init,
}
