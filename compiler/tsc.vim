if exists("current_compiler")
  finish
endif
let current_compiler = "tsc"

" Define CompilerSet if it doesn't exist
if exists(":CompilerSet") != 2
  command -nargs=* CompilerSet setlocal <args>
endif

" Save and set 'cpo' for compatibility
let s:cpo_save = &cpo
set cpo&vim

" Set makeprg to use `tsc --noEmit`. If `tsc` is unavailable, use `npx tsc --noEmit`
if executable("tsc")
  CompilerSet makeprg=tsc\ --noEmit
else
  CompilerSet makeprg=npx\ tsc\ --noEmit
endif

" Set errorformat to capture TypeScript errors
CompilerSet errorformat=%f\ %#(%l\\,%c):\ %trror\ TS%n:\ %m,
		       \%trror\ TS%n:\ %m,
		       \%-G%.%#

" Restore 'cpo' and clean up
let &cpo = s:cpo_save
unlet s:cpo_save

