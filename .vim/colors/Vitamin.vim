scriptencoding utf-8
" vim:set ts=8 sts=2 sw=2 tw=0: (この行に関しては:help modelineを参照)
"
" Maintainer:	Henrique C. Alves (hcarvalhoalves@gmail.com)
" Version:      1.1
" Last Change:	September 23 2008
"

" favarite color
"	#c0504d


set background=dark
hi clear

if exists("syntax_on")
  syntax reset
endif

let colors_name = "Vitamin"


" Vim >= 7.0 specific colors
if version >= 700
  hi CursorLineNr	guibg=#000000 guifg=#ffff00 gui=NONE cterm=bold ctermfg=yellow cterm=underline
  hi CursorLine	guibg=NONE guifg=NONE gui=underline ctermbg=NONE cterm=underline
  hi CursorColumn	guibg=#000000 ctermbg=236 gui=NONE
  hi CursorColumn	guibg=#121212 ctermbg=236 gui=NONE
  hi MatchParen	guifg=#f6f3e8 guibg=#857b6f gui=bold ctermbg=59
  hi Pmenu	guifg=#dcda8f guibg=#1a1a1a gui=none ctermfg=239 ctermbg=232
  hi PmenuSel 	guifg=#000000 guibg=#cdd129 ctermfg=0 ctermbg=184
  hi PmenuSel 	guifg=#000000 guibg=#c0504d ctermfg=0 ctermbg=184
  hi PmenuSbar 	guifg=#000000 guibg=black ctermfg=0 ctermbg=184
  hi PmenuThumb 	guifg=#000000 guibg=white ctermfg=0 ctermbg=184
endif


