set complete+=,]
set completeopt=menuone,preview
for k in split("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_",'\zs')
  exec "inoremap <buffer><expr> " . k . " pumvisible() ? '\<C-e>" . k . "\<C-n>\<C-p>' : search('\\k\\%#', 'bcn') ? '" . k . "\<C-N>\<C-P>'" . " : '" . k . "'"
endfor
inoremap <buffer><expr>	<BS>	pumvisible() ? (search('\k\k\k\k\%#', 'bcn') ? '<BS>' : "\<C-e>\<BS>") : (search('\k\k\k\k\%#', 'bcn') ? "\<BS>\<C-N>\<C-P>" : "\<BS>")

function! s:set_cpmpl_key(str)
  for k in split(a:str,'\zs')
    exec "inoremap <buffer><expr> " . k . " pumvisible() ? '\<C-e>" . k . "\<C-n>\<C-p>' : search('\\k\\%#', 'bcn') ? '" . k . "\<C-N>\<C-P>'" . " : '" . k . "'"
  endfor
endfunction

let s:jjj_old_t = 0
let s:kkk_old_t = 0

function! s:jjj()
    if pumvisible()
	call feedkeys("\<C-n>")
	return ''
    else
      let t = str2float(reltimestr(reltime()))
      let diff = t - s:jjj_old_t
      let s:jjj_old_t = t
      if diff < 0.3
	if search('^\s\+j\%#', 'bcn')
	  "改行直後にjjで抜けたときに、余分なインデントスペースを残さないため。
	  call feedkeys("\<ESC>0D:w\<CR>")
	else
	  call feedkeys("\<ESC>:w\<CR>")
	endif
	return "\<BS>"
      else
	if search('\\k\\k\\%#', 'bcn')
	  call feedkeys("\<C-N>\<C-P>")
	endif
	return 'j'
      endif
    endif
endfunction

function! s:kkk()
    if pumvisible()
	call feedkeys("\<C-p>")
	return ''
    else
      let t = str2float(reltimestr(reltime()))
      let diff = t - s:kkk_old_t
      let s:kkk_old_t = t
      if diff < 0.3
	call feedkeys("\<C-N>\<C-P>")
	return "\<BS>"
      else
	if search('\\k\\k\\%#', 'bcn')
	  call feedkeys("\<C-N>\<C-P>")
	endif
	return 'k'
      endif
    endif
endfunction

inoremap <buffer>	j	<C-R>=<SID>jjj()<CR>
inoremap <buffer>	k	<C-R>=<SID>kkk()<CR>

if !exists('g:MyComplete')
  iunmap jj
endif
let g:MyComplete = 1

imap <buffer><expr>	ff	pumvisible() ? '<CR><Esc>:w<CR>' : '<Esc>:w<CR>'
imap <buffer><expr>	<C-k>	pumvisible() ? '<CR><Esc>:w<CR>' : '<Esc>:w<CR>'
