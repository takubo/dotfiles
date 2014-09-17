"takubo

if has('win32') || has('win64')
  "set rtp+=$HOME/.vim
  set rtp+=C:\cygwin\home\rbusers\dotfiles\.vim
  set rtp+=C:\cygwin\home\rbusers\dotfiles\.vim\after
endif

if has('win32') || has('win64') " || has('win32unix')
  let $PATH.=';C:\cygwin\bin'
  "set sh=D:\takubo\bin\zckw\ckw
  "set sh=D:\takubo\bin\zckw\ckw -e\ C:\cygwin\bin\zsh
  "set sh=C:\cygwin\cygwin.bat
  set sh=C:\cygwin\bin\zsh
  let $PATH.=':/cygdrive/c/cygwin/bin'
  "set shcf=-c
  set shcf=-c\	
  "set shellquote=\"
  "set shellxquote=\"\ 
  set shellxquote=\"
  set ssl
endif

if !isdirectory($HOME . "/vim_buckup")
  call mkdir($HOME . "/vim_buckup")
endif

set autochdir
set autoindent
" バックスペースでインデントや改行を削除できるようにする
set backspace=2
set backupdir=$HOME/vim_buckup
set clipboard=unnamed
" コマンドラインの高さ (Windows用gvim使用時はgvimrcを編集すること)
set cmdheight=2
set nocompatible
set cursorline
set encoding=utf-8
" テキスト挿入中の自動折り返しを日本語に対応させる
set formatoptions+=mM
set gp=grep\ -n
set guicursor=n-v-c:block-Cursor/lCursor,ve:ver35-Cursor,o:hor50-Cursor,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor,a:blinkon0
set hidden
set hlsearch
set history=10000
" 検索時に大文字小文字を無視 (noignorecase:無視しない)
set ignorecase
set incsearch
set mps+=<:>
set nowrapscan
set number
" 常にステータス行を表示
set laststatus=2
set list
"trail:末尾のスペース, eol:改行, extends:, precedes:, nbsp:
set listchars=tab:>_,trail:$ | ",eol:,extends:,precedes:,nbsp:
set omnifunc=syntaxcomplete#Cmplete
" タイトルを表示
set title
set shiftwidth=4
" コマンドをステータス行に表示
set showcmd
" 括弧入力時に対応する括弧を表示 (noshowmatch:表示しない)
set showmatch
" 大文字小文字の両方が含まれている場合は大文字小文字を区別
set smartcase
" オンのとき、ウィンドウを横分割すると新しいウィンドウはカレントウィンドウの下に開かれる。
"set splitbelow
" オンのとき、ウィンドウを縦分割すると新しいウィンドウはカレントウィンドウの右に開かれる。
set splitright
"set statusline=%m%r%h%w\ %F%=[Type=%Y]\ %{&ff}\ [L:%l,\ C:%v]\ [Line:%L\ :\ %p%%]\ 
"set statusline=\ %F%m%=%r%h%w%y:%{&ff}\ [%l,%v][%L#%p%%]\ 
"set statusline=%m[%2{winnr()}]%r%h%w\ %F%m%=%y:%{&ff}\ [%l,%v][%L#%p%%]\ 
"set statusline=%m[%2{winnr()}]%r%h%w\ %F%m%=%y:[%{&fenc},%{&ff}]\ [%l,%v]:[%L#%p%%]\ 
"set statusline=%m[%2{winnr()}]%r%h%w\ %F%=%y:[%{&fenc},%{&ff}]\ [%l,%v]:[%L#%p%%]\ 
"set statusline=%m[%2{winnr()}]%r%h%w\ %F%=%y:[%{&fenc},%{&ff}]\ [%4l,%3v]:[%3p%%/%L]\ 
"set statusline=%m[%2{winnr()}]%r%h%w\ %F%=%{&ff},\ %{&fenc},\ %Y\ [%4l,%3v]\ %3p%%\ %L\ 
set statusline=%m[%2{winnr()}]%r%h%w\ %F%=[%{toupper(&ff)},\ %{&fenc},\ %Y]\ [%4l,%3v]\ [%3p%%/%L]\ 
"リロードするときにアンドゥのためにバッファ全体を保存する
set undoreload=-1
"実際に文字がないところにもカーソルを置けるようにする
set virtualedit=block
set wildmenu
" 長い行を折り返して表示 (nowrap:折り返さない)
set wrap
" 検索時にファイルの最後まで行ったら最初に戻る (nowrapscan:戻らない)
set nowrapscan


