" butane.vim: Light your buffers up.
"
" Maintainer:   Nate Soares <http://so8r.es>
" Version:      1.0.1
" License:      The same as vim itself. (See |license|)
" GetLatestVimScripts: 4245 1 :AutoInstall: butane.zip
"
" TODO: Add support for bwipeout?

if exists('g:loaded_butane') || &cp || v:version < 700
	finish
endif
let g:loaded_butane = 1


if !exists('g:butane_automap')
	let g:butane_automap = 0
endif

function! s:purge(bang)
  let l:result = butane#purge(a:bang)
  let l:msg = l:result[0] . ' hidden buffer(s) purged'
  if l:result[1] > 0
    let l:msg .= ' ('.l:result[1].' survived)'
  endif
  echomsg l:msg
endfunction


command -bang -complete=buffer -nargs=? Bclose
	\ call butane#bclose('<bang>', '<args>')
command -bang Breset call butane#reset('<bang>')
command -bang Bpurge call s:purge('<bang>')


if !empty(g:butane_automap)
	if type(g:butane_automap) == type(1)
		let g:butane_automap = 'b'
	endif

	exe 'noremap <leader>' . g:butane_automap . 'd :Bclose<CR>'
	exe 'noremap <leader>' . g:butane_automap . 'l :ls<CR>'
	exe 'noremap <leader>' . g:butane_automap . 'n :bn<CR>'
	exe 'noremap <leader>' . g:butane_automap . 'p :bp<CR>'
	exe 'noremap <leader>' . g:butane_automap . 't :b#<CR>'
	exe 'noremap <leader>' . g:butane_automap . 'x :Bclose!<CR>'
endif