" General colors
"hi Search	guifg=#000000 guibg=#00eeee
hi Search	guibg=#c0504d	guifg=white
hi SignColumn	guibg=Red guifg=White
hi FoldColumn	guibg=#444444 guifg=#ff5d28
hi TabLineFill	guifg=#8f3338 guibg=#A4A4A4
hi TabLineFill	guibg=#343434 guifg=#343434
hi TabLineFill	guibg=black guifg=#343434
hi TabLineFill2	guibg=#181818 guifg=#181818
hi TabLineSel	guibg=#111111 guifg=#a63318 gui=underline gui=bold
hi TabLine	guifg=#ee8855 guibg=#333333
hi Cursor 	guifg=NONE    guibg=NONE gui=reverse ctermbg=0x241
hi Normal 	guifg=#f6f3f0 guibg=#121212 gui=none ctermfg=254 ctermbg=235
hi SpecialKey	guifg=#242424 guibg=#121212 gui=none
hi SpecialKey	guifg=#202020 guibg=#121212 gui=none
hi Normal 	guifg=#f6f3f0 guibg=#181818 gui=none ctermfg=254 ctermbg=235
hi Normal 	guifg=#f6f3f0 guibg=#1C1C1C gui=none ctermfg=254 ctermbg=235
hi Normal 	guifg=#f6f3f0 guibg=#222222 gui=none ctermfg=254 ctermbg=235
hi Normal 	guifg=#f6f3f0 guibg=#202020 gui=none ctermfg=254 ctermbg=235
hi SpecialKey	guifg=#2D2D2D guibg=#222222 gui=none
hi NonText 	guifg=#808080 guibg=#303030 gui=none ctermfg=242 ctermbg=237
hi LineNr 	guifg=#5c5a4f guibg=#000000 gui=none ctermfg=239 ctermbg=232
hi Folded 	guibg=#252525 guifg=#c0c0c0 gui=none
hi Title	guifg=#f6f3e8 guibg=NONE	gui=bold
hi Visual	guifg=#ffffd7 guibg=#444444 gui=none ctermfg=186 ctermbg=238
hi StatusLine 	guifg=#f6f3c8 guibg=#6f2f2f gui=none  | "italic
hi StatusLine	guibg=#ff7d58 guifg=#000000 gui=none  |  "none
hi StatusLine	guifg=#ff2d18 guibg=#000000 gui=none  |  "none
hi StatusLine	guifg=#ede39e guibg=#7f1f1a gui=none  | "italic
hi StatusLine	guifg=black guibg=#7f1f1a gui=none  | "italic
hi StatusLine	guifg=#efb398 guibg=#7f1f1a gui=none  | "italic
hi StatusLine	guifg=#ffe3c8 guibg=#7f1f1a gui=none  | "italic
hi StatusLine2	guifg=black guibg=#7f1f1a gui=none  | "italic
hi StatusLine	guifg=black guibg=#7f1f1a gui=none  | "italic
hi StatusLine	guifg=#141414 guibg=#7f1f1a gui=none  | "italic
hi StatusLine	guifg=#efd3b8 guibg=#7f1f1a gui=none  | "italic
hi StatusLineTerm	guifg=#efd3b8 guibg=#df2a1a gui=none  | "italic
hi StatusLineTerm	guifg=#efd3b8 guibg=#df2a1a gui=none  | "italic
hi StatusLineTerm	guifg=#efd3b8 guibg=#8f1a02 gui=none  | "italic
hi StatusLineTerm	guifg=#efd3b8 guibg=#d0330b gui=none  | "italic
"hi StatusLineTermNC	guifg=#efd3b8 guibg=#af1a0a gui=none  | "italic
"hi StatusLineTermNC	guifg=#efd3b8 guibg=#480d01 gui=none  | "italic
hi StatusLineTermNC	guifg=#efd3b8 guibg=#701a06 gui=none  | "italic
hi StatusLineTermNC	guifg=#8f7368 guibg=#6d2006 gui=none  | "italic
hi StatusLineNC	guifg=#5c5a4f guibg=#300a03 gui=none  |  "none
hi StatusLineNC	guifg=#343434 guibg=#300a03 gui=none  |  "none
hi StatusLineNC	guifg=#444444 guibg=#300a03 gui=none  |  "none
"hi StatusLine	guifg=#695753 guibg=#500f05 gui=none  |  "none
"hi StatusLineNC	guifg=#5c5a4f guibg=#200501 gui=none  |  "none
hi StatusLineDate	guifg=#5c5a4f guibg=#7f1f1a
hi StatusLineDate	guifg=#efd3b8 guibg=#7f1f1a gui=none  | "italic
hi StatusLineDate	guifg=#5c5a4f guibg=NONE
"hi StatuslineFile	guifg=#acf0f2 gui=none ctermfg=159
hi StatuslineFile	guifg=white guibg=black
hi StatuslineFile	guifg=#acf0f2 guibg=black
hi VertSplit	guifg=#300a03 guibg=#300a03 gui=none  |  "none
hi VertSplit	guifg=#5c5a4f guibg=#300a03 gui=none  |  "none
hi VertSplit	guifg=#000000 guibg=#000000 gui=none
hi VertSplit	guifg=#4c4a3f guibg=#300a03 gui=none
hi VertSplit	guifg=#5c5a4f guibg=#300a03 gui=none
hi VertSplit	guifg=#424035 guibg=#300a03 gui=none
hi VertSplit	guifg=#300a03 guibg=#300a03 gui=none
hi VertSplit	guifg=#000000 guibg=#300a03 gui=none
hi VertSplit	guifg=#121212 guibg=#300a03 gui=none
hi VertSplit	guifg=#7f1f1a guibg=black gui=none
hi VertSplit	guifg=#7f1f1a guibg=#121212 gui=none
hi Red	guifg=#d63a3a guibg=black
hi yellow	guifg=#f6f3f0 guibg=black
hi yellow	guifg=#ffd90b
hi yellow	guifg=#3ad6d6
hi yellow	guifg=#f75ecb
hi gold		guifg=gold


" For Statusline
hi SLWinNr	guibg=#ffffff guifg=#a64348 gui=bold
hi SLFileName	guifg=#cf302d guibg=#000000


