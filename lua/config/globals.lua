local g = require("config.utils").set_global

g("mapleader", " ")
g("zen_full_screen_status", 0)
g("cursorhold_updatetime", 100)

vim.cmd([[let g:vimwiki_key_mappings = { 'all_maps': 0, }]])
