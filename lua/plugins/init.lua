local fn = vim.fn
local utils = require("config.utils")
local config = utils.plugin_config
local plugin = utils.require_plugin
local packer = plugin("plugins.bootstrap")

local plugins = {
	"lewis6991/impatient.nvim",
	{
		"rebelot/kanagawa.nvim",
		config = config("kanagawa"),
	},
	"wbthomason/packer.nvim",
	"nvim-lua/plenary.nvim",
	"jamessan/vim-gnupg",
	{
		"neovim/nvim-lspconfig",
		config = config("lspconfig"),
		requires = {
			{
				"windwp/nvim-autopairs",
				config = config("autopairs"),
			},
			"jose-elias-alvarez/typescript.nvim",
			{
				"williamboman/mason.nvim",
				config = config("mason"),
				requires = {
					"williamboman/mason-lspconfig.nvim",
				},
			},
			"b0o/schemastore.nvim",
			{
				"stevearc/aerial.nvim",
				config = config("aerial"),
			},
		},
	},
	{
		"onsails/lspkind-nvim",
		config = config("lspkind"),
		requires = {
			{
				"hrsh7th/nvim-cmp",
				config = config("cmp"),
			},
		},
	},
	{
		"hrsh7th/cmp-nvim-lsp",
		after = "nvim-cmp",
		requires = {
			{
				"L3MON4D3/LuaSnip",
				config = config("luasnip"),
			},
			{
				"hrsh7th/cmp-buffer",
			},
			{
				"hrsh7th/cmp-path",
			},
			{
				"hrsh7th/cmp-cmdline",
			},
			{
				"hrsh7th/cmp-nvim-lua",
			},
			{
				"ray-x/cmp-treesitter",
			},
			{
				"saadparwaiz1/cmp_luasnip",
			},
		},
	},
	{
		"goolord/alpha-nvim",
		requires = { "kyazdani42/nvim-web-devicons" },
		config = config("alpha"),
	},
	{
		"rmagatti/auto-session",
		config = config("autosession"),
		after = "alpha-nvim",
	},
	{
		"akinsho/toggleterm.nvim",
		branch = "main",
		config = config("toggleterm"),
	},
	{
		"nvim-treesitter/nvim-treesitter",
		run = function()
			pcall(fn, "TSUpdate")
		end,
		config = config("treesitter"),
		requires = {
			"nvim-treesitter/nvim-treesitter-angular",
			"nvim-treesitter/nvim-treesitter-textobjects",
			"RRethy/nvim-treesitter-textsubjects",
			"windwp/nvim-ts-autotag",
		},
	},
	{
		"rebelot/heirline.nvim",
		config = config("heirline"),
	},
	-- cmd
	{
		"nvim-telescope/telescope.nvim",
		config = config("telescope"),
		requires = {
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				run = "make",
			},
			{
				"natecraddock/workspaces.nvim",
				config = config("workspaces"),
			},
			"nvim-telescope/telescope-ui-select.nvim",
			{
				"ThePrimeagen/harpoon",
				config = config("harpoon"),
				requires = "nvim-lua/plenary.nvim",
			},
		},
		cmd = { "Telescope" },
	},
	{
		"folke/trouble.nvim",
		requires = "kyazdani42/nvim-web-devicons",
		config = config("trouble"),
		cmd = {
			"Trouble",
			"TroubleToggle",
		},
	},
	{
		"manzeloth/live-server",
		cmd = "LiveServer",
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		config = config("mason-tool-installer"),
		cmd = "MasonToolsUpdate",
	},
	{
		"dstein64/vim-startuptime",
		cmd = "StartupTime",
	},
	{
		"WhoIsSethDaniel/toggle-lsp-diagnostics.nvim",
		cmd = "ToggleDiag*",
	},
	{
		"beauwilliams/focus.nvim",
		config = config("focus"),
		cmd = "Focus*",
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		config = config("indent-blankline"),
		event = "BufReadPre",
	},
	{
		"m-demare/hlargs.nvim",
		config = config("hlargs"),
		event = "BufReadPre",
	},
	{
		"rrethy/vim-hexokinase",
		setup = config("hexokinase"),
		run = "make",
		event = "BufReadPre",
	},
	{
		"antoinemadec/FixCursorHold.nvim",
		event = "BufReadPre",
	},
	{
		"ethanholz/nvim-lastplace",
		config = config("lastplace"),
		event = "BufReadPre",
	},
	{
		"Djancyp/cheat-sheet",
		event = "BufReadPre",
	},
	-- WinEnter
	{
		"sindrets/winshift.nvim",
		config = config("winshift"),
		event = "WinEnter",
	},
	{
		"famiu/bufdelete.nvim",
		requires = "schickling/vim-bufonly",
		event = "WinEnter",
	},
	{
		"RRethy/vim-illuminate",
		config = config("illuminate"),
		event = "WinEnter",
	},
	-- CursorHold
	{
		"jose-elias-alvarez/null-ls.nvim",
		config = config("null-ls"),
		event = "CursorHold",
	},
	{
		"luukvbaal/stabilize.nvim",
		config = config("stabilize"),
		event = "CursorHold",
	},
	{
		"kevinhwang91/nvim-hlslens",
		config = config("hlslens"),
		event = "CursorHold",
	},
	{
		"petertriho/nvim-scrollbar",
		config = config("scrollbar"),
		after = "nvim-hlslens",
	},
	{
		"lewis6991/gitsigns.nvim",
		config = config("gitsigns"),
		event = "CursorHold",
	},
	{
		"chentoast/marks.nvim",
		config = function()
			require("marks").setup({})
		end,
		event = "CursorHold",
	},
	{
		"pwntester/octo.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			"kyazdani42/nvim-web-devicons",
		},
		config = config("octo"),
		event = "CursorHold",
	},
	{
		"andymass/vim-matchup",
		config = config("matchup"),
		event = "CursorHold",
	},
	{
		"romainl/vim-cool",
		event = "CursorHold",
	},
	{
		"gbprod/yanky.nvim",
		config = config("yanky"),
		event = "CursorHold",
	},
	{
		"anuvyklack/pretty-fold.nvim",
		requires = "anuvyklack/nvim-keymap-amend",
		config = config("pretty-fold"),
		event = "CursorHold",
	},
	{
		"anuvyklack/fold-preview.nvim",
		requires = "anuvyklack/keymap-amend.nvim",
		config = config("fold-preview"),
		event = "CursorHold",
	},
	{
		"nacro90/numb.nvim",
		config = config("numb"),
		event = "CursorHold",
	},
	{
		"folke/todo-comments.nvim",
		requires = "nvim-lua/plenary.nvim",
		config = config("todo-comments"),
		event = "CursorHold",
	},
	{
		"numToStr/Comment.nvim",
		config = config("comment"),
		event = "CursorHold",
	},
	{
		"kylechui/nvim-surround",
		config = function()
			require("nvim-surround").setup({})
		end,
		event = "CursorHold",
	},
	{
		"axelvc/template-string.nvim",
		config = function()
			require("template-string").setup()
		end,
		event = "CursorHold",
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v2.x",
		requires = {
			"nvim-lua/plenary.nvim",
			"kyazdani42/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
			{
				"s1n7ax/nvim-window-picker",
				tag = "v1.*",
				config = config("window-picker"),
			},
		},
		config = config("neotree"),
		event = "CursorHold",
	},
	{
		"ThePrimeagen/refactoring.nvim",
		config = config("refactoring"),
		event = "CursorHold",
	},
	-- {
	-- 	"stevearc/dressing.nvim",
	-- 	config = function()
	-- 		require("dressing").setup({})
	-- 	end,
	-- 	event = "CursorHold",
	-- },
	{
		"mrbjarksen/neo-tree-diagnostics.nvim",
		requires = "nvim-neo-tree/neo-tree.nvim",
		module = "neo-tree.sources.diagnostics",
		event = "CursorHold",
	},
	{
		"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
		config = config("lsp-lines"),
		event = "CursorHold",
	},
	{
		"simrat39/symbols-outline.nvim",
		event = "CursorHold",
	},
	{
		"github/copilot.vim",
		config = config("copilot"),
		event = "CursorHold",
	},
	{
		"doums/suit.nvim",
		config = config("suit"),
		event = "CursorHold",
	},
	-- keys
	{
		"ggandor/leap.nvim",
		requires = {
			"tpope/vim-repeat",
		},
		config = config("leap"),
		keys = { "s", "S" },
	},
	-- filetype
	{
		"kevinhwang91/nvim-bqf",
		ft = "qf",
		config = config("bqf"),
		requires = {
			"junegunn/fzf",
			run = function()
				vim.fn["fzf#install"]()
			end,
		},
	},
}

return packer.startup(function(use)
	for _, v in pairs(plugins) do
		use(v)
	end
end)
