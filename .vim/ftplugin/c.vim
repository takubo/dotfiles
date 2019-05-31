" Vim filetype plugin file
" Language:	C
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last Change:	2016 Jun 12

" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
  "finish
endif

" Don't load another plugin for this buffer
let b:did_ftplugin = 1

" Using line continuation here.
let s:cpo_save = &cpo
set cpo-=C

let b:undo_ftplugin = "setl fo< com< ofu< | if has('vms') | setl isk< | endif"

" Set 'formatoptions' to break comment lines but not other lines,
" and insert the comment leader when hitting <CR> or using "o".
setlocal fo-=t fo+=croql

" Set completion with CTRL-X CTRL-O to autoloaded function.
if exists('&ofu')
  setlocal ofu=ccomplete#Complete
endif

" Set 'comments' to format dashed lists in comments.
setlocal comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,://

" In VMS C keywords contain '$' characters.
if has("vms")
  setlocal iskeyword+=$
endif

" When the matchit plugin is loaded, this makes the % command skip parens and
" braces in comments.
let b:match_words = &matchpairs . ',^\s*#\s*if\(\|def\|ndef\)\>:^\s*#\s*elif\>:^\s*#\s*else\>:^\s*#\s*endif\>'
let b:match_skip = 's:comment\|string\|character\|special'

" Win32 can filter files in the browse dialog
if (has("gui_win32") || has("gui_gtk")) && !exists("b:browsefilter")
  if &ft == "cpp"
    let b:browsefilter = "C++ Source Files (*.cpp *.c++)\t*.cpp;*.c++\n" .
	  \ "C Header Files (*.h)\t*.h\n" .
	  \ "C Source Files (*.c)\t*.c\n" .
	  \ "All Files (*.*)\t*.*\n"
  elseif &ft == "ch"
    let b:browsefilter = "Ch Source Files (*.ch *.chf)\t*.ch;*.chf\n" .
	  \ "C Header Files (*.h)\t*.h\n" .
	  \ "C Source Files (*.c)\t*.c\n" .
	  \ "All Files (*.*)\t*.*\n"
  else
    let b:browsefilter = "C Source Files (*.c)\t*.c\n" .
	  \ "C Header Files (*.h)\t*.h\n" .
	  \ "Ch Source Files (*.ch *.chf)\t*.ch;*.chf\n" .
	  \ "C++ Source Files (*.cpp *.c++)\t*.cpp;*.c++\n" .
	  \ "All Files (*.*)\t*.*\n"
  endif
endif

let &cpo = s:cpo_save
unlet s:cpo_save



"""""""""" Takubo Add



iab CS /*
if exists("*Eatchar")
  iab <silent> CE */<C-R>=Eatchar('\s')<CR>
else
  iab          CE */
endif
iab CC //

" /* */コメントを楽に入れる
inoremap <buffer><expr> @ (<SID>in_str() != 0) ? '@' : '/*  */<left><left><left>'

" 文字列を楽に入れる
inoremap <buffer><expr> $ (<SID>in_str() != 0) ? '$' : '""<left>'



nnoremap [[  [[k0f(bzt
nnoremap g[[ [[k0f(b
nnoremap ]]  :call <SID>jump_to_next_func()<CR>zt
nnoremap g]] :call <SID>jump_to_next_func()<CR>
function! s:jump_to_next_func()
  let fline = line('.')
  normal! ]]k0f(b
  if fline == line('.')
    normal! j]]k0f(b
  end
endfunc

vnoremap [[ [[k

vnoremap af ][<ESC>V[[kk



""""" Grep
if 0
  noremap <buffer> <leader>r :vimgrep 
  noremap <buffer> <leader>g :set nocursorline<CR>:vimgrep /\C\<<C-r><C-w>\>/j *c *.h *.s *.S<CR>:set cursorline<CR>
  noremap <buffer> <leader>G :set nocursorline<CR>:grep "\C\<<C-r><C-w>\>" *c *.h *.s *.S<CR>:set cursorline<CR>
  noremap <buffer> <leader>w :vimgrep <C-r><C-w>
  noremap <buffer> <leader>i :vimgrep /<S-Insert>/j *c *.h *.s *.S<CR>
endif


"finish



