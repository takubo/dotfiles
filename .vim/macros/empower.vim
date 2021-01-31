let s:now_disp = 0

" 引数: bits : 何ビット単位で反転させるか？
" 		8を指定すれば、エンディアン変換
function! Changian(bits)
	" エンディアン変換 未実装 TODO
	let numstr = ""
endfunc

"function! s:get_numstr()
function! Get_numstr(aword)
	let rawstr = ''
	let numstr = ''

	let base = 0
	let len = 0
	let bits = 0
	let bytes = 0

	let signed = 1
	let long = 0
	let longlong = 0

	let word = a:aword
	"let word = matchstr(getline('.'), '\k\+\%#\k\+')
	"let word = matchstr(getline('.'), '.*\%#.*')
	"let word = matchstr(getline('.'), '\k*\%#\k*')
	"let word = matchstr(getline('.'), '\k\+\%#')
	if (&ft == "c" && s:c99)
		let rawstr = matchstr()
		if rawstr =~? '\(0x\)\?'
			let base = 16
		endif
		if rawstr =~? '\(0b\)\?'
			let base = 2
		endif
	"elseif &ft == "awk"
	"elseif &ft == "zsh"
	"elseif &ft == "erlang"
	"elseif &ft == "ada"
	"elseif &ft == "vim"
	"else
	endif

	echo word

	return
endfunc




function! Ana_numstr(aword)
	let rawstr = ''
	let numstr = ''

	let base = 0
	let len = 0
	let bits = 0
	let bytes = 0

	let signed = 1
	let long = 0
	let longlong = 0

	let word = a:aword

	let rawstr = word

	if rawstr =~? '^0x\x\+[lLuU]\{,3\}$'	" long long型リテラルは、0x00LLのようにLが2つ付く
		let base = 16
		let numstr = substitute(strpart(rawstr, 2), '[ulUL]\+', '', '')
	elseif rawstr =~? '^\([1-9]\d*\|0\+\)[lLuU]\{,3\}$'	" 0のみから構成される数は、Cの仕様上、厳密には8進であるが、便宜上10進として扱う。
		let base = 10
		let numstr = substitute(rawstr, '[ulUL]\+', '', '')
	elseif rawstr =~? '^0\o\+'
		let base = 8
		let numstr = rawstr
	elseif rawstr =~? '^0b[01]\+'	" 2進リテラル C99
		let base = 2
		let numstr = strpart(rawstr, 2)
	endif

	" C系以外
	if base == 0 && rawstr =~? '^\(0x\)\?\x\+$'
		let base = 16
		let numstr = rawstr
	"elseif rawstr =~? '^[01]\+'
	elseif rawstr =~? '^[01]\{3,\}$'
		let base = 2
		let numstr = rawstr
	endif

	"if (&ft == "c" && s:c99) || (&ft == "vim")
	"elseif &ft == "awk"
	"elseif &ft == "zsh"
	"elseif &ft == "erlang"
	"elseif &ft == "ada"
	"elseif &ft == "vim"
	"else
	"endif

	"echo word rawstr base
	"let ret = [word, rawstr, base]
	let ret = {'word':word, 'rawstr':rawstr, 'numstr':numstr, 'base':base}
	"echo ret

	return ret
endfunc

let c99 = 1

command! AnaNum :call Ana_numstr(expand("<cword>"))
AnaNum


function! s:bin2hex(bin)
	let b2h = {}
	let b2h['0000'] = '0'
	let b2h['0001'] = '1'
	let b2h['0010'] = '2'
	let b2h['0011'] = '3'
	let b2h['0100'] = '4'
	let b2h['0101'] = '5'
	let b2h['0110'] = '6'
	let b2h['0111'] = '7'
	let b2h['1000'] = '8'
	let b2h['1001'] = '9'
	let b2h['1010'] = 'a'
	let b2h['1011'] = 'b'
	let b2h['1100'] = 'c'
	let b2h['1101'] = 'd'
	let b2h['1110'] = 'e'
	let b2h['1111'] = 'f'

	let hex = ''

	let bin = a:bin
	while len(bin) > 0
		let l = len(bin)
		let tmp = matchstr('000' . strpart(bin, l - 4), '....$')
		let hex = b2h[tmp] . hex
		let bin = substitute(bin, '[01]\{0,4\}$', '', '')
		"echo "BB" bin
	endwhile
	return hex
