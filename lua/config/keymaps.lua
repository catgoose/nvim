local utils = require("config.utils")
local map, cmd, plug, func = utils.map, utils.map_cmd, utils.map_plug, utils.map_func
local updates = utils.plugin_updates

-- Writing
map("n", "<leader>w", cmd("up"))
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
map("n", "<bs>", func("EditPreviousBuffer"))
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
-- Navigation
map("n", "<C-h>", cmd("wincmd h"))
map("n", "<C-j>", cmd("wincmd j"))
map("n", "<C-l>", cmd("wincmd l"))
map("n", "<C-k>", cmd("wincmd k"))
-- Focus
map("n", "<leader>ss", cmd("FocusSplitDown"))
map("n", "<leader>sv", cmd("FocusSplitRight"))
map("n", "<leader>sm", cmd("FocusMaximise"))
map("n", "<leader>se", cmd("FocusEqualise"))
map("n", "<leader>st", cmd("FocusToggle"))
-- Winshift
map("n", "gs", cmd("WinShift"))
map("n", "gw", cmd("WinShift swap"))
map("n", "gh", cmd("WinShift left"))
map("n", "gj", cmd("WinShift down"))
map("n", "gk", cmd("WinShift up"))
map("n", "gl", cmd("WinShift right"))
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
map("n", "<leader>gg", cmd(":Telescope live_grep"))
map("n", "<leader>bb", cmd(":Telescope buffers"))
map("n", "<leader>ht", cmd(":Telescope help_tags"))
-- Angular
map("n", "<leader>gc", func("AngularEditFile", { extension = "ts" }))
map("n", "<leader>gh", func("AngularEditFile", { extension = "html" }))
map("n", "<leader>gf", func("AngularEditFile", { extension = "spec.ts" }))
map("n", "<leader>gd", func("AngularEditFile", { extension = "scss" }))
map("n", "<leader>gs", func("AngularEditFile", { extension = "spec.ts", split = true, direction = "right" }))
map("n", "<leader>gt", func("AngularEditFile", { extension = "html", split = true, direction = "right" }))
map("n", "<leader>gn", func("EditFileInCwd", { order = "next" }))
map("n", "<leader>gp", func("EditFileInCwd", { order = "prev" }))
map("n", "<leader>qf", func("TypeScriptFixAll"))
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
-- Comments
map({ "n", "x" }, "<leader>cp", func("CommentYankPaste"))
map({ "n", "x" }, "<leader>cc", cmd([[lua require("Comment.api").toggle.linewise.current()]]))
-- Todo-comments
map("n", "<leader>td", cmd("TodoTelescope"))
map("n", "<leader>tr", cmd("TodoLocList"))
-- Trouble
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
-- Copilot
-- map("i", "<C-j>", cmd("call copilot#Next()"))
-- map("i", "<C-k>", cmd("call copilot#Previous()"))
-- map("n", "<leader>gh", cmd("Copilot panel"))
-- Luasnip
map("n", "<leader>ls", cmd([[lua require("luasnip.loaders.from_lua").edit_snippet_files()]]))
