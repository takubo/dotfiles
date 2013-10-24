" Vim indent file
" Language:	GDB
" Author:	Takubo Morio
" Last Change:	20 Nov 2012

if exists("b:did_indent")
    finish
endif
let b:did_indent = 1

setlocal isk+=$
setlocal shiftwidth=4
setlocal tabstop=4

setlocal autoindent
setlocal indentexpr=GdbGetIndent(v:lnum)
setlocal indentkeys=0#,!^F,o,O,e
setlocal indentkeys+=0=else,0=end

fun! GdbGetIndent(lnum)
    let this_line = getline(a:lnum)

    if this_line =~# '^define\|^document'
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
	if previous_line =~# '^end'
	    "行頭endなら、このブロックはただの命令行なのでインデントは0にする。
	    return 0
	elseif previous_line !~? '^\s*#'
	    break
	endif
    endwhile
    let ind = indent(lnum)

    let STRACT_STA = '^\s*\<\(define\|document\|if\|else\|while\)\>'

    " Add
    if previous_line =~# STRACT_STA
	let ind = ind + &sw
    endif

    " Subtract
    if this_line =~? '^\s*\<end\>'
	if previous_line =~? STRACT_STA
	    "上でAddされているので。
	    let ind = ind - &sw - &sw
	else
	    let ind = ind - &sw
	endif
    endif

    return ind
endfun
