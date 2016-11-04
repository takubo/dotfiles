" Maintainer:	Henrique C. Alves (hcarvalhoalves@gmail.com)
" Version:      1.1
" Last Change:	September 23 2008

set background=dark

hi clear

if exists("syntax_on")
  syntax reset
endif

let colors_name = "Vitamin"

" Vim >= 7.0 specific colors
if version >= 700
  hi CursorLineNr guibg=#000000 guifg=#ffff00 gui=bold cterm=bold ctermfg=yellow cterm=underline
  hi CursorLineNr guibg=#000000 guifg=#ffff00 gui=NONE cterm=bold ctermfg=yellow cterm=underline
  "hi CursorLine guibg=#2d2d2d ctermbg=236
  hi CursorLine guibg=NONE gui=underline ctermbg=NONE cterm=underline
  hi CursorLine guibg=#121212 gui=underline ctermbg=NONE cterm=underline
  hi CursorLine guibg=#1a1a1a gui=underline ctermbg=NONE cterm=underline
  hi CursorLine guibg=NONE guifg=NONE gui=underline ctermbg=NONE cterm=underline
  "hi CursorColumn guibg=NONE gui=underline ctermbg=NONE cterm=underline
  hi CursorColumn term=reverse ctermbg=Black guibg=grey40
  hi CursorColumn guibg=#2d2d2d ctermbg=236
  hi CursorColumn guibg=#353535 ctermbg=236
  hi CursorColumn guibg=#303030 ctermbg=236 gui=underline
  hi CursorColumn guibg=#121212 ctermbg=236 gui=NONE
  hi CursorColumn guibg=#000000 ctermbg=236 gui=NONE
  hi MatchParen guifg=#f6f3e8 guibg=#857b6f gui=bold ctermbg=59
  hi Pmenu 	guifg=#f6f3e8 guibg=#444444 ctermbg=242
  hi PmenuSel 	guifg=#000000 guibg=#cdd129 ctermfg=0 ctermbg=184
endif

" General colors
"hi Search	guifg=Black guibg=#ff2222 "gui=reverse
"hi Search	guifg=Black guibg=#ffff44 "gui=reverse
"hi Search	guifg=#ffff44 guibg=#000000 gui=Bold
"hi Search	guifg=#000000 guibg=#00eeee gui=Bold
hi Search	guifg=#000000 guibg=#00eeee
hi SignColumn	guibg=Red guifg=White
hi FoldColumn	guibg=#444444 guifg=#ff5d28
hi TabLineFill	guibg=#343434 guifg=#343434
hi TabLine	guibg=#eeeeee guifg=#333333
hi TabLineSel	guibg=#111111 guifg=#a63318 "gui=bold gui=underline
hi TabLine	guifg=#ee8855 guibg=#333333
hi Cursor 	guifg=NONE    guibg=#c5c5c5 gui=none ctermbg=0x241 guifg=#d0d0d0
hi Cursor 	guifg=NONE    guibg=#656565 gui=none ctermbg=0x241 guifg=#d0d0d0
hi Cursor 	guifg=NONE    guibg=#656565 gui=none ctermbg=0x241
hi Cursor 	guifg=NONE    guibg=#000000 gui=none ctermbg=0x241
hi Cursor 	guifg=NONE    guibg=NONE gui=reverse ctermbg=0x241
hi Normal 	guifg=#f6f3f0 guibg=#242424 gui=none ctermfg=254 ctermbg=235
hi Normal 	guifg=#f6f3f0 guibg=#121212 gui=none ctermfg=254 ctermbg=235
hi NonText 	guifg=#808080 guibg=#303030 gui=none ctermfg=242 ctermbg=237
hi LineNr 	guifg=#5c5a4f guibg=#000000 gui=none ctermfg=239 ctermbg=232
hi StatusLine 	guifg=#f6f3e8 guibg=#444444 gui=none  | "italic
hi StatusLine 	guibg=#362318 guifg=#ff5d28 gui=none  | "italic
hi StatusLine 	guibg=#111111 guifg=#ff5d28 gui=none  | "italic
hi StatusLine 	guifg=#e6e3c8 guibg=#602f2f gui=none  | "italic
hi StatusLine 	guifg=#ff5d28 guibg=#602f2f gui=none  | "italic
hi StatusLine 	guifg=#010101 guibg=#df2d18 gui=none  | "italic
hi StatusLine 	guifg=#e6e3c8 guibg=#6f2f2f gui=none  | "italic
hi StatusLine 	guifg=#f6f3c8 guibg=#6f2f2f gui=none  | "italic
"hi StatusLine 	guibg=#444444 guifg=#9f5f5f gui=none  | "italic
hi StatusLineNC guifg=#857b6f guibg=#444444 gui=italic  |  "none
hi StatusLineNC guifg=#e6e3c8 guibg=#444444 gui=none  |  "none
hi StatusLineNC guibg=#111111 guifg=#666666 gui=none  |  "none
hi StatusLineNC guifg=#e6e3c8 guibg=#444444 gui=none  |  "none
hi VertSplit 	guifg=#444444 guibg=#444444 gui=none 
hi VertSplit 	guibg=#111111 guifg=#111111 gui=none 

