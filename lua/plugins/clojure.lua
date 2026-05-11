local conjure_filetypes = {
  "clojure",
  "fennel",
  "scheme",
  "lisp",
  "racket",
  "lua",
}

local function configure_conjure()
  vim.g["conjure#mapping#doc_word"] = false
  vim.g["conjure#filetype#clojure"] = "conjure.client.clojure.nrepl"
  vim.g["conjure#client#clojure#nrepl#connection#auto_repl#enabled"] = false
  vim.g["conjure#log#hud#enabled"] = true
  vim.g["conjure#log#hud#border"] = "rounded"
  vim.g["conjure#extract#tree_sitter#enabled"] = true
end

local function setup_cmp_conjure()
  local ok_cmp, cmp = pcall(require, "cmp")
  if not ok_cmp then
    return
  end
  local existing = cmp.get_config().sources or {}
  local merged = vim.deepcopy(existing)
  table.insert(merged, { name = "conjure", group_index = 4, keyword_length = 2 })
  cmp.setup.buffer({ sources = merged })
end

return {
  {
    "Olical/conjure",
    ft = conjure_filetypes,
    init = configure_conjure,
    dependencies = {
      "PaterJason/cmp-conjure",
    },
    lazy = true,
  },
  {
    "PaterJason/cmp-conjure",
    ft = conjure_filetypes,
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
      local group = vim.api.nvim_create_augroup("cmp_conjure_clojure", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = conjure_filetypes,
        callback = setup_cmp_conjure,
      })
    end,
    lazy = true,
  },
  {
    "julienvincent/nvim-paredit",
    ft = { "clojure", "fennel", "scheme", "lisp", "racket" },
    opts = function()
      local api = require("nvim-paredit.api")
      return {
        use_default_keys = true,
        indent = { enabled = true },
        keys = {
          -- Free <localleader>o for <leader>o (oil) since localleader == leader == <Space>.
          ["<localleader>o"] = false,
          ["<localleader>O"] = false,
          ["<localleader>kr"] = { api.raise_form, "Raise form" },
          ["<localleader>kR"] = { api.raise_element, "Raise element" },
        },
      }
    end,
  },
}