filetype on

syntax enable


au QuickfixCmdPost make,grep,grepadd,vimgrep copen

" grepする際に'|cw'を付けなくても、Quickfixに結果を表示する
au QuickfixCmdPost vimgrep cw


colorscheme Vitamin
hi CursorLine ctermbg=NONE guibg=NONE


augroup MyVimrc
  au!

  au InsertEnter * set timeoutlen=500
  au InsertLeave * set timeoutlen=15000

  au WinEnter * set cursorline
  au WinLeave * set nocursorline

  au FileType c,cpp,java set mps+==:;
  au FileType c,cpp,java,awk set mps+=?::

  au BufNewFile,BufRead,FileType *.awk so $vim/avd/avd.vim
augroup end


"kwbd.vim : ウィンドウレイアウトを崩さないでバッファを閉じる
" http://nanasi.jp/articles/vim/kwbd_vim.html
com! Kwbd let kwbd_bn= bufnr("%")|enew|exe "bdel ".kwbd_bn|unlet kwbd_bn


let &path .= 'D:\takubo\opt\vim73-kaoriya-win32'

let $PATH = $PATH . 'C:\Oracle\Ora11R2\bin;%SystemRoot%\system32;%SystemRoot%;%SystemRoot%\System32\Wbem;%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\;C:\Program Files\Common Files\Compuware;C:\Program Files\WinMerge;C:\Program Files\Subversion\bin;C:\Program Files\TortoiseSVN\bin;D:\takubo\bin\;C:\Perl\bin'


"??so $vim/awk.vim


"nnoremap <silent> <Esc><Esc> <Esc>:noh<CR>:SearchReset<CR>:SearchBuffersReset<CR>
nnoremap <silent> <Esc><Esc> <Esc>:noh<CR>
nnoremap Y y$
nnoremap <silent> <C-s> :w<cr>

nnoremap <silent> <Space> <C-f>
nnoremap <silent> <S-Space> <C-b>

nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k

"map <C-T> :tag
"noremap H <C-t>
"noremap <silent> L :tag<CR>
noremap H <C-o>
noremap L <C-i>
"補償
nnoremap zh H
nnoremap zl L
"nnoremap zm M


"nnoremap <silent> <C-p> :tabprev<CR>
"nnoremap <silent> <C-n> :tabnext<CR>
"nnoremap <silent> <M-j> :tabprev<CR>
"nnoremap <silent> <M-k> :tabnext<CR>
nnoremap <silent> <C-k> :tabprev<CR>
nnoremap <silent> <C-o> :tabnext<CR>
"nnoremap <silent> <C-t> :tabnew  | "%<CR>
nnoremap <C-t> :tabnew 
"nnoremap <C-t> :tabnew %<CR> :e 


noremap <C-Tab> gt
noremap <C-S-Tab> gT
"nnoremap <silent> <C-p> :bprev<CR>
"nnoremap <silent> <C-n> :bnext<CR>

"nnoremap <silent> <C-o> :bnext<CR>
"nnoremap <silent> <C-w> :bprev<CR>

nnoremap <silent> <C-n> :bnext<CR>
nnoremap <silent> <C-p> :bprev<CR>
function! BuffScroll()
  while 1
    let c = nr2char(getchar())
    if c == 'j'
      bnext
      redraw
    elseif c == 'k'
      bprev
      redraw
    else
      return
    endif
  endwhile
