" butane.vim: Light your buffers up.
"
" Author:		Vim Tip #165 <http://vim.wikia.com/wiki/VimTip165>
" Maintainer:	Nate Soares <http://so8r.es>
" Version:		1.0
" License:		The same as vim itself. (See |license|)

if exists("g:loaded_butane") || &cp || v:version < 700
	finish
endif
let g:loaded_butane = 1

function! s:Bclose(bang, buffer)
	if empty(a:buffer)
		let btarget = bufnr('%')
	elseif a:buffer =~ '^\d\+$'
		let btarget = bufnr(str2nr(a:buffer))
	else
		let btarget = bufnr(a:buffer)
	endif
	if btarget < 0
		echoerr 'No matching buffer for '.a:buffer
		return
	endif
	if empty(a:bang) && getbufvar(btarget, '&modified')
		echoerr 'No write since last change. Use :Bclose!'
		return
	endif
	" Numbers of windows that view target buffer which we will delete.
	let wnums = filter(range(1, winnr('$')), 'winbufnr(v:val) == btarget')
	let wcurrent = winnr()
	for w in wnums
		execute w.'wincmd w'
		let prevbuf = bufnr('#')
		if prevbuf > 0 && buflisted(prevbuf) && prevbuf != w
			buffer #
		else
			bprevious
		endif
		if btarget == bufnr('%')
			" Numbers of listed buffers which are not the target to be deleted.
			let blisted = filter(range(1, bufnr('$')),
				\ 'buflisted(v:val) && v:val != btarget')
			" Listed, not target, and not displayed.
			let bhidden = filter(copy(blisted), 'bufwinnr(v:val) < 0')
			" Take the first buffer, if any (could be more intelligent).
			let bjump = (bhidden + blisted + [-1])[0]
			if bjump > 0
				execute 'buffer '.bjump
			else
				execute 'enew'.a:bang
			endif
		endif
	endfor
	execute 'bdelete'.a:bang.' '.btarget
	execute wcurrent.'wincmd w'
endfunction
command! -bang -complete=buffer -nargs=?
	\ Bclose call s:Bclose('<bang>', '<args>')
