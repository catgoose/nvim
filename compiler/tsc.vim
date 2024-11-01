if exists("current_compiler")
  finish
endif
let current_compiler = "tsc"

if exists(":CompilerSet") != 2
  command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo&vim

if executable("tsc")
  CompilerSet makeprg=tsc\ --noEmit
else
  CompilerSet makeprg=npx\ tsc\ --noEmit
endif

CompilerSet errorformat=%f\ %#(%l\\,%c):\ %trror\ TS%n:\ %m,
		       \%trror\ TS%n:\ %m,
		       \%-G%.%#

let &cpo = s:cpo_save
unlet s:cpo_save

