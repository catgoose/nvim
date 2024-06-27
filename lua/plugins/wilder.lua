--  TODO: 2024-06-24 - Move to noice

local config = function()
  require("wilder").setup({
    modes = { ":", "/", "?" },
    next_key = "<Tab>",
    prev_key = "<S-Tab>",
    accept_key = "<Down>",
    reject_key = "<Up>",
    use_vim_remote_plugin = false,
    num_workers = 4,
  })

  vim.cmd([[
  cmap <expr> <C-j> wilder#in_context() ? wilder#next() : "\<C-j>"
  cmap <expr> <C-k> wilder#in_context() ? wilder#previous() : "\<C-k>"
  cmap <expr> <C-n> wilder#in_context() ? wilder#next() : "\<C-n>"
  cmap <expr> <C-p> wilder#in_context() ? wilder#previous() : "\<C-p>"
]])
  local wilder = require("wilder")

  local highlighters = {
    wilder.pcre2_highlighter(),
    wilder.basic_highlighter(),
  }
  local search_pipeline = wilder.python_search_pipeline({
    skip_cmdtype_check = 1,
    pattern = wilder.python_fuzzy_pattern({
      start_at_boundary = 1,
    }),
  })
  wilder.set_option("pipeline", {
    wilder.branch(
      {
        wilder.check(function(ctx, _)
          return #ctx.input < 2
        end),
        wilder.subpipeline(function(_, x)
          return {
            wilder.history(),
            function(ctx, h)
              --
              return wilder.vim_fuzzy_filt(ctx, {}, h, x)
            end,
          }
        end),
      },
      wilder.python_file_finder_pipeline({
        file_command = function(_, arg)
          if string.find(arg, ".") ~= nil then
            return { "fdfind", "-tf", "-H" }
          else
            return { "fdfind", "-tf" }
          end
        end,
        dir_command = { "fdfind", "-td" },
        filters = { "fuzzy_filter", "difflib_sorter" },
      }),
      wilder.substitute_pipeline({ pipeline = search_pipeline }),
      wilder.cmdline_pipeline({
        fuzzy = 0,
        set_pcre2_pattern = 1,
        hide_in_substitute = true,
      }),
      search_pipeline
    ),
  })

  local render_popup = {
    mode = "float",
    highlighter = highlighters,
    left = {
      "  ",
      wilder.popupmenu_devicons(),
      wilder.popupmenu_buffer_flags({
        flags = " a + ",
        icons = { ["+"] = "", a = "", h = "" },
      }),
    },
    right = {
      "  ",
      wilder.popupmenu_scrollbar(),
    },
    highlights = {
      border = "Normal",
      selected = "PmenuSel",
      accent = "PmenuSel",
      default = "Pmenu",
    },
    border = "rounded",
    pumblend = 4,
    min_height = 0,
    max_height = "50%",
    min_width = "25%",
    max_width = "25%",
  }
  local render_popup_border = vim.tbl_deep_extend("force", render_popup, {})
  local render_popup_palette = vim.tbl_deep_extend("force", render_popup, {
    min_width = "50%",
    max_width = "50%",
    prompt_position = "bottom",
    margin = "15%",
  })
  local render_search =
    wilder.popupmenu_renderer(wilder.popupmenu_border_theme(render_popup_border))
  wilder.set_option(
    "renderer",
    wilder.renderer_mux({
      [":"] = wilder.popupmenu_renderer(wilder.popupmenu_palette_theme(render_popup_palette)),
      ["/"] = render_search,
      substitute = render_search,
    })
  )
end

return {
  "gelguy/wilder.nvim",
  config = config,
  event = "CmdlineEnter",
  keys = { "/", "?", ":" },
  build = ":UpdateRemotePlugins",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  enabled = true,
}
