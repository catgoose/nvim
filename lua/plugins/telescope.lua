local m = require("util").lazy_map

local config = function()
	local telescope = require("telescope")
	local actions = require("telescope.actions")
	telescope.setup({
		defaults = {
			prompt_prefix = "> ",
			selection_caret = " ",
			path_display = { truncate = 2 },
			ripgrep_arguments = {
				"rg",
				"--color=never",
				"--no-heading",
				"--with-filename",
				"--line-number",
				"--column",
				"--smart-case",
			},
			dynamic_preview_title = true,
			initial_mode = "insert",
			selection_strategy = "closest",
			sorting_strategy = "descending",
			layout_strategy = "horizontal",
			layout_config = {
				horizontal = {
					prompt_position = "bottom",
					preview_width = 0.4,
					results_width = 0.6,
				},
				vertical = {
					mirror = false,
				},
				width = 0.85,
				height = 0.80,
				preview_cutoff = 120,
			},
			file_sorter = require("telescope.sorters").get_fuzzy_file,
			file_ignore_patterns = { "node_modules", ".git" },
			generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
			winblend = 10,
			border = {},
			borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
			color_devicons = true,
			use_less = true,
			set_env = { ["COLORTERM"] = "truecolor" },
			file_previewer = require("telescope.previewers").vim_buffer_cat.new,
			grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
			qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
			buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
			mappings = {
				i = {
					["<C-n>"] = actions.cycle_history_next,
					["<C-p>"] = actions.cycle_history_prev,
					["<C-j>"] = actions.move_selection_next,
					["<C-k>"] = actions.move_selection_previous,
					["<C-c>"] = actions.close,
					["<Down>"] = actions.move_selection_next,
					["<Up>"] = actions.move_selection_previous,
					["<CR>"] = actions.select_default,
					["<C-s>"] = actions.select_horizontal,
					["<C-v>"] = actions.select_vertical,
					["<C-t>"] = actions.select_tab,
					["<C-u>"] = actions.preview_scrolling_up,
					["<C-d>"] = actions.preview_scrolling_down,
					["<C-f>"] = actions.results_scrolling_up,
					["<C-b>"] = actions.results_scrolling_down,
					["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
					["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
					["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
					["<M-q>"] = actions.send_to_qflist + actions.open_qflist,
					["<C-l>"] = actions.complete_tag,
					["<C-/>"] = actions.which_key,
				},
				n = {
					["<esc>"] = actions.close,
					["<CR>"] = actions.select_default,
					["<C-s>"] = actions.select_horizontal,
					["<C-v>"] = actions.select_vertical,
					["<C-t>"] = actions.select_tab,

					["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
					["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
					["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
					["<M-q>"] = actions.send_to_qflist + actions.open_qflist,
					["j"] = actions.move_selection_next,
					["k"] = actions.move_selection_previous,
					["H"] = actions.move_to_top,
					["M"] = actions.move_to_middle,
					["L"] = actions.move_to_bottom,
					["<Down>"] = actions.move_selection_next,
					["<Up>"] = actions.move_selection_previous,
					["gg"] = actions.move_to_top,
					["G"] = actions.move_to_bottom,
					["?"] = actions.which_key,
				},
			},
		},
		pickers = {},
		extensions = {
			fzf = {
				fuzzy = true,
				override_generic_sorter = false,
				override_file_sorter = true,
				case_mode = "smart_case",
			},
			["ui-select"] = {
				require("telescope.themes").get_dropdown({
					winblend = 10,
				}),
			},
			workspaces = {
				keep_insert = false,
			},
			lazy = {
				theme = "ivy",
				show_icon = true,
				mappings = {
					open_in_browser = "<C-o>",
					open_in_file_browser = "<M-b>",
					open_in_find_files = "<C-f>",
					open_in_live_grep = "<C-g>",
					open_plugins_picker = "<C-b>",
					open_lazy_root_find_files = "<C-r>f",
					open_lazy_root_live_grep = "<C-r>g",
				},
			},
		},
	})

	local extensions = {
		"fzf",
		"ui-select",
		"harpoon",
		"toggletasks",
		"workspaces",
		"lazy",
	}

	for e in ipairs(extensions) do
		telescope.load_extension(extensions[e])
	end
end

return {
	"nvim-telescope/telescope.nvim",
	config = config,
	init = function()
		local create_cmd = require("util").create_cmd
		create_cmd("TelescopeFindFiles", function()
			require("telescope.builtin").find_files()
		end)
	end,
	cmd = "Telescope",
	keys = {
		m("<leader>tk", [[Telescope keymaps]]),
		m("<leader>tl", [[Telescope lazy]]),
		m("<leader>th", [[Telescope help_tags]]),
		m("<leader>f", [[Telescope find_files]]),
		m("<leader>e", [[TelescopeFindFilesNoIgnore]]),
		m("<leader>j", [[Telescope live_grep]]),
		m("<leader>bb", [[Telescope buffers]]),
	},
	dependencies = {
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		},
		"natecraddock/workspaces.nvim",
		"nvim-telescope/telescope-ui-select.nvim",
		"ThePrimeagen/harpoon",
		"jedrzejboczar/toggletasks.nvim",
		"tsakirist/telescope-lazy.nvim",
	},
}