hi VertSplit 	guifg=#ff5d28 guibg=#ff5d28 gui=none 
hi VertSplit 	guifg=#df9444 guibg=#444444 gui=none 
hi StatusLine	guibg=#ff7d58 guifg=#000000 gui=none  |  "none
hi StatusLineNC	guifg=#ff5d28 guibg=#000000 gui=none  |  "none
hi StatusLineNC	guifg=#5c5a4f guibg=#000000 gui=none  |  "none
hi StatusLineNC	guifg=#5c5a4f guibg=#7f1f1a gui=none  |  "none
hi StatusLineNC	guifg=#5c5a4f guibg=#6f0f0a gui=none  |  "none
hi StatusLineNC	guifg=#5c5a4f guibg=#400803 gui=none  |  "none
hi StatusLineNC	guifg=#5c5a4f guibg=#300a03 gui=none  |  "none
hi StatusLine	guifg=#ff2d18 guibg=#000000 gui=none  |  "none
hi StatusLine	guifg=#ffe3c8 guibg=#7f1f1a gui=none  | "italic
hi VertSplit 	guifg=#444444 guibg=#444444 gui=none 
hi VertSplit 	guifg=#242424 guibg=#242424 gui=none 
hi VertSplit	guifg=#300a03 guibg=#300a03 gui=none  |  "none
hi VertSplit	guifg=#5c5a4f guibg=#300a03 gui=none  |  "none
hi VertSplit 	guifg=#000000 guibg=#000000 gui=none 

hi Folded 	guibg=#384048 guifg=#a0a8b0 gui=none
hi Folded 	guibg=#232323 guifg=#b0b0b0 gui=none
hi Folded 	guibg=#252525 guifg=#c0c0c0 gui=none
hi Title	guifg=#f6f3e8 guibg=NONE	gui=bold 
hi Visual	guifg=#ffffd7 guibg=#444444 gui=none ctermfg=186 ctermbg=238
hi SpecialKey	guifg=#808080 guibg=#343434 gui=none
hi SpecialKey	guifg=#343434 guibg=#242424 gui=none
hi SpecialKey	guifg=#242424 guibg=#121212 gui=none

" Syntax highlighting
hi Comment 	guifg=#808080 ctermfg=244 | "gui=italic
hi Todo 	guifg=#8f8f8f gui=italic ctermfg=245
hi Constant 	guifg=#acf0f2 gui=none ctermfg=159
hi String 	guifg=#ff5d28 gui=none ctermfg=202
hi Identifier 	guifg=#ff5d28 gui=none ctermfg=202
hi Function 	guifg=#cdd129 gui=none ctermfg=184
hi Type 	guifg=#cdd129 gui=none ctermfg=184
hi Statement 	guifg=#af5f5f gui=none ctermfg=131
hi Keyword	guifg=#cdd129 gui=none ctermfg=184
hi PreProc 	guifg=#ede39e gui=none ctermfg=187
hi Number	guifg=#ede39e gui=none ctermfg=187
hi Special	guifg=#acf0f2 gui=none ctermfg=159


