if exists("current_compiler")
  finish
endif
let current_compiler = "vue-tsc"

if exists(":CompilerSet") != 2
  command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo&vim

if executable("vue-tsc")
  CompilerSet makeprg=vue-tsc
else
  CompilerSet makeprg=npx\ vue-tsc\
endif

CompilerSet errorformat=%f\ %#(%l\\,%c):\ %trror\ TS%n:\ %m,
		       \%trror\ TS%n:\ %m,
		       \%-G%.%#

let &cpo = s:cpo_save
unlet s:cpo_save