""""" 演算子の間に空白を入れる

if exists("smartchr#one_of")
  inoremap <buffer><expr> + (<SID>in_str() != 0) ? '+' : smartchr#one_of(' + ', '++', '+')

  inoremap <buffer><expr> - (<SID>in_str() != 0) ? '-' : smartchr#one_of(' - ', '--', '-')

  inoremap <buffer><expr> % (<SID>in_str() != 0) ? '%' : smartchr#one_of(' % ', '%')

  inoremap <buffer><expr> ^ (<SID>in_str() != 0) ? '^' : smartchr#one_of(' ^ ', '^')

  inoremap <buffer><expr> ~ (<SID>in_str() != 0) ? '~' : smartchr#one_of(' ~ ', '~')

  inoremap <buffer><expr> <Bar> (<SID>in_str() != 0) ? '<Bar>' : smartchr#one_of(' <Bar> ', ' <Bar><Bar> ', '<Bar>')

  inoremap <buffer><expr> < (<SID>in_str() != 0) ? '<' : search('^#include\%#', 'bcn') ? ' <' : smartchr#one_of(' < ', ' << ', '<')

  inoremap <buffer><expr> > (<SID>in_str() != 0) ? '>' : search('^#include <.*\%#', 'bcn') ? '>' : smartchr#one_of(' > ', ' >> ', '>')

  inoremap <buffer><expr> = (<SID>in_str() != 0) ? '=' : Imap_eq('=')

  " 「->」は入力しづらいので、..で置換え
  inoremap <buffer><expr> . (<SID>in_str() != 0) ? '.' : smartchr#one_of('.', '->', '..')

  " 3項演算子
  inoremap <buffer><expr> ? (<SID>in_str() != 0) ? '?' : smartchr#one_of(' ? ', '?')
  inoremap <buffer><expr> : (<SID>in_str() != 0) ? ':' : smartchr#one_of(' : ', ':')

  " * はポインタで使う
  inoremap <buffer><expr> * (<SID>in_str() != 0) ? '*' :
	\ ( search('\(&\<bar><bar>\<bar>+\<bar>-\<bar>\*\<bar>/\<bar>%\<bar>\^\<bar>>\<bar><\<bar>=\<bar>?\<bar>:\<bar>,\) \?\%#', 'bcn')
	\ <bar><bar> search('\(^\<bar>{\)\s*\%#', 'bcn') <bar><bar> search('(\%#', 'bcn') ) ? '*' :
	\ search('\(^\<bar>,\<bar>(\<bar>{\)\s*\(\w\s*\)*\i\+\s\?\%#', 'bcn') ? ' *' : smartchr#one_of(' * ', '*', '* ')

  " & は参照で使う
  inoremap <buffer><expr> & (<SID>in_str() != 0) ? '&' :
	\ search('\(<bar>\<bar>+\<bar>-\<bar>\*\<bar>/\<bar>%\<bar>\^\<bar>>\<bar><\<bar>=\<bar>?\<bar>:\<bar>,\) \?\%#', 'bcn')
	\ ?  smartchr#one_of('&', ' & ') : smartchr#one_of(' & ', ' && ', '&')

  " //コメントを楽に入れる
  inoremap <buffer><expr> / search('\(^\<bar>;\<bar>{\<bar>}\<bar>,\)\s*/\?/\?\s\?\%#','bcn') ? smartchr#one_of('// ', '//', '\<bs>/') : smartchr#one_of(' / ', '/')
endif



" if/switch/for/while文直後の(は自動で間に空白を入れる
"iunmap <buffer> ((
inoremap <buffer><expr> ( search('\<\(if\\|switch\\|for\\|while\)\%#', 'bcn') ? ' (' : '('



""""" セミコロンの自動挿入

function! s:semicolon()
  if search('^#.*\%#', 'bcn')
    "全てのプリプロセッサ命令行
  elseif search('\%#;', 'cn')
    "カーソル位置には既に;がある (これがないと、行末のセミコロンでEscしたとき、また;が付く。)
  elseif search('\%#,', 'cn')
    "カーソル位置に,がある (これがないと、TODO でEscしたとき、また;が付く。)
  elseif search('\([_0-9a-zA-Z)\]"'']\|++\|--\)\%#', 'bcn') || search('^\s*\i.*=\s\?{.*}\%#', 'bcn')
    "カーソル前が、イデンティファー文字、)、]、"、' のいずれか。	または、初期化付き配列宣言。
    "TODO 関数定義の終了以外の行頭の}
    if search('^\i.*\%#', 'bcn')
      "行頭がイデンティファー文字
      "関数定義、ラベルなのでセミコロンはなし
      "TODO グローバル変数の定義
    else
      if search('^\s*\(if\|else\|switch\|while\|for\).*\%#', 'bcn')
	"制御行
      elseif search('\%#.\s*$', 'cn') || search("\\%#.\\s*\\(/\\*\\\<bar>//\\)", 'cn') || !search('\%#..\+', 'cn') || search('\%#.\s*["''\w]', 'cn')
	"カーソル後には空白しかないか、カーソル後には空白+コメントしかないか、カーソル後に文字がない.			または、別の文が右にある。
	return ';'
      endif
    endif
  endif
  return ''
endfunction

