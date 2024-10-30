if exists("current_compiler")
  finish
endif
let current_compiler = "angular"

if exists(":CompilerSet") != 2
  command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo&vim

" Check if `ng` is available globally; if not, fall back to `npx ng`
if executable("ng")
  CompilerSet makeprg=ng\ build\ --no-progress\ --no-source-map
else
  CompilerSet makeprg=npx\ ng\ build\ --no-progress\ --no-source-map
endif

CompilerSet errorformat=%EError:\ %f:%l:%c\ -\ %m,%-G%.%#

let &cpo = s:cpo_save
unlet s:cpo_save

