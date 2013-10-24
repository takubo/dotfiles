" Vim syntax file
" Language:	KAWASAKI AS
" Maintainer:	Allan Kelly <allan@fruitloaf.co.uk>
" Last Change:	Tue Sep 14 14:24:23 BST 1999

" First version based on Micro$soft QBASIC circa 1989, as documented in
" 'Learn BASIC Now' by Halvorson&Rygmyr. Microsoft Press 1989.
" This syntax file not a complete implementation yet.  Send suggestions to the
" maintainer.

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  "finish
endif

" A bunch of useful BASIC keywords
syn keyword basicStatement	ANY any Any BREAK break Break CALL call Call
syn keyword basicStatement	DO do Do LOOP loop Loop
syn keyword basicStatement	END end End
syn keyword basicStatement	ERROR error Error EXIT exit Exit
syn keyword basicStatement	FOR for For NEXT next Next
syn keyword basicStatement	GOTO goto Goto
syn keyword basicStatement	IF if If THEN then Then ELSE else Else ELSEIF elseif Elseif
syn keyword basicStatement	IFELSE ifelse Ifelse HALT halt Halt
syn keyword basicStatement	OF of Of OFF off Off ON on On
syn keyword basicStatement	PRINT print Print
syn keyword basicStatement	EX ex Ex EXCUTE excute Excute
syn keyword basicStatement	AB ab Ab ABORT abort Abort
syn keyword basicStatement	KILL kill Kill
syn keyword basicStatement	PCEX pcex Pcex PCEXCUTE pcexcute Pcexcute
syn keyword basicStatement	PCAB pcab Pcab PCABORT pcabort Pcabort
syn keyword basicStatement	PCKILL pckill Pckill
syn keyword basicStatement	RETURN return Return
syn keyword basicStatement	CASE case Case SCASE scase Scase
syn keyword basicStatement	TWAIT twait Twait
syn keyword basicStatement	SVALUE svalue Svalue STEP step Step
syn keyword basicStatement	TIMER timer Timer
syn keyword basicStatement	TYPE type Type
syn keyword basicStatement	TO to To
syn keyword basicStatement	UNTIL until Until
syn keyword basicStatement	VALUE value Value WAIT wait Wait
syn keyword basicStatement	WHILE while While

syn keyword basicFunction	ABS abs Abs ASC asc Asc
syn keyword basicFunction	COS cos Cos
syn keyword basicFunction	ERR err Err
syn keyword basicFunction	INP inp Inp INSTR instr Instr
syn keyword basicFunction	INT int Int
syn keyword basicFunction	LOG log Log
syn keyword basicFunction	POINT point Point
syn keyword basicFunction	QRR qrr Qrr RND rnd Rnd
syn keyword basicFunction	SIN sin Sin SQR sqr Sqr
syn keyword basicFunction	TAN tan Tan ATAN2 atan2 Atan2
syn keyword basicFunction	VAL val Val
syn keyword basicFunction	ZL3TRN ZL3JNT ZL3GET
syn keyword basicFunction	CHR$ Chr$ chr$ COMMAND$ command$ Command$
syn keyword basicFunction	ERDEV$ erdev$ Erdev$ HEX$ hex$ Hex$
syn keyword basicFunction	INKEY$ inkey$ Inkey$ INPUT$ input$ Input$
syn keyword basicFunction	LAFT$ laft$ Laft$ LTRIM$ ltrim$ Ltrim$
syn keyword basicFunction	MID$ mid$ Mid$ MKDMBF$ mkdmbf$ Mkdmbf$
syn keyword basicFunction	MKS$ mks$ Mks$ OCT$ oct$ Oct$
syn keyword basicFunction	RIGHT$ right$ Right$ RTRIM$ rtrim$ Rtrim$
syn keyword basicFunction	SPACE$ space$ Space$ STR$ str$ Str$
syn keyword basicFunction	STRING$ string$ String$ TIME$ time$ Time$
syn keyword basicTodo contained	TODO

"integer number, or floating point number without a dot.
syn match  basicNumber		"\<H\d\+\>"
"integer number, or floating point number without a dot.
syn match  basicNumber		"\<B\d\+\>"
"integer number, or floating point number without a dot.
syn match  basicNumber		"\<\d\+\>"
"floating point number, with dot
syn match  basicNumber		"\<\d\+\.\d*\>"
"floating point number, starting with a dot
syn match  basicNumber		"\.\d\+\>"

" String and Character contstants
syn match   basicSpecial contained "\\\d\d\d\|\\."
syn region  basicString		  start=+"+  skip=+\\\\\|\\"+  end=+"+  contains=basicSpecial

syn region  basicComment	start=";" end="$" contains=basicTodo
syn region  basicComment	start="^\.\*" end="$" contains=basicTodo
"syn region  basicLineNumber	start="^\d" end="\s"
syn match   basicTypeSpecifier  "[a-zA-Z0-9][\$%&!#]"ms=s+1
" Used with OPEN statement
syn match   basicFilenumber  "^\.\(PROGRAM\|JOINTS\|REALS\|STRINGS\|ROBOTDATA\d\|SYSDATA\d\?\|AUXDATA\d\?\|END\)"
"syn sync ccomment basicComment
syn match   basicLabel "^\w[\w\d]\*\:"
syn match   basicMathsOperator   "[<>+\-\*/^=]\|\<MOD\>\|\<BAND\>\|\<BOR\>\|\<COM\>\|\<AND\>\|\<OR\>\|\<NOT\>"
syn match   basicIfDef "^#.\+"

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_basic_syntax_inits")
  if version < 508
    let did_basic_syntax_inits = 1
    command! -nargs=+ HiLink hi link <args>
  else
    command! -nargs=+ HiLink hi def link <args>
  endif

  HiLink basicLabel		Label
  HiLink basicConditional	Conditional
  HiLink basicRepeat		Repeat
"  HiLink basicLineNumber	Comment
  HiLink basicNumber		Number
  HiLink basicError		Error
  HiLink basicStatement		Statement
  HiLink basicString		String
  HiLink basicComment		Comment
  HiLink basicSpecial		Special
  HiLink basicTodo		Todo
  HiLink basicFunction		Identifier
  HiLink basicTypeSpecifier	Type
  HiLink basicMathsOperator	Operator |"guifg=#60ffff   | "term=NONE cterm=NONE gui=NONE
  HiLink basicFilenumber	basicTypeSpecifier
  HiLink basicIfDef		PreProc
  "highlight basicIfDef		guibg=#ffaaff guifg=#000000

  delcommand HiLink
endif

let b:current_syntax = "as"

" vim: ts=8