"inoremap <buffer><expr>	<CR>	pumvisible() ? '<C-y>' : (<SID>in_str() != 0) ? '<CR>' : <SID>semicolon() . '<CR>'
"inoremap <buffer><expr>	<ESC>	pumvisible() ? '<C-e>' : (<SID>in_str() != 0) ? '<ESC>' : <SID>semicolon() . '<ESC>'
"inoremap <buffer><expr>	<CR>	pumvisible() ? '<C-y>' : (<SID>in_str() != 0) && (Get_highlight_info(0, 1) != 0) ? '<CR>' : <SID>semicolon() . '<CR>'
"inoremap <buffer><expr>	<ESC>	pumvisible() ? '<C-e>' : (<SID>in_str() != 0) && (Get_highlight_info(0, 1) != 0) ? '<ESC>' : <SID>semicolon() . '<ESC>'
inoremap <buffer><expr>	<CR>	pumvisible() ? '<C-y>' : (Get_highlight_info(0, 1) != 0) ? '<CR>' : <SID>semicolon() . '<CR>'
"inoremap <buffer><expr>	<ESC>	pumvisible() ? '<C-e>' : (Get_highlight_info(0, 1) != 0) ? '<ESC>' : <SID>semicolon() . '<ESC>'

function! C_Semicolon2()
  return <SID>semicolon()
endfunction
function! C_Semicolon()
  if &ft != 'c'
    return ''
  endif
  "sleep 1
  "echo "@@@@ " Get_highlight_info(0, 1) 
  if Get_highlight_info(0, 1) == 0
    "return feedkeys(<SID>semicolon(), 'ntx')
    exe "silent noa normal! a\<C-r>=C_Semicolon2()\<CR>"
  endif
endfunction

augroup C_Semicolon
  au!
  "au InsertLeave *.c call C_Semicolon()
  au InsertLeave * call C_Semicolon()
augroup end

"call IEscPre_Add('C_Semicolon')

""""" Snipet

if 0
  function! s:Tab()
    if pumvisible()
      call feedkeys("\<C-n>")
      return ''
    else
      return TriggerSnippet()
    endif
  endfunction

  "inoremap <buffer>	<Tab>	<C-R>=<SID>Tab()<CR>
  inoremap <buffer>	<Tab>	<C-R>=TriggerSnippet()<CR>
  inoremap <buffer><expr>	<S-Tab>	pumvisible() ? '<C-p>' : '<C-p><C-n>'
endif


""""" 補完

"so $HOME/.vim/macros/complete.vim
"inoremap <buffer><expr> . pumvisible() ? "\<C-E>.\<C-X>\<C-O>\<C-N>" : ".\<C-X>\<C-O>\<C-N>"



""""" in_str()

"let s:mdHed = -99	"行頭
let s:mdSlsh = -3	"単独/ (コメント開始記号の開始の可能性がある)
let s:mdLCmt = -2	"ラインコメント
let s:mdBCmt = -1	"ブロックコメント
let s:mdNon  =  0	"デフォルト
let s:mdStr  =  1	"文字列

function! s:in_str()
  let mode = s:mdNon
  let lin = getline(".")
  let col = col(".") - 1
  "let str = strpart(lin, 0, col - 1)
  "echo strpart(lin, 0, col)
  let i = 0
  while i < col
    let chr = strpart(lin, i, 1) | let i += 1
    if chr == '/'
      if i < col
	let chr = strpart(lin, i, 1) | let i += 1
	if chr == '*'
	  let mode = s:mdBCmt
	  while i < col
	    let chr = strpart(lin, i, 1)| let i += 1
	    if chr == '*'
	      if i < col
		let chr = strpart(lin, i, 1)| let i += 1
		if chr == '/'
		  let mode = s:mdNon
		endif
	      endif
	    endif
	  endwhile
	elseif chr == '/'
	  let mode = s:mdLCmt
	endif
      elseif
	let mode = s:mdSlsh
      endif
    elseif chr == '"'
      let mode = s:mdStr
      while i < col
	let chr = strpart(lin, i, 1)| let i += 1
	if chr == '\\'
	  if i < col
	    let chr = strpart(lin, i, 1)| let i += 1
	  endif
	  continue
	elseif chr == '"'
	  let mode = s:mdNon
	endif
      endwhile
    elseif chr == "'"
      let mode = s:mdStr
      while i < col
	let chr = strpart(lin, i, 1)| let i += 1
	if chr == '\\'
	  if i < col
	    let chr = strpart(lin, i, 1)| let i += 1
	  endif
	  continue
	elseif chr == "'"
	  let mode = s:mdNon
	endif
      endwhile
    else
      let mode = s:mdNon
    endif
  endwhile
  "echo chr
  return mode
endfunction

func! s:in_str_test()
    echo <SID>in_str()
endfunc
com! InStrTest :call <SID>in_str_test()

"TODO case行でコロンの自動付加
"TODO 単独elseの後に；を付加しないようにする。
so $VIMRUNTIME/pack/takubo/start/tmp/plugin/test.vim


" CUSTOMER CUSTOMER ------------------------------------------------------------------------------

syn keyword	cType		ulong ushort uchar RAM_location ROM_location
syn keyword	cError	__DI __EI
syn keyword	cString	__DI __EI

" CUSTOMER end -----------------------------------------------------------------------------------
