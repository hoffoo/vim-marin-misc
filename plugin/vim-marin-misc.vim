nnoremap <F3> :call Toggle80CharHilight()<cr>
nmap <silent> <leader>s :call MarkWindowSwap()<CR>
nmap <silent> <leader>p :call DoWindowSwap()<CR>

" http://stackoverflow.com/questions/235439/vim-80-column-layout-concerns
let g:marin_hilighteightychars=0
function! Toggle80CharHilight()
	if g:marin_hilighteightychars
		let g:marin_hilighteightychars=0
		match none
	else
		let g:marin_hilighteightychars=1
		match ErrorMsg '\%>80v.\+'
	endif
endfunction

" http://stackoverflow.com/questions/10884520/move-file-within-vim
function! MoveFile(newspec)
     let old = expand('%')
     " could be improved:
     if (old == a:newspec)
         return 0
     endif
     exe 'sav' fnameescape(a:newspec)
     call delete(old)
endfunction

command! -nargs=1 -complete=file -bar MoveFile call MoveFile('<args>')

" save and restore session
" http://stackoverflow.com/questions/5142099/auto-save-vim-session-on-quit-and-auto-reload-session-on-start
function! SaveSess()
	execute 'mksession! ' . getcwd() . '/.session.vim'
endfunction

function! RestoreSess()
	if filereadable(getcwd() . '/.session.vim')
		execute 'so ' . getcwd() . '/.session.vim'
		if bufexists(1)
			for l in range(1, bufnr('$'))
				if bufwinnr(l) == -1
					exec 'sbuffer ' . l
				endif
			endfor
		endif
	endif
	syntax on
endfunction

command! -nargs=0 -complete=file -bar RestoreSession call RestoreSess()
command! -nargs=0 -complete=file -bar SaveSession call SaveSess()

" search for visual selection
vnoremap <silent> * :<C-U>
\let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
\gvy/<C-R><C-R>=substitute(
		\escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
\gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
\let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
\gvy?<C-R><C-R>=substitute(
		\escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
\gV:call setreg('"', old_reg, old_regtype)<CR>

" swap windows
" http://stackoverflow.com/questions/2586984/how-can-i-swap-positions-of-two-open-files-in-splits-in-vim
function! MarkWindowSwap()
    let g:markedWinNum = winnr()
endfunction

function! DoWindowSwap()
    "Mark destination
    let curNum = winnr()
    let curBuf = bufnr( "%" )
    exe g:markedWinNum . "wincmd w"
    "Switch to source and shuffle dest->source
    let markedBuf = bufnr( "%" )
    "Hide and open so that we aren't prompted and keep history
    exe 'hide buf' curBuf
    "Switch to dest and shuffle source->dest
    exe curNum . "wincmd w"
    "Hide and open so that we aren't prompted and keep history
    exe 'hide buf' markedBuf 
endfunction