" Completion {{{
hi Pmenu	guifg=#5c5a4f guibg=#000000 gui=none ctermfg=239 ctermbg=232
hi Pmenu	guifg=#acaa7f guibg=#1a1a1a gui=none ctermfg=239 ctermbg=232
hi Pmenu	guifg=#dcda8f guibg=#1a1a1a gui=none ctermfg=239 ctermbg=232
"hi PmenuSel	guifg=#55ff55 guibg=#1a1a1a gui=none ctermfg=239 ctermbg=232
" Completion }}}


"""""""""""""""""""""""""""""""挿入モード時、ステータスラインの色を変更""""""""""""""""""""""""""""""

let g:hi_insert = 'highlight StatusLine guifg=darkblue guibg=darkyellow gui=none ctermfg=blue ctermbg=yellow cterm=none'
let g:hi_cmdwin = 'highlight StatusLine guifg=darkblue guibg=darkyellow gui=none ctermfg=blue ctermbg=yellow cterm=none'
if has('syntax')
	augroup InsertHook
		autocmd!
		autocmd InsertEnter * call s:StatusLine('IEnter')
		autocmd InsertLeave * call s:StatusLine('ILeave')
		autocmd CmdwinEnter * call s:StatusLine('CEnter')
		autocmd CmdWinLeave * call s:StatusLine('CLeave')
	augroup END
endif
let s:slhlcmd = ''
function! s:StatusLine(mode)
	if a:mode == 'IEnter'
		silent! let s:slhlcmd = 'highlight ' . s:GetHighlight('StatusLine')
		silent exec g:hi_insert
	elseif a:mode == 'CEnter'
		silent! let s:slhlcmd = 'highlight ' . s:GetHighlight('StatusLine')
		silent exec g:hi_cmdwin
	else
		highlight clear StatusLine
		silent exec s:slhlcmd
	endif
endfunction

function! s:GetHighlight(hi)
	redir => hl
	exec 'highlight '.a:hi
	redir END
	let hl = substitute(hl, '[\r\n]', '', 'g')
	let hl = substitute(hl, 'xxx', '', '')
	return hl
endfunction

" For Statusline
hi SLWinNr guifg=#000000 guibg=#e6e3c8 gui=bold cterm=bold ctermfg=yellow cterm=underline
hi SLWinNr guibg=#ffffff guifg=#a63318 gui=bold
hi SLWinNr guibg=#ffffff guifg=#a64348 gui=bold
hi SLWinNr guibg=#ffffff guifg=#a64348 gui=bold
hi SLFileName guifg=#ede39e guibg=#000000
hi SLFileName guifg=#a63318 guibg=#000000
hi SLFileName guifg=red guibg=#000000
hi SLFileName guifg=#cf302d guibg=#000000
"hi SLFileName guifg=#7f1f1a guibg=#000000
"hi SLFileName guifg=#ffffff guibg=#000000

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


set transparency=244

set guicursor=n-v-c:block-Cursor/lCursor,ve:ver35-Cursor,o:hor50-Cursor,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor,a:blinkon0

"set guifont=MeiryoKe_Gothic:h9.5:cSHIFTJIS
"set guifont=MeiryoKe_Console:h9.5:cSHIFTJIS
set guifont=MeiryoKe_Console:h9:w4.4

let s:FontName="MeiryoKe_Console"
let s:FontHeight=9
let s:FontWidth=4.4

let s:FontHeight=8.5
let s:FontWidth=4.15
let s:FontWidth=4.0

let s:MinFontHeight=2.0
let s:MinFontWidth=1.0

function! ResizeFont(a)
  if a:a != 0
    let s:CurFontHeight += a:a
    let s:CurFontWidth  += a:a * 0.5
    "let s:CurFontWidth  += a:a * (s:CurFontWidth / s:CurFontHeight)
    if s:CurFontHeight < s:MinFontHeight | let s:CurFontHeight = s:MinFontHeight | endif
    if s:CurFontWidth  < s:MinFontWidth  | let s:CurFontWidth  = s:MinFontWidth  | endif
  else
    let s:CurFontHeight = s:FontHeight
    let s:CurFontWidth  = s:FontWidth
  endif
  exe "set guifont=" . s:FontName . ":h" . printf("%.2f", s:CurFontHeight) . ":w" . printf("%.2f", s:CurFontWidth)
  let g:CurFontHeight=s:CurFontHeight
  let g:CurFontWidth=s:CurFontWidth
endfunction

call ResizeFont(0)

nnoremap <silent> <Home> :<C-u>call ResizeFont(+0.5)<CR>
nnoremap <silent> <End>  :<C-u>call ResizeFont(-0.5)<CR>
nnoremap <silent> <C-Home> :<C-u>call ResizeFont(0)<CR>
nnoremap <silent> <C-End>  :<C-u>call ResizeFont(0)<CR>
nnoremap <silent> <S-End>  :<C-u>call ResizeFont(-99999)<CR>

"exe "set guifont=" . s:FontName . ":h" . printf("%.1f", s:MinFontHeight) . ":w" . printf("%.1f", s:MinFontWidth)

"
"hi	DiffAdd		term=bold	ctermbg=1	guibg=DarkBlue
"hi	DiffChange	term=bold	ctermbg=5	guibg=DarkMagenta
"hi	DiffText	term=reverse	cterm=bold	ctermbg=12	gui=bold	guibg=Red
"hi	DiffDelete	term=bold	ctermfg=9	ctermbg=3	gui=bold	guifg=Blue	guibg=DarkCyan

hi	DiffAdd		term=bold	ctermbg=1			gui=NONE	guibg=#550000		guifg=NONE
hi	DiffDelete	term=bold	ctermfg=9	ctermbg=3	gui=NONE	guibg=#331111		guifg=#333333

hi	DiffAdd		term=bold	ctermbg=1			gui=NONE	guibg=#4c1111		guifg=NONE
hi	DiffDelete	term=bold	ctermfg=9	ctermbg=3	gui=NONE	guibg=#333333		guifg=#333333

hi	DiffAdd		term=bold	ctermbg=1			gui=NONE	guibg=#511111		guifg=NONE
hi	DiffDelete	term=bold	ctermfg=9	ctermbg=3	gui=NONE	guibg=#3c1111		guifg=#333333
hi	DiffDelete	term=bold	ctermfg=9	ctermbg=3	gui=NONE	guibg=#11115c		guifg=#333333

hi	DiffAdd		term=bold	ctermbg=1			gui=NONE	guibg=#581111		guifg=NONE
hi	DiffDelete	term=bold	ctermfg=9	ctermbg=3	gui=NONE	guibg=#2c1111		guifg=#333333
hi	DiffChange	term=bold	ctermbg=5			gui=NONE	guibg=#555500	guifg=NONE
hi	DiffText	term=reverse	cterm=bold	ctermbg=12	gui=NONE	guibg=DarkMagenta		guifg=NONE
hi	DiffText	term=reverse	cterm=bold	ctermbg=12	gui=NONE	guibg=DarkRed		guifg=NONE
hi	DiffText	term=reverse	cterm=bold	ctermbg=12	gui=NONE	guibg=DarkMagenta		guifg=NONE
"hi	DiffText	term=reverse	cterm=bold	ctermbg=12	gui=NONE	guibg=Darkyellow		guifg=white


hi	DiffAdd		term=bold	ctermbg=1			gui=NONE	guibg=#581111		guifg=NONE
hi	DiffAdd		term=bold	ctermbg=1			gui=NONE	guibg=#481111		guifg=NONE
hi	DiffDelete	term=bold	ctermfg=9	ctermbg=3	gui=NONE	guibg=#755332		guifg=#333333
hi	DiffDelete	term=bold	ctermfg=9	ctermbg=3	gui=NONE	guibg=#327553		guifg=#333333
hi	DiffDelete	term=bold	ctermfg=9	ctermbg=3	gui=NONE	guibg=#326553		guifg=#333333
hi	DiffChange	term=bold	ctermbg=5			gui=NONE	guibg=#755332	guifg=NONE
hi	DiffChange	term=bold	ctermbg=5			gui=NONE	guibg=#453020	guifg=NONE
hi	DiffText	term=reverse	cterm=bold	ctermbg=12	gui=NONE	guibg=DarkMagenta		guifg=NONE

hi	qfFileName	guifg=#c0504d

hi	ErrorMsg	guifg=black	guibg=#cdd129
hi	ErrorMsg	guifg=black	guibg=#ffd129
"hi	ErrorMsg	guifg=black	guibg=Darkyellow

hi	Search	guibg=#c0504d	guifg=white

" #c0504d
