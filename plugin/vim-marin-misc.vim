nnoremap <F3> :call Toggle80CharHilight()<cr>

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
