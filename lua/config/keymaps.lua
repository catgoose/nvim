local utils = require("config.utils")
local map = utils.map
local cmd = utils.map_cmd
local plug = utils.map_plug
local func = utils.map_func
local updates = utils.plugin_updates

-- TODO: use vim.keymap
-- Writing
map("n", "<leader>w", cmd("up"))
-- Luafile configs
map("n", "<leader>rc", func("ReloadConfigs"))
-- Luafile snippets
map("n", "<leader>rs", func("ReloadSnippets"))
-- BOL
map("n", "0", "^")
map("n", "-", "0")
-- Quitting
map("n", "<leader>qa", cmd("qa"))
map("n", "<leader>qq", cmd("q"))
-- Folds
map("n", "+", cmd([[execute "normal zm"]]))
map("n", "_", cmd([[execute "normal zr"]]))
-- Full screen
map("n", "<leader>zn", func("ToggleZenMode"))
-- Command height
map("n", "<leader>cz", func("ToggleCmdHeight"))
-- Plugins update
map("n", "<leader>pu", updates)
map("n", "<leader>pc", cmd("PackerCompile"))
-- Bracket search
map("n", "]]", cmd([[call search('[[{<]')]]))
map("n", "[[", cmd([[call search('[[{<]', 'b')]]))
-- Buffers
map("n", "<leader>bn", cmd("bn"))
map("n", "<leader>bp", cmd("bp"))
map("n", "<leader>bq", cmd("Bdelete"))
map("n", "<leader>bd", cmd("bd"))
map("n", "<leader>bu", cmd("bufdo :Bdelete"))
map("n", "<leader>bo", func("BufOnlyWindowOnly"))
map("n", "<leader>be", cmd("new"))
map("n", "<bs>", cmd("edit #"))
-- Tabs
map("n", "<leader>tt", cmd("tabnew"))
map("n", "<leader>tn", cmd("tabnext"))
map("n", "<leader>tp", cmd("tabprevious"))
map("n", "<leader>tq", cmd("tabclose"))
map("n", "<leader>tu", cmd("tabonly"))
-- Splits
map("n", "<leader>so", cmd("only"))
map("n", "<leader>sq", cmd("q"))
map("n", "<leader><", cmd("vertical resize -10"))
map("n", "<leader>>", cmd("vertical resize +10"))
map("n", "<leader>-", cmd("resize -10"))
map("n", "<leader>+", cmd("resize +10"))
-- focus
map("n", "<leader>ss", cmd("FocusSplitDown"))
map("n", "<leader>sv", cmd("FocusSplitRight"))
map("n", "<leader>sm", cmd("FocusMaximise"))
map("n", "<leader>se", cmd("FocusEqualise"))
map("n", "<leader>st", cmd("FocusToggle"))
-- winshift
map("n", "<leader>sh", cmd("WinShift left"))
map("n", "<leader>sj", cmd("WinShift down"))
map("n", "<leader>sk", cmd("WinShift up"))
map("n", "<leader>sl", cmd("WinShift right"))
map("n", "<leader>sw", cmd("WinShift"))
map("n", "<leader>sx", cmd("WinShift swap"))
-- ToggleTerm
map({ "n", "t" }, "[1", func("ToggleTermBtm", 1))
map({ "n", "t" }, "[3", func("ToggleTermLazyGit", 3))
map({ "n", "t" }, "[4", func("ToggleTermTerminal", 4))
-- Telescope
map("n", "<leader>tl", cmd(":Telescope"))
map("n", "<leader>tm", cmd(":Telescope marks"))
map("n", "<leader>tk", cmd(":Telescope keymaps"))
map("n", "<leader>tw", cmd(":Telescope workspaces"))
map("n", "<leader>hh", cmd(":Telescope harpoon marks"))
map("n", "<leader>ff", cmd(":Telescope find_files"))
map("n", "<leader>fb", cmd(":Telescope file_browser"))
map("n", "<leader>gg", cmd(":Telescope live_grep"))
map("n", "<leader>bb", cmd(":Telescope buffers"))
map("n", "<leader>ht", cmd(":Telescope help_tags"))
-- Angular
map("n", "<leader>gt", func("OpenSplitAngularTemplateUrl"))
map("n", "<leader>gh", func("OpenAngularTemplateUrl"))
-- Typescript
map("n", "<leader>gs", func("OpenTypescriptSpecFileSplit"))
map("n", "<leader>gf", func("OpenTypescriptSpecFile"))
-- nvim-hlslens
map("n", "n", cmd([[execute('normal! ' . v:count1 . 'n')]]) .. cmd([[lua require("hlslens").start()]]))
map("n", "N", cmd([[execute('normal! ' . v:count1 . 'N')]]) .. cmd([[lua require("hlslens").start()]]))
map("n", "*", "*" .. cmd([[lua require("hlslens").start()]]))
map("n", "#", "#" .. cmd([[lua require("hlslens").start()]]))
map("n", "g*", "g*" .. cmd([[lua require("hlslens").start()]]))
map("n", "g#", "g#" .. cmd([[lua require("hlslens").start()]]))
-- yanky.nvim
map({ "n", "x" }, "y", plug("(YankyYank)"))
map({ "n", "x" }, "p", plug("(YankyPutAfter)"))
map({ "n", "x" }, "P", plug("(YankyPutBefore)"))
map({ "n", "x" }, "gP", plug("(YankyGPutBefore)"))
map({ "n", "x" }, "gp", plug("(YankyGPutAfter)"))
map("n", "<c-p>", plug("(YankyCycleForward)"))
map("n", "<c-n>", plug("(YankyCycleBackward)"))
map("n", "<leader>pp", cmd("YankyRingHistory"))
-- comments
map({ "n", "x" }, "<leader>cp", func("CommentYankPaste"))
map({ "n", "x" }, "<leader>cc", cmd([[lua require("Comment.api").toggle_current_linewise()]]))
-- todo-comments
map("n", "<leader>td", cmd("TodoTelescope"))
map("n", "<leader>tr", cmd("TodoTrouble"))
-- trouble
map("n", "<leader>xx", cmd("TroubleToggle"))
-- Neotree
map("n", "<leader>m", cmd("Neotree float toggle"))
map("n", "<leader>n", cmd("Neotree left toggle"))
map("n", "<leader>d", cmd("Neotree diagnostics toggle float"))
-- Workspaces
map("n", "<leader>kl", cmd("WorkspacesList"))
map("n", "<leader>ko", cmd("WorkspacesOpen"))
map("n", "<leader>ka", cmd("WorkspacesAdd"))
map("n", "<leader>kr", cmd("WorkspacesRemove"))
-- Octo
map("n", "<leader>oo", cmd("Octo actions"))
map("n", "<leader>opc", cmd("Octo pr create"))
map("n", "<leader>opl", cmd("Octo pr list"))
map("n", "<leader>opr", cmd("Octo pr review"))
map("n", "<leader>opx", cmd("Octo pr close"))
map("n", "<leader>ops", cmd("Octo pr search"))
map("n", "<leader>opm", cmd("Octo pr mearge"))
-- Cheat Sheet
map("n", "<leader>ch", cmd("CheatSH"))
-- Harpoon
map({ "n", "x" }, "<leader>ha", cmd([[lua require("harpoon.mark").add_file()]]))
map({ "n", "x" }, "<leader>hl", cmd([[lua require("harpoon.ui").toggle_quick_menu()]]))
map({ "n", "x" }, "<leader>ho", cmd([[lua require("harpoon.ui").nav_next()]]))
map({ "n", "x" }, "<leader>hp", cmd([[lua require("harpoon.ui").nav_prev()]]))
map({ "n", "x" }, "<leader>h1", cmd([[lua require("harpoon.ui").nav_file(1)]]))
map({ "n", "x" }, "<leader>h2", cmd([[lua require("harpoon.ui").nav_file(2)]]))
map({ "n", "x" }, "<leader>h3", cmd([[lua require("harpoon.ui").nav_file(3)]]))
map({ "n", "x" }, "<leader>h4", cmd([[lua require("harpoon.ui").nav_file(4)]]))
map({ "n", "x" }, "<leader>h5", cmd([[lua require("harpoon.ui").nav_file(5)]]))
map({ "n", "x" }, "<leader>h6", cmd([[lua require("harpoon.ui").nav_file(6)]]))
map({ "n", "x" }, "<leader>h7", cmd([[lua require("harpoon.ui").nav_file(7)]]))
map({ "n", "x" }, "<leader>h8", cmd([[lua require("harpoon.ui").nav_file(8)]]))
map({ "n", "x" }, "<leader>h9", cmd([[lua require("harpoon.ui").nav_file(9)]]))
-- Symbols outline
map({ "n" }, "<leader>ol", cmd([[SymbolsOutline]]))
-- Typescript
map({ "n" }, "<leader>qf", func("TypeScriptFixAll"))
-- Copilot
-- map("i", "<C-.>", plug("copilot-next"))
-- map("i", "<C-,>", plug("copilot-prev"))
