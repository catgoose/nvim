local dev = false
local e = vim.tbl_extend
local m = require("util").lazy_map
local project = require("util.project")

local opts = {
  -- log_level = "debug",
  log_level = "trace",
}

local angler_str = [[lua require("angler")]]

--  TODO: 2024-03-07 - fix AnglerFixAll showing organize imports
-- use https://github.com/pmizio/typescript-tools.nvim instead of current
-- dependency

local keys = {
  -- m("<leader>z", [[Lazy reload angler.nvim]]),
  m("<leader>gc", angler_str .. [[.open({extension = "ts"})]]),
  m("<leader>gh", angler_str .. [[.open({extension = "html"})]]),
  m("<leader>gt", angler_str .. [[.open({extension = "html", split = true})]]),
  m("<leader>gd", angler_str .. [[.open({extension = "scss"})]]),
  m("<leader>gs", angler_str .. [[.open({extension = "scss", split = true})]]),
  m("<leader>gf", angler_str .. [[.open({extension = "spec.ts"})]]),
  m("gn", angler_str .. [[.open_cwd({order = "next"})]]),
  m("gp", angler_str .. [[.open_cwd({order = "prev"})]]),
  m("<leader>tc", [[AnglerCompile]]),
  -- m("<leader>tc", angler_str .. [[.compile()]]),
  -- m("<leader>tf", [[AnglerRenameFile]]),
  m("<leader>rn", [[AnglerRenameSymbol]]),
  m("<leader>k", [[AnglerFixAll]]),
}
keys = project.get_keys("angler", keys)

local plugin = {
  opts = opts,
  keys = keys,
  ft = { "typescript", "vue" },
  dependencies = {
    "jose-elias-alvarez/typescript.nvim",
    "nvim-lua/plenary.nvim",
  },
  enabled = true,
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
