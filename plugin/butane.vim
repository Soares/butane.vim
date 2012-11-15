" butane.vim: Light your buffers up.
"
" Maintainer:   Nate Soares <http://so8r.es>
" Version:      1.0.1
" License:      The same as vim itself. (See |license|)
" GetLatestVimScripts: 4245 1 :AutoInstall: butane.zip

if exists('g:loaded_butane') || &cp || v:version < 700
	finish
endif
let g:loaded_butane = 1


if !exists('g:butane_enable_mappings')
	let g:butane_enable_mappings = 0
endif


command! -bang -complete=buffer -nargs=? Bclose
		\ call butane#bclose('<bang>', '<args>')


if !empty(g:butane_enable_mappings)
	if type(g:butane_enable_mappings) == type('')
		let s:mapchar = g:butane_enable_mappings
	else
		let s:mapchar = 'b'
	endif

	exe 'noremap <leader>' . s:mapchar . 'd :Bclose<CR>'
	exe 'noremap <leader>' . s:mapchar . 'l :ls<CR>'
	exe 'noremap <leader>' . s:mapchar . 'n :bn<CR>'
	exe 'noremap <leader>' . s:mapchar . 'p :bp<CR>'
	exe 'noremap <leader>' . s:mapchar . 't :b#<CR>'
	exe 'noremap <leader>' . s:mapchar . 'x :Bclose!<CR>'
endif
