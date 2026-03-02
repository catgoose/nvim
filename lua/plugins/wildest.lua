local dev = true
local e = vim.tbl_extend

local config = function()
  local w = require("wildest")

  w.setup({
    modes = { ":", "/", "?" },
    next_key = { "<Tab>", "<C-j>" },
    previous_key = { "<S-Tab>", "<C-k>" },
    accept_key = "<Down>",
    reject_key = "<Up>",
    scroll_down_key = "<C-f>",
    scroll_up_key = "<C-b>",
    scroll_size = 10,
    close_key = "<C-e>",
    confirm_key = "<C-y>",
    jump_keys = {
      { "<C-n>", 5 },
      { "<C-p>", -5 },
    },
    actions = {
      ["<C-s>"] = "open_split",
      ["<C-v>"] = "open_vsplit",
      ["<C-t>"] = "open_tab",
      ["<C-q>"] = "send_to_quickfix",
      ["<C-x>"] = "toggle_preview",
    },
    preview = {
      enabled = true,
      position = "right",
      anchor = "screen",
      width = "40%",
      height = "50%",
      border = "rounded",
      max_lines = 500,
      title = true,
    },
    noselect = true,
    longest_prefix = true,
    pipeline_timeout = 5000,
    pipeline = w.branch(
      {
        w.check(function(ctx, _)
          return #ctx.input < 2
        end),
        require("wildest.pipeline.history").history(),
        w.frecency_boost({ blend = 0.4 }),
        w.fuzzy_filter(),
      },
      w.lua_pipeline(),
      w.help_pipeline({ fuzzy = true }),
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
      w.cmdline_pipeline({ fuzzy = true }),
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
          accent = "IncSearch",
          selected_accent = "IncSearch",
          default = "Pmenu",
        },
        pumblend = 4,
        min_height = 10,
        max_height = 25,
        min_width = "50%",
        max_width = "50%",
        prompt_position = "bottom",
        margin = "auto",
      }),
      ["/"] = w.popupmenu_border_theme({
        border = "rounded",
        title = " Search ",
        fixed_height = false,
        highlighter = w.fzy_highlighter(),
        left = { "  " },
        right = { "  ", w.popupmenu_scrollbar() },
        highlights = {
          border = "Normal",
          selected = "PmenuSel",
          accent = "IncSearch",
          selected_accent = "IncSearch",
          default = "Pmenu",
        },
        pumblend = 4,
        min_height = 10,
        max_height = 25,
        min_width = "25%",
        max_width = "25%",
      }),
      ["?"] = w.popupmenu_border_theme({
        border = "rounded",
        title = " Search ",
        fixed_height = false,
        highlighter = w.fzy_highlighter(),
        left = { "  " },
        right = { "  ", w.popupmenu_scrollbar() },
        highlights = {
          border = "Normal",
          selected = "PmenuSel",
          accent = "IncSearch",
          selected_accent = "IncSearch",
          default = "Pmenu",
        },
        pumblend = 4,
        min_height = 10,
        max_height = 25,
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
