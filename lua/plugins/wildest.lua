local dev = false
local e = vim.tbl_extend

local config = function()
  local w = require("wildest")

  w.setup({
    modes = { ":", "/", "?" },
    next_key = "<Tab>",
    previous_key = "<S-Tab>",
    accept_key = "<Down>",
    reject_key = "<Up>",
    noselect = true,
    longest_prefix = true,
    pipeline_timeout = 5000,

    pipeline = w.branch(
      -- Branch 1: Short input → history + fuzzy
      {
        w.check(function(ctx, _)
          return #ctx.input < 2
        end),
        require("wildest.pipeline.history").history(),
        w.fuzzy_filter(),
      },
      -- Branch 2: :lua and := → lua completion
      w.lua_pipeline(),
      -- Branch 3: :help → help tags
      w.help_pipeline({ fuzzy = true }),
      -- Branch 4: :buf/:b → buffer names
      w.buffer_pipeline({ fuzzy = true }),
      -- Branch 5: file finder for :e, :sp, :vs etc.
      w.file_finder_pipeline({
        file_command = function(_, arg)
          if string.find(arg, ".") ~= nil then
            return { "fdfind", "-tf", "-H" }
          else
            return { "fdfind", "-tf" }
          end
        end,
        dir_command = { "fdfind", "-td" },
      }),
      -- Branch 6: :s/pattern/ substitute
      w.substitute_pipeline(),
      -- Branch 7: general cmdline completion (catch-all for :)
      w.cmdline_pipeline({ fuzzy = true }),
      -- Branch 8: search mode / and ?
      w.search_pipeline()
    ),

    renderer = w.renderer_mux({
      [":"] = w.popupmenu_palette_theme({
        border = "rounded",
        title = " Wildest ",
        fixed_height = false,
        prompt_prefix = " :",
        empty_message = " No matches ",
        highlighter = w.fzy_highlighter(),
        left = {
          "  ",
          w.popupmenu_devicons(),
          w.popupmenu_buffer_flags({
            flags = " a + ",
            icons = { ["+"] = "", a = "", h = "" },
          }),
        },
        right = {
          "  ",
          w.popupmenu_scrollbar(),
        },
        highlights = {
          border = "Normal",
          selected = "PmenuSel",
          accent = "PmenuSel",
          default = "Pmenu",
        },
        pumblend = 4,
        min_height = 0,
        max_height = "50%",
        min_width = "50%",
        max_width = "50%",
        prompt_position = "bottom",
        margin = "15%",
      }),
      ["/"] = w.popupmenu_border_theme({
        border = "rounded",
        title = " Search ",
        fixed_height = false,
        highlighter = w.fzy_highlighter(),
        left = {
          "  ",
        },
        right = {
          "  ",
          w.popupmenu_scrollbar(),
        },
        highlights = {
          border = "Normal",
          selected = "PmenuSel",
          accent = "PmenuSel",
          default = "Pmenu",
        },
        pumblend = 4,
        min_height = 0,
        max_height = "50%",
        min_width = "25%",
        max_width = "25%",
      }),
      ["?"] = w.popupmenu_border_theme({
        border = "rounded",
        title = " Search ",
        fixed_height = false,
        highlighter = w.fzy_highlighter(),
        left = {
          "  ",
        },
        right = {
          "  ",
          w.popupmenu_scrollbar(),
        },
        highlights = {
          border = "Normal",
          selected = "PmenuSel",
          accent = "PmenuSel",
          default = "Pmenu",
        },
        pumblend = 4,
        min_height = 0,
        max_height = "50%",
        min_width = "25%",
        max_width = "25%",
      }),
    }),
  })
end

local plugin = {
  build = "make -C csrc",
  config = config,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  lazy = false,
  enabled = true,
}

if dev == true then
  return e("keep", plugin, {
    dir = "~/git/wildest.nvim",
  })
else
  return e("keep", plugin, {
    "catgoose/wildest.nvim",
  })
end
