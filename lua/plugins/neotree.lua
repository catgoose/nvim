local m = require("util").lazy_map

local opts = {
  sources = {
    "filesystem",
  },
  add_blank_line_at_top = false,
  close_if_last_window = true,
  enable_git_status = true,
  enable_diagnostics = true,
  hide_root_node = true,
  retain_hidden_root_indent = true,
  popup_border_style = "rounded",
  source_selector = {
    winbar = true,
    statusline = false,
  },
  window = {
    position = "left",
    mapping_options = {
      noremap = true,
      nowait = true,
    },
    mappings = {
      ["l"] = "open",
      ["o"] = "open",
      ["w"] = "open_with_window_picker",
      ["h"] = "close_node",
      ["O"] = "close_node",
      ["/"] = "fuzzy_finder",
      ["d"] = "fuzzy_finder_directory",
      ["p"] = { "toggle_preview", config = { use_float = true } },
      ["q"] = "close_window",
      ["<Esc>"] = "close_window",
    },
  },
  filesystem = {
    filtered_items = {
      visible = true,
      hide_dotfiles = false,
      hide_gitignored = false,
      hide_by_name = {
        "node_modules",
      },
    },
    follow_current_file = true,
  },
  default_component_configs = {
    container = {
      enable_character_fade = true,
    },
    indent = {
      indent_size = 2,
      padding = 1,
      with_markers = true,
      indent_marker = "│",
      last_indent_marker = "└",
      highlight = "NeoTreeIndentMarker",
      with_expanders = nil,
      expander_collapsed = "",
      expander_expanded = "",
      expander_highlight = "NeoTreeExpander",
    },
    icon = {
      folder_closed = "",
      folder_open = "",
      folder_empty = "ﰊ",
      default = "*",
      highlight = "NeoTreeFileIcon",
    },
    modified = {
      symbol = "[+]",
      highlight = "NeoTreeModified",
    },
    name = {
      trailing_slash = false,
      use_git_status_colors = true,
      highlight = "NeoTreeFileName",
    },
    git_status = {
      symbols = {
        added = "✚",
        modified = "",
        deleted = "✖",
        renamed = "",
        untracked = "",
        ignored = "",
        unstaged = "",
        staged = "",
        conflict = "",
      },
    },
  },
}

return {
  "nvim-neo-tree/neo-tree.nvim",
  init = function() vim.g.neo_tree_remove_legacy_commands = 1 end,
  opts = opts,
  branch = "v2.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
    "s1n7ax/nvim-window-picker",
  },
  cmd = "Neotree",
  keys = {
    m("<leader>m", [[Neotree float toggle]]),
  },
}
