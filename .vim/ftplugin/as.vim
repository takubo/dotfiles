set isk+=#,$


com! AStags !ASTags


command! -nargs=* ASgrep call ASgrep(<f-args>)

function! ASgrep(key)
"    if a:key == ""
"	let a:key = '<,'>
"    endif
    "exec "normal :vimgrep " . a:key . " *.as | cwin"
    "exec "normal :grep! " . a:key . " *.as | cwin"
    "exec 'silent grep! -i "' . a:key . '" *.as */*.as | cwin'
    exec "silent grep! -i " . a:key . " *.as | cwin"
    "exec 'silent vimgrep /\\c' . a:key . '/ *.as */*.as | cwin'
    "normal 
    "set cursorline
endfunction!

noremap <buffer> <leader>a :ASgrep ""<left>
noremap <buffer> <leader>g :set nocursorline<CR>:ASgrep ""<CR>:set cursorline<CR>
noremap <buffer> <leader>w :ASgrep ""


nnoremap <buffer> <silent> <leader>; ^i;


vnoremap <buffer> <silent> ]] /\.PROGRAM<CR>
vnoremap <buffer> <silent> ][ /\.END<CR>
vnoremap <buffer> <silent> [[ ?\.PROGRAM<CR>
vnoremap <buffer> <silent> [] ?\.END<CR>

nnoremap <buffer> <silent> y] V/\.END<CR>y:noh<CR>
nnoremap <buffer> <silent> y[ ?\.PROGRAM<CR>V/\.END<CR>y:noh<CR>


nnoremap <buffer> <leader>l :echo len("<C-r><C-w>")<CR>


function! s:Tab()
    if pumvisible()
	call feedkeys("\<C-n>")
	return ''
    else
	return TriggerSnippet()
    endif
endfunction

inoremap <buffer>	<Tab>	<C-R>=<SID>Tab()<CR>
inoremap <buffer><expr>	<S-Tab>	pumvisible() ? '<C-p>' : '<C-p><C-n>'


so $HOME/.vim/macros/complete.vim
"set completeopt=menuone
for k in split(".$#",'\zs')
  exec "inoremap <buffer><expr> " . k . " pumvisible() ? '\<C-e>" . k . "\<C-n>\<C-p>' : search('\\k\\%#', 'bcn') ? '" . k . "\<C-N>\<C-P>'" . " : '" . k . "'"
endfor
""inoremap <expr> . pumvisible() ? "\<C-E>.\<C-X>\<C-O>\<C-P>" : ".\<C-X>\<C-O>\<C-P>"
"set complete+=,]
"
"
"
"let s:jjj_old_t = 0
"let s:kkk_old_t = 0
"
"function! s:jjj()
"    if pumvisible()
"	call feedkeys("\<C-n>")
"	return ''
"    else
"      let t = str2float(reltimestr(reltime()))
"      let diff = t - s:jjj_old_t
"      echo diff
"      let s:jjj_old_t = t
"      if diff < 0.3
"	call feedkeys("\<ESC>:w\<CR>")
"	return "\<BS>"
"      else
"	call feedkeys("\<C-p>\<C-N>")
"	return 'j'
"      endif
"    endif
"endfunction
"
"function! s:kkk()
"    if pumvisible()
"	call feedkeys("\<C-p>")
"	return ''
"    else
"      let t = str2float(reltimestr(reltime()))
"      let diff = t - s:kkk_old_t
"      echo diff
"      let s:kkk_old_t = t
"      if diff < 0.3
"	call feedkeys("\<C-p>")
"	return "\<BS>"
"      else
"	call feedkeys("\<C-p>\<C-N>")
"	return 'k'
"      endif
"    endif
"endfunction
"
""inoremap <buffer><expr>	\	(<SID>in_str() != 0) ? '\' : '<C-p>'
"inoremap <buffer>	j	<C-R>=<SID>jjj()<CR>
"inoremap <buffer>	k	<C-R>=<SID>kkk()<CR>
""inoremap <buffer><expr>	l	pumvisible() ? '<C-y>' : 'l'
"iunmap jj
""iunmap <buffer> jj


nnoremap <buffer> <CR> <ESC>:b 

ab if IF
ab else ELSE
ab elseif ELSEIF
ab for FOR
ab end END
ab point POINT
ab zl3trn ZL3TRN
ab zl3jnt ZL3JNT
ab return RETURN
ab case CASE
ab value VALUE
ab any ANY
ab goto GOTO


inoremap <buffer> <expr> <CR> pumvisible() ? '<C-y>' :
		\ (search('^\s*\(ELSE\)\?IF.*\%#', 'bcn') && !search('\<\(RETURN\<bar>GOTO\<bar>THEN\)\>.*\%#', 'bcn')) ?
		\ (search('\s\%#', 'bcn') ? 'THEN<CR>' : ' THEN<CR>') : '<CR>'
inoremap <buffer> <expr> <Esc> pumvisible() ? '<C-e>' :
		\ (search('^\s*\(ELSE\)\?IF.*\%#', 'bcn') && !search('\<\(RETURN\<bar>GOTO\<bar>THEN\)\>.*\%#', 'bcn') && !search('\%#.', 'bcn')) ?
		\ (search('\s\%#', 'bcn') ? 'THEN<Esc>' : ' THEN<Esc>') : '<Esc>'

inoremap <expr> <buffer> <leader>p 
		\   ".************************************************************************\n"
		\ . ".* 関数名：rlop_chk_maps(.rob, .hnd, .prt, .#cur, .#loc, .slt, .pos)\n"
		\ . ".*\n"
		\ . ".* 引数：入力	.rob	ロボット番号\n"
		\ . ".*		.hnd	ハンド番号\n"
		\ . ".*		.prt	ポート番号\n"
		\ . ".*		.#cur	現在位置\n"
		\ . ".*		.#loc	平面方向に関して比較する位置\n"
		\ . ".*	 出力	.slt	スロット(範囲に入っていなかった場合は0)\n"
		\ . ".*		.pos	ポジション(範囲に入っていなかった場合は0)\n"
		\ . ".*\n"
		\ . ".* 機能／目的：	RLOPコマンドのために、各ポジションと現在位置の比較を実際に行い、\n"
		\ . ".*		スロット、ポジションを決定する。\n"
		\ . ".*		(MApping関連位置用)\n"
		\ . ".*\n"
		\ . ".* 履歴：	ALXT259 add\n"
		\ . ".************************************************************************"