endfunction
"nnoremap <silent> <C-j> :call BuffScroll()<CR>
"nnoremap <silent> <C-k> :bprev<CR>
"nnoremap <silent> <C-j> <C-w>


noremap <Tab> <C-w>w
noremap <S-Tab> <C-w>W

""""nnoremap + <C-w>+
""""nnoremap - <C-w>-
""""nnoremap ) <C-w>>
""""nnoremap ( <C-w><

nnoremap <silent> + <esc>10<c-w>+
nnoremap <silent> - <esc>10<c-w>-
nnoremap <silent> ) <esc>10<c-w>>
nnoremap <silent> ( <esc>10<c-w><

nnoremap <up> <esc>10<C-w>+
nnoremap <down> <esc>10<C-w>-
nnoremap <left> <esc>10<C-w><
nnoremap <right> <esc>10<C-w>>

nnoremap <s-up> <esc><C-w>+
nnoremap <s-down> <esc><C-w>-
nnoremap <s-left> <esc><C-w><
nnoremap <s-right> <esc><C-w>>

"nnoremap <BS> <C-w>v
nnoremap <BS><BS> <C-w>v
nnoremap <s-BS> :vnew<cr>
nnoremap <c-BS> <C-w>s
nnoremap <s-c-BS> <esc>:new<cr>
nnoremap <F5> <C-w>s
nnoremap <s-F5> :new<cr>
nnoremap <F6> <C-w>v
nnoremap <s-F6> <esc>:vnew<cr>

nnoremap <silent> <F5>   <esc>:sp<cr>
nnoremap <silent> <s-F5> <esc>:new<cr>
nnoremap <silent> <F6>   <esc>:vs<cr>
nnoremap <silent> <s-F6> <esc>:vnew<cr>

" nnoremap <silent> + <esc><c-w>+
" nnoremap <silent> - <esc><c-w>-
" nnoremap <silent> ) <esc><c-w>>
" nnoremap <silent> ( <esc><c-w><
" 
" nnoremap <s-up> 20<C-w>+
" nnoremap <s-down> 20<C-w>-
" nnoremap <s-left> 20<C-w><
" nnoremap <s-right> 20<C-w>>

"nnoremap <c-up> <C-w>K
"nnoremap <c-down> <C-w>J
"nnoremap <c-left> <C-w>H
"nnoremap <c-right> <C-w>L

"nnoremap <up> <C-w>s
"nnoremap <down> :new<cr>
"nnoremap <left> <C-w>v
"nnoremap <right> <esc>:vnew<cr>

""" M noremap <Tab> <C-w>w
""" M noremap <S-Tab> <C-w>W
""" M 
""" M nnoremap + <C-w>+
""" M nnoremap - <C-w>-
""" M nnoremap ) <C-w>>
""" M nnoremap ( <C-w><
""" M nnoremap <up> <C-w>+
""" M nnoremap <down> <C-w>-
""" M nnoremap <left> <C-w><
""" M nnoremap <right> <C-w>>
""" M 
""" M "nnoremap <BS> <C-w>v
""" M nnoremap <M-v> <C-w>v
""" M nnoremap <s-BS> :vnew<cr>
""" M nnoremap <M-s> <C-w>s
""" M nnoremap <s-F5> :new<cr>


nnoremap <silent> <Leader>m :marks<CR>
nnoremap <silent> <Leader>d :disp<CR>
nnoremap <silent> <Leader>k :make<CR>
nnoremap <silent> <leader>t :ToggleWord<CR>


function! SetNumber()
  if &number
    set relativenumber
    return
  endif
  if &relativenumber
    set number
    return
  endif
  set number
endfunction
nnoremap <silent><expr> <leader>n SetNumber()


function! CountFunctionLines()
  normal! H
  let top = line('.')
  normal! <C-o>
  normal! [[
  let s = line('.')
  normal! <C-o>
  normal! ][
  let e = line('.')
  normal! <C-o>
  execute 'normal ' . top . 'G'
  normal! z<CR>
  normal! <C-o>
  echo e - s + 2
endfunction
command! FuncLines <silent> call CountFunctionLines()
"nnoremap <silent> <leader>l :FuncLines<CR>


nnoremap <C-j><C-a> :cscope add cscope.out<CR>
nnoremap <C-j><C-j> :cscope find 
nnoremap <C-j>c     :cscope find c 
nnoremap <C-j>d     :cscope find d 
nnoremap <C-j>e     :cscope find e 
nnoremap <C-j>f     :cscope find f 
nnoremap <C-j>g     :cscope find g 
nnoremap <C-j>i     :cscope find i 
nnoremap <C-j>s     :cscope find s 
nnoremap <C-j>t     :cscope find t 
nnoremap <C-j>C     :cscope find c <C-r><C-w><CR>
nnoremap <C-j>D     :cscope find d <C-r><C-w><CR>
nnoremap <C-j>E     :cscope find e <C-r><C-w><CR>
nnoremap <C-j>F     :cscope find f <C-r><C-w><CR>
nnoremap <C-j>G     :cscope find g <C-r><C-w><CR>
nnoremap <C-j>I     :cscope find i <C-r><C-w><CR>
nnoremap <C-j>S     :cscope find s <C-r><C-w><CR>
nnoremap <C-j>T     :cscope find t <C-r><C-w><CR>


vnoremap af ][<ESC>V[[


" 検索時に/, ?を楽に入力する
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'


inoremap <silent> jj <Esc>:w <cr>
inoremap <silent> ff <Esc>:w <cr>

function! s:Tab()
    if pumvisible()
	call feedkeys("\<C-n>")
	return ''
    else
	let ret = TriggerSnippet()
	if ret == "\t" && search('\W\I\i*\%#', 'bcn')
	    "call feedkeys("\<C-n>\<C-n>", 'n')
	    "call feedkeys("\<S-Tab>", 'm')
	    return "\<C-n>"
	endif
	return ret
    endif
endfunction
inoremap <silent> <Tab>   <C-R>=<SID>Tab()<CR>
inoremap <expr>   <S-Tab> pumvisible() ? '<C-p>' : '<Tab>'
"inoremap <expr>   <S-Tab> pumvisible() ? '<C-p>' : '<C-p><C-n>'

inoremap <expr> <CR>  pumvisible() ? '<C-y>' : '<CR>'
inoremap <expr> <Esc> pumvisible() ? '<C-e>' : '<Esc>'

"TODO 行末
inoremap <expr> , smartchr#one_of(', ', ',')

" 演算子の間に空白を入れる
inoremap <expr> + smartchr#one_of(' = ', '==', '=')
inoremap <expr> + smartchr#one_of(' + ', '++', '+')
inoremap <expr> - smartchr#one_of(' - ', '--', '-')
inoremap <expr> * smartchr#one_of(' * ', '*')
inoremap <expr> / smartchr#one_of(' / ', '/')
inoremap <expr> % smartchr#one_of(' % ', '%')
inoremap <expr> & smartchr#one_of(' & ', ' && ', '&')
inoremap <expr> <Bar> smartchr#one_of(' <Bar> ', ' <Bar><Bar> ', '<Bar>')
"inoremap <expr> < smartchr#one_of(' < ', '<')
"inoremap <expr> > smartchr#one_of(' > ', '>')

"inoremap <expr> < search('^#include\%#', 'bcn') ? ' <' : smartchr#one_of(' < ', ' << ', '<')
"inoremap <expr> > search('^#include <.*\%#', 'bcn') ? '>' : smartchr#one_of(' > ', ' >> ', '>')
"
"function! Imap_eq()
"  if     search('\(&\||\|+\|-\|\*\|/\|%\|\^\|>\|<\|\.\|!\|=\) \%#', 'bcn')
"    let ret = "\<bs>="
"  elseif search('\(&\||\|+\|-\|\*\|/\|%\|\^\|>\|<\|\.\|!\|=\| \)\%#', 'bcn')
"    let ret = '='
"  else
"    "let ret = smartchr#one_of(' =', ' ==', '=')
"    let ret = smartchr#loop(' =', ' ==', '=')
"    if ret == '='
"      return ret
"    endif
"  endif
"  if !search('\%# ', 'cn')
"    let ret .= ' '
"  endif
"  return ret
"endfunction
"inoremap <expr> = Imap_eq()





"inoremap <buffer><expr> = search('\(&\||\|+\|-\|/\|>\|<\) \%#', 'bcn')? '<bs>= '
"				\ : search('\(*\|!\)\%#', 'bcn') ? '= '
"				\ : smartchr#one_of(' = ', ' == ', '=')


"inoremap <expr> = search('\(\(\k\<bar>)\<bar>\]\)\s*\<bar>= \)\%#', 'bcn') ?
      \ smartchr#loop(' = ', ' == ', '=') : search(' \%#', 'bcn') ? '<bs>= ' : '= '
"inoremap <expr> = search('\(\k\<bar>)\<bar>\]\<bar>=\)\%#', 'bcn') ?
"      \ smartchr#loop(' = ', ' == ', '=') : search(' \%#', 'bcn') ? '<bs><bs>= ' : '= '
"inoremap <expr> = search(
"      \ '\(+\<bar>-\<bar>*\<bar>/\<bar>%\<bar>&\<bar><bar>\<bar><\<bar>>\<bar>=\<bar>)\<bar>=\)\%#',
"      \ 'bcn') ? '= ' : smartchr#loop(' = ', ' == ', '=')
"inoremap <expr> = smartchr#loop(' = ', ' == ', '=')


"      \ '\(+\<bar>-\<bar>*\<bar>/\<bar>%\<bar>&\<bar><bar>\<bar><\<bar>>\<bar>=\<bar>^\<bar>~\<bar>.\<bar>:\<bar>!\<bar>=\)\%#',
"inoremap <expr> + smartchr#loop(' + ', '++', '+')
"inoremap <expr> ! smartchr#one_of('!', ' != ', '!!')
"inoremap <expr> & smartchr#loop(' & ', ' && ', '&')
"inoremap <expr> <bar> smartchr#loop(' <bar> ', ' <bar><bar> ', '<bar>')


"inoremap <expr> < search('^#include\%#', 'bcn') ?  ' <' : smartchr#loop(' < ', ' << ', '<')
"inoremap <expr> >  search('^#include <.*\%#', 'bcn') ? '>' :
"      \ search('< \%#', 'bcn') ? '<bs>> ' : smartchr#loop(' > ', ' >> ', '>')
"inoremap <expr> , smartchr#one_of(', ', ',')
"inoremap <expr> <cr> search(' \%#', 'bcn') ? '<bs><cr>' : '<cr>'
"inoremap <expr> . smartchr#one_of('.', '->',  '..')

"inoremap <expr> , smartchr#one_of(', ', ',')
"inoremap <expr> . smartchr#one_of('.', '->', '..')
""inoremap <expr> & smartchr#loop('&', ' && ')
""inoremap <expr> <bar> smartchr#loop('<bar>', ' <bar><bar> ')
"inoremap <buffer><expr> + smartchr#one_of(' + ', '++', '+')
"inoremap <buffer><expr> - smartchr#one_of(' - ', '--', '-')
"inoremap <buffer><expr> = search('\(&\<bar><bar>\<bar>+\<bar>-\<bar>/\<bar>>\<bar><\) \%#', 'bcn')? '<bs>= '
"				\ : search('\(*\<bar>!\)\%#', 'bcn') ? '= '
"				\ : smartchr#one_of(' = ', ' == ', '=')

"if &filetype == "c"
"  " 「->」は入力しづらいので、..で置換え
"  inoremap <buffer><expr> . smartchr#one_of('.', '->', '..')
"
"  " 行先頭での#入力で、プリプロセス命令文を入力
"  inoremap <buffer><expr> # search('^\(#.*\)\?\%#','bcn')? smartchr#loop('#define ', '#include', '#ifdef ', '#elif', '#endif', '#'): '#'
"  inoremap <buffer><expr> " search('^#include\%#', 'bcn')? ' "': '"'
"
"  " *はポインタで使う
"  "inoremap <buffer><expr> * search('^/\?\%#','bcn') ? smartchr#one_of(' * ', '*')
"  "inoremap <buffer><expr> * search('^/\?\%#','bcn') ? smartchr#one_of(' *', '*')
"  inoremap <buffer><expr> *
"	\ ( search('\(&\<bar><bar>\<bar>+\<bar>-\<bar>\*\<bar>/\<bar>>%<bar>>\<bar><\<bar>=\<bar>?\<bar>:\<bar>,\) \?\%#', 'bcn')
"	\ <bar><bar> search('\(^\<bar>{\)\s*\%#', 'bcn') ) ? '*' : search('\(^\<bar>,\<bar>(\<bar>{\)\s*\k\+\s\?\%#', 'bcn') ? ' *' : smartchr#one_of(' * ', '*', '* ')
"  " //コメントを楽に入れる
"  inoremap <buffer><expr> / search('^\s*/\?/\?\s\?\%#','bcn') ? smartchr#one_of('// ', '//', '\<bs>/') : smartchr#one_of(' / ', '/')
"
"  " 3項演算子
"  inoremap <buffer><expr> ? smartchr#one_of(' ? ', '?')
"  inoremap <buffer><expr> : smartchr#one_of(' : ', ':')
"endif

" 下記の文字は連続して現れることがまれなので、二回続けて入力したら改行する
"?inoremap <buffer><expr> } smartchr#one_of('}', '}<cr>')
"?inoremap <buffer><expr> ; smartchr#one_of(';', ';<cr>')

" if文直後の(は自動で間に空白を入れる
"?inoremap <buffer><expr> ( search('\<\if\%#', 'bcn')? ' (': '('


" =の場合、単純な代入や比較演算子として入力する場合は前後にスペースをいれる。
" 複合演算代入としての入力の場合は、直前のスペースを削除して=を入力
"inoremap <buffer><expr> = search('\(&\<bar><bar>\<bar>+\<bar>-\<bar>/\<bar>>%<bar>>\<bar><\) \%#', 'bcn')? '<bs>= '
"				\ : search('\(*\<bar>!\)\%#', 'bcn') ? '= '
"				\ : smartchr#one_of(' = ', ' == ', '=')











"so $VIM\plugins\*.vim

"so $VIM/plugins/toggle_words.vim
"
"so $VIM/plugins/smartchr.vim
"so $VIM/plugins/font.vim


"so $VIM/plugins/smooth_scroll.vim
"so $VIM/plugins/quickrun.vim

"so $vim/plugins/font.vim

"so $HOME/asvimrc










"??? func! Eatchar(pat)
"???     let c = nr2char(getchar(0))
"???     return (c =~ a:pat) ? '' : c
"??? endfunc
"??? "iabbr <silent> if if () {<Left><Left><Left><C-R>=Eatchar('\s')<CR>
"??? "iabbr <silent> switch switch () {<Left><Left><Left><C-R>=Eatchar('\s')<CR>
"??? "iabbr <silent> while while () {<Left><Left><Left><C-R>=Eatchar('\s')<CR>
"??? "iabbr <silent> for for () {<Left><Left><Left><C-R>=Eatchar('\s')<CR>
"??? "iabbr <silent> do do {<Left><Left><Left><C-R>=Eatchar('\s')<CR>




"function! AwkBegin()
"  setlocal ft=awk
"  call setline(1, 'BEGIN {')
"  call setline(2, '}')
"  call setline(3, '')
"  call setline(4, 'END {')
"  call setline(5, '}')
"  return
"endfunc


"TODO
"バッファ切り替えイベントでも、かーそーラインをセットする。
