local m = require("util").lazy_map

local config = function()
  local ls = require("luasnip")
  local types = require("luasnip.util.types")

  ---@diagnostic disable-next-line: undefined-field
  ls.config.set_config({
    updateevents = "TextChanged,TextChangedI",
    delete_check_events = "TextChanged",
    enable_autosnippets = false,
    ext_opts = {
      [types.choiceNode] = {
        active = {
          virt_text = { { " <- Choice", "Title" } },
        },
      },
    },
    ext_base_prio = 300,
    ext_prio_increase = 1,
    ft_func = function()
      return vim.split(vim.bo.filetype, ".", { plain = true })
    end,
  })

  vim.keymap.set({ "i", "s" }, "<c-k>", function()
    if ls.expand_or_jumpable() then
      ls.expand_or_jump()
    end
  end, { silent = true })

  vim.keymap.set({ "i", "s" }, "<c-j>", function()
    if ls.jumpable(-1) then
      ls.jump(-1)
    end
  end, { silent = true })

  vim.keymap.set("i", "<c-l>", function()
    if ls.choice_active() then
      ls.change_choice(1)
    end
  end)

  local function load()
    ---@diagnostic disable-next-line: assign-type-mismatch
    require("luasnip.loaders.from_lua").load({ paths = vim.fn.stdpath("config") .. "/lua/snippets" })
  end
  load()

  local u = require("util")
  local augroup = u.create_augroup
  local write_source = augroup("LuaSnipWritePostReload")
  vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    group = write_source,
    pattern = "*/nvim/lua/snippets/*.lua",
    callback = function()
      if not u.diag_error() then
        load()
      end
    end,
  })
end

return {
  "L3MON4D3/LuaSnip",
  config = config,
  event = "InsertEnter",
  keys = {
    m("<leader>sn", [[lua require("luasnip.loaders").edit_snippet_files()]]),
  },
}