" gui cursor
set guicursor=n-v-c:block-Cursor/lCursor,ve:ver35-Cursor,o:hor50-Cursor,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor,a:blinkon0
set guicursor=n-v-c:block-Cursor/lCursor,ve:ver35-Cursor,o:hor50-Cursor,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor,a:blinkon0
set guicursor=n-v-c:ver10-Cursor/lCursor,ve:ver35-Cursor,o:hor50-Cursor,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor,a:blinkon0


" supplemental
hi qfFileName	guifg=#c0504d
hi ErrorMsg	guifg=black	guibg=#ffd129


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


" transparency
set transparency=244


" Diff
"hi DiffChange	guifg=NONE	guibg=#191919	gui=none	ctermfg=NONE	ctermbg=235
hi DiffChange	guibg=#755332	guifg=NONE	gui=NONE	term=bold	ctermbg=5
hi DiffChange	guibg=#453020	guifg=NONE	gui=NONE	term=bold	ctermbg=5
hi DiffChange	guibg=NONE	guifg=NONE	gui=NONE	term=NONE	ctermbg=NONE
hi DiffText	guibg=#b505b5	guifg=NONE	gui=NONE	term=reverse	ctermbg=12	cterm=bold
hi DiffText	guibg=#850585	guifg=NONE	gui=NONE	term=reverse	ctermbg=12	cterm=bold
hi DiffText	guibg=Red	guifg=NONE	gui=NONE	term=reverse	ctermbg=12	cterm=bold
hi DiffText	guibg=#780578	guifg=NONE	gui=NONE	term=reverse	ctermbg=12	cterm=bold
hi DiffText	guibg=NONE	guifg=NONE	gui=reverse	term=reverse	ctermbg=12	cterm=bold
hi DiffText	guibg=#686888	guifg=NONE	gui=NONE	term=reverse	ctermbg=12	cterm=bold
hi DiffText	guibg=#585878	guifg=NONE	gui=NONE	term=reverse	ctermbg=12	cterm=bold
hi DiffText	guibg=#303080	guifg=NONE	gui=NONE	term=reverse	ctermbg=12	cterm=bold
hi DiffText	guibg=#303088	guifg=NONE	gui=NONE	term=reverse	ctermbg=12	cterm=bold
hi DiffAdd	guibg=#111138	guifg=NONE	gui=NONE	term=bold	ctermbg=1
hi DiffAdd	guibg=#381111	guifg=NONE	gui=NONE	term=bold	ctermbg=1
hi DiffAdd	guibg=#301111	guifg=NONE	gui=NONE	term=bold	ctermbg=1
hi DiffDelete	guibg=#112311	guifg=#2a2a2a	gui=NONE	term=bold	ctermbg=3	ctermfg=9
hi DiffDelete	guibg=#111138	guifg=#2a2a2a	gui=NONE	term=bold	ctermbg=1
hi DiffDelete	guibg=#111130	guifg=#2a2a2a	gui=NONE	term=bold	ctermbg=1


