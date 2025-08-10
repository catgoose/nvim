local dev = false
local enabled = true
local e = vim.tbl_extend
local project = require("util.project")

local opts = {
  -- log_level = "trace",
  -- log_level = "debug",
  filters = {
    auto_imports = true,
    auto_components = true,
    import_same_file = true,
    declaration = true,
    duplicate_filename = true,
  },
  detection = {
    nuxt = function()
      return vim.fn.glob(".nuxt/") ~= ""
    end,
    vue3 = function()
      return vim.fn.filereadable("vite.config.ts") == 1 or vim.fn.filereadable("src/App.vue") == 1
    end,
    priority = { "nuxt", "vue3" },
  },
  lsp = {
    override_definition = true,
  },
}

local keys = project.get_keys("vue-goto-definition")

local plugin = {
  dependencies = "nvim-lua/plenary.nvim",
  keys = keys,
  opts = opts,
  enabled = enabled,
}

if dev == true then
  return e("keep", plugin, {
    dir = "~/git/vue-goto-definition.nvim",
    lazy = false,
  })
else
  return e("keep", plugin, {
    "catgoose/vue-goto-definition.nvim",
    event = "BufReadPre",
  })
end