endfunc
function! s:hex2bin(hex)
	let h2b = {}
	let h2b['0'] = 'oooo'
	let h2b['1'] = 'oooI'
	let h2b['2'] = 'ooIo'
	let h2b['3'] = 'ooII'
	let h2b['4'] = 'oIoo'
	let h2b['5'] = 'oIoI'
	let h2b['6'] = 'oIIo'
	let h2b['7'] = 'oIII'
	let h2b['8'] = 'Iooo'
	let h2b['9'] = 'IooI'
	let h2b['a'] = 'IoIo'
	let h2b['b'] = 'IoII'
	let h2b['c'] = 'IIoo'
	let h2b['d'] = 'IIoI'
	let h2b['e'] = 'IIIo'
	let h2b['f'] = 'IIII'

	let bin = ''

	for i in split(a:hex, '\zs')
		let bin = bin . h2b[tolower(i)] . ' '
	endfor
	return substitute(bin, '|$', '', '')
endfunc

function! s:EmDisp(word)
	let r = Ana_numstr(a:word)
	"echo r.base
	"return

	if r.base == 16
		"echo '[Dec]  ' printf("%u", r.rawstr)
		"echo '[Bin]  ' s:hex2bin(r.numstr)
		"echo '[Dec] ' printf("%u", r.rawstr) '    [Bin] ' s:hex2bin(r.numstr) '    [byt]' len(r.numstr)/2 '    [bit]' len(r.numstr)*4 '    [len]' len(r.numstr)
		echo '[Dec]' printf("%10u", r.rawstr) '    [Bin]' s:hex2bin(r.numstr) (winwidth(0) > 100 ? '    ' : "\n") '[Byt]' len(r.numstr)/2 '    [bit]' len(r.numstr)*4 '    [dig]' len(r.numstr)
		"echo '[byt]' len(r.numstr)/2 '    [bit]' len(r.numstr)*4 '    [len]' len(r.numstr)
		"echo '[Dec] ' printf("%u", r.rawstr) '    [Bin] ' s:hex2bin(r.numstr)
		let s:now_disp = 1
	elseif r.base == 10
		let hex = printf("%08x", r.numstr)
		"echo '[Hex]  ' hex
		"echo '[Bin]  ' s:hex2bin(hex)
		echo '[Hex] 0x' . hex '    [Bin]' s:hex2bin(hex) '    [byt]' float2nr(ceil(len(hex)/2.0)) '    [bit]' len(hex)*4 '    [dig]' len(r.numstr)
		let s:now_disp = 1
	elseif r.base == 2
		let hex = s:bin2hex(r.numstr)
		"echo '[Hex]  ' hex
		"echo '[Dec]  ' printf("%d", '0x' . hex)
		echo '[Hex] 0x' . hex '    [Dec] ' printf("%d", '0x' . hex) '    [byt]' float2nr(ceil(len(r.numstr)/8.0)) '    [bit]' len(hex)*4 '    [dig]' len(r.numstr)
		let s:now_disp = 1
	elseif s:now_disp
		echo ""
		let s:now_disp = 0
	endif
endfun

command! EmDisp :call <SID>EmDisp(expand("<cword>"))

func! Ccc()
	let v:ooo=89
 let s:now_disp = 0<CR>
endfunc

augroup Em
	au!

	au CursorMoved * EmDisp
	au VimResized * EmDisp

	au CmdwinEnter * let <SID>now_disp = 0
	au CmdwinEnter * call Ccc<cr>
augroup end

" for develope
"EmDisp


" Test
" 0xaf45 0xf0 0b011100 0716 1234 65535 0xfdb97531 256 0b111111110000000011010000  0101111
" 0xaf45UL 0xf0ll 0b011100 0716 1234 65535 0xfdb97531 256a 0b111111110000000011010000  0101111


" 実装すべき機能 TODO
"1	基数変換して表示
"2	基数変換
"3	0拡張
"4	符号拡張
"5	bit反転
"6	クリップボードとのand or exor
"7	シフト
"8	エンディアン変換
"9	ビット間に_をつけて区切って表示
"10	任意数のビットを数値として表示
"11	差異のあるビット	XOR
"
"
"クリップボード vs カーソル下 vs 選択範囲
"下に表示のみ vs 書き換え
"
"
"ビット編集モード
"
"Erlang, Adaに対応する。

function! X(arg)
	return printf("0x%x", a:arg)
endfunc
