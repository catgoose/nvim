if exists("current_compiler")
  finish
endif
let current_compiler = "vue-tsc"

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo&vim

" If vue-tsc is not installed globally
"CompilerSet makeprg=node_modules/.bin/vue-tsc
CompilerSet makeprg=vue-tsc
CompilerSet errorformat=%f\ %#(%l\\,%c):\ %trror\ TS%n:\ %m,
		       \%trror\ TS%n:\ %m,
		       \%-G%.%#

let &cpo = s:cpo_save
unlet s:cpo_save
