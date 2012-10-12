" butane.vim: Light your buffers up.
"
" Author:       Vim Tip #165 <http://vim.wikia.com/wiki/VimTip165>
" Maintainer:   Nate Soares <http://so8r.es>
" Version:      1.0.1
" License:      The same as vim itself. (See |license|)
" GetLatestVimScripts: 4245 1 :AutoInstall: butane.zip

if exists('g:loaded_butane') || &cp || v:version < 700
	finish
endif
let g:loaded_butane = 1

command! -bang -complete=buffer -nargs=? Bclose
			\ call butane#bclose('<bang>', '<args>')
