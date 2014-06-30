function! SetFontSize(key)
  if a:key =~ "+"
    let step = 0.5
  elseif a:key =~ "-"
    let step = -0.5
  else
    return
  endif
  for i in range(1, 2)
    let bef = getfontname()
    let font = split(bef, ":")
    let cmd = "set guifont="
    for j in font
      if j =~? '^\(h\|w\)\d\+\(\.\d\+\)\?'
	let hw = strpart(j, 0, 1)
	let size = str2nr(strpart(j, 1))
	let size = str2float(strpart(j, 1))
	let size += step
	if size < 0.5
	  return
	end
	let j = hw . string(size)
      endif
      let cmd .= j . ":"
    endfor
    exec cmd
    if bef !~ getfontname()
      return
    endif
    let step = step * 2
  endfor
endfun

function! FontMode()
  while 1
    echo "Font Mode        "
    "押下されたキーを取得
    let k = nr2char(getchar())
    if k == '-'
      call SetFontSize("-")
    elseif k == '+'
      call SetFontSize("+")
    else
      echo "Finish Font Mode...        "
      return
    endif
    redraw
  endwhile
endfunc

nnoremap <silent> <leader>f :call FontMode()<cr>
nnoremap <silent> <F9>  <esc>:call SetFontSize("-")<CR>
nnoremap <silent> <F10> <esc>:call SetFontSize("+")<CR>

nnoremap <silent> <F5>   <esc>:sp<cr>
nnoremap <silent> <s-F5> <esc>:new<cr>
nnoremap <silent> <F6>   <esc>:vs<cr>
nnoremap <silent> <s-F6> <esc>:vnew<cr>

nnoremap <silent> + <esc><c-w>+
nnoremap <silent> - <esc><c-w>-
nnoremap <silent> ) <esc><c-w>>
nnoremap <silent> ( <esc><c-w><

"nnoremap <bs> gT
"nnoremap <c-bs> :call
"nnoremap <s-bs> :call
"nnoremap <c-s-bs> :set