"""""""""""""""""""""""""""""""挿入モード時、ステータスラインの色を変更""""""""""""""""""""""""""""""

let s:hi_insert = 'highlight	StatusLine	guifg=white	guibg=#1a1f7f		gui=none	ctermfg=blue	ctermbg=yellow	cterm=none'
let s:hi_cmdwin = 'highlight	StatusLine	guifg=darkblue	guibg=darkyellow	gui=none	ctermfg=blue	ctermbg=yellow	cterm=none'
let s:slhlcmd = ''

if has('syntax')
  augroup InsertHook
    au!
    au InsertEnter * call s:StatusLine('IEnter')
    au InsertLeave * call s:StatusLine('ILeave')
    au CmdwinEnter * call s:StatusLine('CEnter')
    au CmdWinLeave * call s:StatusLine('CLeave')
  augroup END
endif

function! s:StatusLine(mode)
  if a:mode == 'IEnter'
    silent! let s:slhlcmd = 'highlight ' . s:GetHighlight('StatusLine')
    silent exec s:hi_insert
  elseif a:mode == 'CEnter'
    silent! let s:slhlcmd = 'highlight ' . s:GetHighlight('StatusLine')
    silent exec s:hi_cmdwin
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


"""""""""""""""""""""""""""""""フォントサイズ""""""""""""""""""""""""""""""

if has('win32') || has('win64')
  let s:FontName		= "MeiryoKe_Console"
  "let s:FontHeight	= 9.5
  "let s:FontWidth	= 4.5
  "let s:FontWidth	= 4.45
  let s:FontHeight	= 9.0
  let s:FontWidth		= 4.2
  let s:FontHeight	= 9.0
  let s:FontWidth		= 4.5
  let s:FontHeight	= 8.5
  let s:FontWidth		= 4.5
  let s:MinFontHeight	= 2.0
  let s:MinFontWidth	= 1.0
  let s:FontK		= 0.5
endif

com! Font echo '' &guifont

function! ResizeFont(r)
  if a:r != 0
    let s:CurFontHeight += a:r
    let s:CurFontWidth  += a:r * s:FontK
    "let s:CurFontWidth += a:r * (s:CurFontWidth / s:CurFontHeight)
    if s:CurFontHeight < s:MinFontHeight | let s:CurFontHeight = s:MinFontHeight | endif
    if s:CurFontWidth  < s:MinFontWidth  | let s:CurFontWidth  = s:MinFontWidth  | endif
  else	" デフォルトサイズに戻す
    let s:CurFontHeight = s:FontHeight
    let s:CurFontWidth  = s:FontWidth
  endif
  exe "set guifont=" . s:FontName . ":h" . printf("%.2f", s:CurFontHeight) . ":w" . printf("%.2f", s:CurFontWidth)
  let g:CurFontHeight=s:CurFontHeight
  let g:CurFontWidth=s:CurFontWidth
  simalt ~x

endfunction

" mapping
nnoremap <Home>		:<C-u>call ResizeFont(+0.5)<CR>:Font<CR>
nnoremap <End>		:<C-u>call ResizeFont(-0.5)<CR>:Font<CR>
nnoremap <C-Home>	:<C-u>call ResizeFont(0)<CR>:Font<CR>
nnoremap <C-End>	:<C-u>call ResizeFont(0)<CR>:Font<CR>
nnoremap <S-End>	:<C-u>call ResizeFont(-99999)<CR>:Font<CR>

" initialize
"exe 'set guifont=' . s:FontName . ':h' . s:FontHeight . ':w' s:FontWidth
call ResizeFont(0)


" func_name
"kari hi hl_func_name		guifg=#cdd129	gui=none	ctermfg=184
hi hl_func_name		guibg=Red	guifg=white	gui=none	ctermfg=202
hi hl_func_name		guibg=NONE	guifg=#ff5d28	gui=none	ctermfg=202
hi hl_func_name		guifg=#acf0f2	gui=none	ctermfg=159
hi hl_func_name		guifg=#cdd129	gui=none	ctermfg=184
hi hl_func_name_stl	guibg=black guifg=white	gui=none	ctermfg=184
hi hl_func_name_stl	guibg=black guifg=#cdd129	gui=none	ctermfg=184
hi hl_func_name_stl	guibg=black guifg=#85dfb0	gui=none	ctermfg=184
hi hl_func_name_stl	guibg=black	guifg=#ff5d28	gui=none	ctermfg=202
hi hl_func_name_stl	guibg=black guifg=#85b0df	gui=none	ctermfg=184
hi hl_buf_name_stl	guibg=black guifg=#cdd129	gui=none	ctermfg=184
hi hl_buf_name_stl	guibg=black	guifg=white	gui=none	ctermfg=202
hi hl_buf_name_stl	guibg=black	guifg=#ff5d28	gui=none	ctermfg=202
