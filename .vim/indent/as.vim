" Vim indent file
" Language:	Kawasaki AS
" Author:	田窪守雄
" Last Change:	2012/11/27

set isk+=\.


inoremap <expr> &     smartchr#loop(' BAND ', ' AND ', '&')
inoremap <expr> <bar> smartchr#loop(' BOR ' , ' OR ' , '<bar>')
inoremap <expr> !     smartchr#one_of(' NOT ' , '!')


nnoremap <silent> ]] :call BracketJmp("]]")
nnoremap <silent> ][ :call BracketJmp("][")
nnoremap <silent> [[ :call BracketJmp("[[")
nnoremap <silent> [] :call BracketJmp("[]")

vnoremap <silent> ]] /\.PROGRAM<CR>
vnoremap <silent> ][ /\.END<CR>
vnoremap <silent> [[ ?\.PROGRAM<CR>
vnoremap <silent> [] ?\.END<CR>

function! BracketJmp(key)
    if a:key == ']]'
	"jump next top of program
	let step = +1
	let dest = '^\s*\(\.program.*\|\.joints\|\.reals\|\.strings\)$'
    elseif a:key == '[['
	"jump current or previous top of program
	let step = -1
	let dest = '^\s*\(\.program.*\|\.joints\|\.reals\|\.strings\)$'
    elseif a:key == ']['
	"jump current or next end of program
	let step = +1
	let dest = '^\.end'
    elseif a:key == '[]'
	"jump previous end of program
	let step = -1
	let dest = '^\.end'
    else
	return
    endif

    let lnum = line(".")
    while 1
	let lnum += step
	let line = getline(lnum)
    	if lnum < 0 || line("$") < lnum
	    return
	endif
	if line =~? dest
	    call cursor(lnum, 0)	"カーソルを指定した位置に移動させる
	    if line =~?  '^\s*\.program.*$'
		normal 0w
	    endif
	    return
	endif
    endwhile
endfunc


if exists("b:did_indent")
    finish
endif
let b:did_indent = 1

setlocal autoindent
setlocal indentexpr=ASGetIndent(v:lnum)
setlocal indentkeys=<:>,0#,!^F,o,O
setlocal indentkeys+=0=~else,0=~end,0=~value,0=~svalue,0=~any
setlocal indentkeys+=0=~.end,0=~.*

"setlocal noexpandtab
"setlocal tabstop<
"setlocal softtabstop=0
setlocal shiftwidth=4

let b:undo_indent = "set ai< indentexpr< indentkeys<"

" Only define the function once.
if exists("*ASGetIndent")
    finish
endif

fun! ASGetIndent(lnum)
    let this_line = getline(a:lnum)

    " labels, preprocessor, and dot-aster-comment get zero indent immediately
    let LABELS_PREPROC_DOTCOMNT = '^\s*\(\<\k\+\>:\|#.*\|\.\*\|;\)'
    " dot-start-line get zero indent immediately
    let DOTLINE = '^\s*\(\.program.*\|\.end\|\.joints\|\.reals\|\.strings\)$'
    " Skip over labels, preprocessor directives, and dot-aster-comment.
    if (this_line =~? LABELS_PREPROC_DOTCOMNT) || (this_line =~? DOTLINE)
	return 0
    endif

    let lnum = a:lnum

    " Hit the start of the file, use zero indent.
    if lnum == 0
	return 0
    endif

    " Find a non-blank line above the current line.
    while lnum > 0
	let lnum = prevnonblank(lnum - 1)
	let previous_line = getline(lnum)
	if previous_line =~? '^\.end'
	    ".ENDなら、このブロックはテンポラリーなので、インデントはいじらない。
	    return indent(lnum)
	elseif previous_line =~? DOTLINE
	    ".END以外のドットライン
	    return &sw
	elseif previous_line !~? LABELS_PREPROC_DOTCOMNT
	    break
	endif
    endwhile
    let ind = indent(lnum)

    let STRACT_STA = '^\s*\<\(if\|else\|elseif\|do\|for\|while\|case\|scase\)\>'

    " Add
    if previous_line =~? STRACT_STA && previous_line !~? '^\s*\<if\>.*\<\(goto\|return\)\>'
	let ind = ind + &sw
    elseif previous_line =~? '^\s*\<\(value\|svalue\|any\)\>'
	let ind = ind + &sw / 2
    endif

    " Subtract
    if this_line =~? '^\s*\<\(end\|else\|elseif\)\>'
	if previous_line =~? '^\s*\<\(value\|svalue\|any\)\>'
	    if this_line =~? '^\s*\<end\>'
		let ind = ind - &sw
	    endif
	elseif previous_line =~? STRACT_STA && previous_line !~? '^\s*\<if\>.*\<\(goto\|return\)\>'
	    "上でAddされているので。
	    let ind = ind - &sw
	else
	    let ind = ind - &sw
	endif
    elseif this_line =~? '^\s*\<\(value\|svalue\|any\)\>'
	let ind = ind - &sw / 2
    endif

    return ind
endfun
