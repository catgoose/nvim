local u = require("util")
local m, f = u.cmd_map, u.key_map

-- Normal maps
f("0", "^")
f("-", "0")

-- Maps
m("<leader>w", "up")
m("<leader>W", "wa")
m("<leader>qa", "qa")
m("<leader>qq", "q")
m("<leader>qo", "WinOnly")
m("<leader>ql", "WinOnlyFocusLeft")
m("<leader>qh", "WinOnlyFocusRight")
m("<leader>qj", "WinOnlyFocusDown")
m("<leader>qk", "WinOnlyFocusUp")
m("<leader>qf", "cwindow")
m("<leader>bn", "bn")
m("<leader>bp", "bp")
m("<leader>bq", "Bdelete")
m("<leader>bd", "bd")
m("<leader>bu", "bufdo :Bdelete")
m("<leader>bo", "BufOnlyWindowOnly")
m("<leader>be", "new")
m("<leader>so", "only")
m("<leader><", "vertical resize -10")
m("<leader>>", "vertical resize +10")
m("<leader>-", "resize -10")
m("<leader>+", "resize +10")
m("]q", "silent! cnext")
m("[q", "silent! cprev")
m("<leader><Tab>", "tabprevious")
m("<leader><S-Tab>", "tabnext")
m("<leader>tv", "vertical term")
m("<leader>tl", "vertical term")
m("<leader>ts", "horizontal term")
m("<leader>tj", "botright term")
m("<leader>tt", "tab term")

-- User commands
m("<leader>cz", "ToggleCmdHeight")
m("<bs>", "LoadPreviousBuffer")
m("<del>", "LoadPreviousBuffer")
m("]t", "TagStackUp")
m("[t", "TagStackDown")
m("]p", "SpotifyNext", { "n", "t" })
m("[p", "SpotifyPrev", { "n", "t" })
m("<leader>cp", "CommentYankPaste", { "n", "x" })
m("<leader>hw", "HelpWord")
m("K", "HoverHandler")
m("<leader>y", "TestingFunction")
m("<leader>E", "Netrw")
