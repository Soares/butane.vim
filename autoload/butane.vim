" Delete a buffer but retain the window positions.
function! butane#bclose(bang, buffer)
	if empty(a:buffer)
		let l:target = bufnr('%')
	elseif a:buffer =~ '^\d\+$'
		let l:target = bufnr(str2nr(a:buffer))
	else
		let l:target = bufnr(a:buffer)
	endif
	if l:target < 0
		echoerr 'No matching buffer for '.a:buffer
		return
	endif

	if empty(a:bang) && getbufvar(l:target, '&modified')
		echoerr 'No write since last change. Use :Bclose!'
		return
	endif

	let l:bufhidden = getbufvar(l:target, '&bufhidden')

	" Numbers of windows that view target buffer which we will delete.
	let l:wnums = filter(range(1, winnr('$')), 'winbufnr(v:val) == l:target')
	let wcurrent = winnr()
	for l:w in l:wnums
		execute l:w.'wincmd w'
		let l:prevbuf = bufnr('#')
		if l:prevbuf > 0 && buflisted(l:prevbuf) && l:prevbuf != w
			buffer #
		else
			bprevious
		endif
		if l:target == bufnr('%')
			" Numbers of listed buffers which are not the target to be deleted.
			let l:listed = filter(range(1, bufnr('$')),
				\ 'buflisted(v:val) && v:val != l:target')
			" Listed, not target, and not displayed.
			let l:hidden = filter(copy(l:listed), 'bufwinnr(v:val) < 0')
			" Take the first buffer, if any (could be more intelligent).
			let l:jump = (l:hidden + l:listed + [0])[0]
			if l:jump > 0
				execute 'buffer '.l:jump
			else
				execute 'enew'.a:bang
			endif
		endif
	endfor

	if l:bufhidden !~ 'delete\|wipe'
		" If &bufhidden was set to 'delete' or 'wipe' our switching away in the
		" loop above already led to the buffer's deletion.
		execute 'bdelete'.a:bang.' '.l:target
	endif

	execute wcurrent.'wincmd w'
endfunction


" Delete all open buffers.
function! butane#reset(bang)
	exe 'bufdo bdelete'.a:bang
	" If there were multiple buffers, the last is still loaded.
	exe 'bdelete'.a:bang
	" Clear extraneous echos & messages
	echo ''
	redraw
endfunction
