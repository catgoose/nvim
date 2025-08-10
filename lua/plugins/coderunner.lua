local dev = false
local e = vim.tbl_extend
local m = require("util").lazy_map

local opts = {
  dev = dev,
  langs = {
    cpp = {
      { "clear" },
      { "compiledb make", { "[#ask]", "compiledb args" } },
      { { "[#ask]", "Command to run after make" } },
    },
    cs = {
      { "clear" },
      { "dotnet run" },
    },
    typescript = {
      { "clear" },
      { "ts-node", "[#file]" },
    },
    javascript = {
      { "clear" },
      { "node", "[#file]" },
    },
    fish = {
      { "clear" },
      { "fish", "[#file]" },
    },
    go = {
      { "clear" },
      { "go", "run", "[#file]" },
    },
    sh = {
      { "clear" },
      { "[#file]" },
    },
  },
  scale = 0.25,
}

local plugin = {
  opts = opts,
  cmd = {
    "Coderunner",
    "CoderunnerHorizontal",
    "CoderunnerVertical",
  },
  keys = {
    m("<leader>C", function()
      vim.g.catgoose_terminal_enable_startinsert = 0
      vim.cmd("Coderunner")
    end),
  },
}

if dev == true then
  return e("keep", plugin, {
    dir = "~/git/coderunner.nvim",
    lazy = false,
  })
else
  return e("keep", plugin, {
    "catgoose/coderunner.nvim",
    config = true,
    event = "BufReadPre",
  })
end
