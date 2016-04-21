function! s:del()
  return g:butane_wipeout ? 'bwipeout' : 'bdelete'
endfunction

" Delete a buffer but retain the window positions.
function! butane#bclose(bang, buffer)
  let l:del = s:del()
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
	let l:wcurrent = winnr()
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
				execute 'buffer' l:jump
			else
				execute 'enew'.a:bang
			endif
		endif
	endfor

	if l:bufhidden !~ 'delete\|wipe'
		" If &bufhidden was set to 'delete' or 'wipe' our switching away in the
		" loop above already led to the buffer's deletion.
		execute l:del.a:bang l:target
	endif

	execute l:wcurrent.'wincmd w'
endfunction


" Delete all open buffers.
function! butane#reset(del, bang)
  let l:del = s:del()
  execute 'bufdo' l:del.a:bang
	" If there were multiple buffers, the last is still loaded.
  execute l:del.a:bang
	" Clear extraneous echos & messages
	echo ''
	redraw
endfunction

" Clear buffers that aren't open in some window.
" Call with 'bdelete', 'bwipeout', or banged versions.
" Returns a list with two elements. The first is the number of buffers
" affected, the second is the number of buffers where an error occured.
function! butane#purge(bang)
  let l:del = s:del()
  let l:tabs = []
  for i in range(tabpagenr('$'))
      call extend(l:tabs, tabpagebuflist(i + 1))
  endfor
  let l:count = 0
  let l:errors = 0
  for l:i in range(1, bufnr('$'))
    if g:butane_wipeout == 0 && !buflisted(l:i)
      continue
    endif
    if bufexists(l:i) && index(l:tabs, l:i) == -1
      let l:count += 1
      try
        silent execute l:del.a:bang l:i
      catch /E\%(516\|89\):/
        let l:errors += 1
      endtry
    endif
  endfor
  return [l:count - l:errors, l:errors]
endfunction
