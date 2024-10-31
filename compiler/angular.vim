if exists("current_compiler")
  finish
endif
let current_compiler = "angular"

" Define CompilerSet if it doesn't exist
if exists(":CompilerSet") != 2
  command -nargs=* CompilerSet setlocal <args>
endif

" Save and set 'cpo' for compatibility
let s:cpo_save = &cpo
set cpo&vim

" Check if `ng` is available globally; if not, fall back to `npx ng`
if executable("ng")
  CompilerSet makeprg=ng\ build\ --no-progress\ --no-source-map
else
  CompilerSet makeprg=npx\ ng\ build\ --no-progress\ --no-source-map
endif

" Set errorformat to capture Angular errors
CompilerSet errorformat=%EError:\ %f:%l:%c\ -\ %m,%-G%.%#

" Restore 'cpo' and clean up
let &cpo = s:cpo_save
unlet s:cpo_save

