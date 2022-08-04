local utils = require("config.utils")
local g = utils.set_global
local cmd = vim.cmd

g("coc_global_extensions", {
  "coc-pairs",
  "coc-angular",
  "coc-css",
  "coc-cssmodules",
  "coc-diagnostic",
  "coc-docker",
  "coc-eslint",
  "coc-explorer",
  "coc-highlight",
  "coc-html",
  "coc-htmlhint",
  "coc-html-css-support",
  "coc-inline-jest",
  "coc-jest",
  "coc-json",
  "coc-sumneko-lua",
  "coc-markdownlint",
  "coc-markdown-preview-enhanced",
  "coc-marketplace",
  "@yaegassy/coc-nginx",
  "coc-prettier",
  "coc-rome",
  "coc-scssmodules",
  "coc-sh",
  "coc-snippets",
  "coc-styled-components",
  "coc-stylelint",
  "coc-stylua",
  "coc-toml",
  "coc-tsserver",
  "coc-tsdetect",
  "coc-ultisnips",
  "coc-vimlsp",
  "coc-webview",
  "coc-yaml",
})

cmd([[inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ CoCCheckBackSpace() ? "\<TAB>" :
      \ coc#refresh()]])
cmd([[inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"]])

cmd([[function! CoCCheckBackSpace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction]])

-- Use <c-space> to trigger completion.
cmd([[inoremap <silent><expr> <c-space> coc#refresh()]])

-- Make <cr> auto-select the first completion item and notify coc.nvim to
-- format on enter, <cr> could be remapped by other vim plugin
cmd([[inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<cr>\<c-r>=coc#on_enter()\<CR>"]])

-- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
cmd([[nmap <silent> [g <Plug>(coc-diagnostic-prev)]])
cmd([[nmap <silent> ]g <Plug>(coc-diagnostic-next)]])

-- GoTo code navigation.
cmd([[nmap <silent> gd <Plug>(coc-definition)]])
cmd([[nmap <silent> gy <Plug>(coc-type-definition)]])
cmd([[nmap <silent> gi <Plug>(coc-implementation)]])
cmd([[nmap <silent> gr <Plug>(coc-references)]])

-- Use K to show documentation in preview window.
cmd([[nnoremap <silent>K :call CoCShowDocumentation()<cr>]])

cmd([[function! CoCShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction]])

-- Highlight the symbol and its references when holding the cursor.
cmd([[autocmd CursorHold * silent call CocActionAsync('highlight')]])

-- Highlights
cmd([[highlight CocErrorHighlight guibg=#ff0000 guifg=#ffffff gui=bold]])
cmd([[highlight CocWarningHighlight guibg=#ff8000 guifg=#ffffff gui=bold]])
cmd([[highlight CocInfoHighlight guibg=#ffd000 guifg=#000000 gui=bold]])
cmd([[highlight CocDeprecatedHighlight guibg=#fffc00 guifg=#000000 gui=bold]])
cmd([[highlight CocUnusedHighlight guibg=#ffffb0 guifg=#000000 gui=bold]])
cmd([[highlight CocCodeLens guifg=#a3a4be gui=italic]])

-- Symbol renaming.
cmd([[nmap <leader>rn <Plug>(coc-rename)]])

cmd([[augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json,vim setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end]])

-- Applying codeAction to the selected region.
-- Example: `<leader>aap` for current paragraph
cmd([[xmap <leader>a <Plug>(coc-codeaction-selected)]])
cmd([[nmap <leader>a <Plug>(coc-codeaction-selected)]])
-- Remap keys for applying codeAction to the current buffer.
cmd([[nmap <leader>ac <Plug>(coc-codeaction)]])
-- Apply AutoFix to problem on the current line.
cmd([[nmap <leader>qf <Plug>(coc-fix-current)]])

-- Remap <C-f> and <C-b> for scroll float windows/popups.
cmd([[nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"]])
cmd([[nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"]])
cmd([[inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"]])
cmd([[inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"]])
cmd([[vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"]])
cmd([[vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"]])

-- Show all diagnostics.
cmd([[nnoremap <silent><nowait> <space>d  :<C-u>CocList diagnostics<cr>]])

-- coc-css
cmd([[autocmd FileType scss setl iskeyword+=@-@]])

-- coc-snippets
-- Use <C-l> for trigger snippet expand.
cmd([[imap <C-l> <Plug>(coc-snippets-expand)]])

-- Use <C-j> for select text for visual placeholder of snippet.
cmd([[vmap <C-j> <Plug>(coc-snippets-select)]])

-- Use <C-j> for jump to next placeholder, it's default of coc.nvim
cmd([[let g:coc_snippet_next = '<c-j>']])

-- Use <C-k> for jump to previous placeholder, it's default of coc.nvim
cmd([[let g:coc_snippet_prev = '<c-k>']])

-- Use <C-j> for both expand and jump (make expand higher priority.)
cmd([[imap <C-j> <Plug>(coc-snippets-expand-jump)]])

-- Use <leader>x for convert visual selected code to snippet
cmd([[xmap <leader>x  <Plug>(coc-convert-snippet)]])

cmd([[inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ CoCCheckBackSpace() ? "\<TAB>" :
      \ coc#refresh()]])
