vim.cmd([[let g:neo_tree_remove_legacy_commands = 1]])

require("config.utils").plugin_setup("neo-tree", {
	sources = {
		"filesystem",
		"diagnostics",
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
	diagnostics = {
		bind_to_cwd = true,
		diag_sort_function = "severity",
		follow_behavior = {
			always_focus_file = false,
			expand_followed = true,
			collapse_others = true,
		},
		follow_current_file = true,
		group_dirs_and_files = true,
		group_empty_dirs = true,
		show_unloaded = true,
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
			["h"] = "close_node",
			["O"] = "close_node",
			["j"] = "next",
			["k"] = "prev",
			["gg"] = "first",
			["G"] = "last",
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
})
