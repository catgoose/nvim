local dev = true and not vim.g.lightweight
local e = vim.tbl_extend

local config = function()
  local w = require("wildest")
  local wlog = require("wildest.log")

  wlog.clear()

  vim.keymap.set("n", "<leader>k", function()
    wlog.flush()
    vim.notify("Flushed " .. wlog.path(), vim.log.levels.INFO)
  end, { desc = "Wildest: flush log" })

  w.on("accept", function(_ctx, candidate)
    if type(candidate) == "string" and candidate ~= "" then
      w.frecency_visit(candidate)
    end
  end)

  w.setup({
    modes = { ":", "/", "?" },
    next_key = { "<C-j>", "<Down>" },
    previous_key = { "<C-k>", "<Up>" },
    mark_key = "<Tab>",
    unmark_key = "<S-Tab>",
    accept_key = "<C-l>",
    reject_key = "<C-h>",
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
      ["<C-o>"] = "open_marked",
      ["<C-d>"] = "delete_marked_buffers",
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
      w.substitute_pipeline({ engine = "fast" }),
      w.search_pipeline({ engine = "fast" })
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
          w.popupmenu_frecency_bar({ dim_char = "▎" }),
          " ",
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
        margin = "before_cursor",
        bottom = {
          w.popupmenu_statusline(),
        },
      }),
      ["/"] = w.popupmenu_border_theme({
        border = "rounded",
        title = " Search ",
        fixed_height = false,
        margin = 0,
        highlighter = w.fzy_highlighter(),
        left = { w.popupmenu_frecency_bar({ dim_char = "▎" }), " " },
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
        min_width = "100%",
        max_width = "100%",
      }),
      ["?"] = w.popupmenu_border_theme({
        border = "rounded",
        title = " Search ",
        fixed_height = false,
        margin = 0,
        highlighter = w.fzy_highlighter(),
        left = { w.popupmenu_frecency_bar({ dim_char = "▎" }), " " },
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
        min_width = "100%",
        max_width = "100%",
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
    build = "make -C csrc",
  })
end
