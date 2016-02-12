scriptencoding utf-8
" vim:set ts=8 sts=2 sw=2 tw=0: (この行に関しては:help modelineを参照)

"takubo

if has('win32') || has('win64') " || has('win32unix')
  let home = 'C:\cygwin\home\' . $USERNAME
  if isdirectory(home)
    let $HOME=home
  endif
  let $PATH.=';C:\cygwin\bin'
  let $PATH.=':/cygdrive/c/cygwin/bin'
  "set sh=D:\takubo\bin\zckw\ckw
  "set sh=D:\takubo\bin\zckw\ckw -e\ C:\cygwin\bin\zsh
  "set sh=C:\cygwin\cygwin.bat
  set sh=C:\cygwin\bin\zsh
  "? set sh=C:\cygwin\bin\mintty
  "set shcf=-c
  set shcf=-c\	
  "set shellquote=\"
  "set shellxquote=\"\ 
  set shellxquote=\"
  set ssl
endif

if has('win32') || has('win64')
  "set rtp+=$HOME/.vim
  set rtp+=C:\cygwin\home\rbusers\dotfiles\.vim
  set rtp+=C:\cygwin\home\rbusers\dotfiles\.vim\after
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
set cursorcolumn
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
" 大文字小文字の両方が含まれている場合は大文字小文字を区別
set smartcase
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
set shiftwidth=8
" コマンドをステータス行に表示
set showcmd
" 括弧入力時に対応する括弧を表示 (noshowmatch:表示しない)
set showmatch
" オンのとき、ウィンドウを横分割すると新しいウィンドウはカレントウィンドウの下に開かれる。
set splitbelow
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

set tags+=tags;

au QuickfixCmdPost make,grep,grepadd,vimgrep botright copen

" grepする際に'|cw'を付けなくても、Quickfixに結果を表示する
au QuickfixCmdPost vimgrep botright cwindow

colorscheme Vitamin
" TODO hi CursorLine ctermbg=NONE guibg=NONE


augroup MyVimrc
  au!

  au InsertEnter * set timeoutlen=200
  au InsertLeave * set timeoutlen=15000

  au WinEnter * set cursorline
  au WinEnter * set cursorcolumn
  au WinLeave * set nocursorline
  au WinLeave * set nocursorcolumn

  au FileType c,cpp,java set mps+==:;
  au FileType c,cpp,java,awk set mps+=?::

  au BufNewFile,BufRead,FileType *.awk so $vim/avd/avd.vim

  au BufNewFile,BufRead * call <SID>best_scrolloff()
  au WinEnter   * call <SID>best_scrolloff()
  au VimResized * call <SID>best_scrolloff()
augroup end

function! s:best_scrolloff()
  exe "setlocal  scrolloff=" . (winheight(0) < 10 ? 0 : winheight(0) < 20 ? 2 : 5)
endfunction

"kwbd.vim : ウィンドウレイアウトを崩さないでバッファを閉じる
" http://nanasi.jp/articles/vim/kwbd_vim.html
com! Kwbd let kwbd_bn= bufnr("%")|enew|exe "bdel ".kwbd_bn|unlet kwbd_bn


let &path .= 'D:\takubo\opt\vim73-kaoriya-win32'

let $PATH = $PATH . 'C:\Oracle\Ora11R2\bin;%SystemRoot%\system32;%SystemRoot%;%SystemRoot%\System32\Wbem;%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\;C:\Program Files\Common Files\Compuware;C:\Program Files\WinMerge;C:\Program Files\Subversion\bin;C:\Program Files\TortoiseSVN\bin;D:\takubo\bin\;C:\Perl\bin'


"??so $vim/awk.vim


nnoremap Y y$
nnoremap <silent> <C-s> :w<cr>

"nnoremap <silent> <Esc><Esc> <Esc>:noh<CR>:SearchReset<CR>:SearchBuffersReset<CR>
nnoremap <silent> <Esc><Esc> <Esc>:noh<CR>

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


noremap <Tab> <C-w>w
noremap <S-Tab> <C-w>W

"nnoremap <silent> + <esc>10<c-w>+
"nnoremap <silent> - <esc>10<c-w>-
"nnoremap <silent> ) <esc>10<c-w>>
"nnoremap <silent> ( <esc>10<c-w><

nnoremap <up>    <esc>5<C-w>+
nnoremap <down>  <esc>5<C-w>-
nnoremap <left>  <esc>5<C-w><
nnoremap <right> <esc>5<C-w>>

vnoremap <up>    5<C-w>+
vnoremap <down>  5<C-w>-
vnoremap <left>  5<C-w><
vnoremap <right> 5<C-w>>

nnoremap <s-up>    <C-w>+
nnoremap <s-down>  <C-w>-
nnoremap <s-left>  <C-w><
nnoremap <s-right> <C-w>>

vnoremap <s-up>    <C-w>+
vnoremap <s-down>  <C-w>-
vnoremap <s-left>  <C-w><
vnoremap <s-right> <C-w>>


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

"nnoremap <c-up> <C-w>K
"nnoremap <c-down> <C-w>J
"nnoremap <c-left> <C-w>H
"nnoremap <c-right> <C-w>L

""" M nnoremap <M-v> <C-w>v
""" M nnoremap <M-s> <C-w>s
""" M nnoremap <s-F5> :new<cr>


nnoremap <silent> <Leader>m :marks<CR>
nnoremap <silent> <Leader>" :disp<CR>
nnoremap <silent> <Leader>k :make<CR>
nnoremap <silent> <leader>t :ToggleWord<CR>


function! CountFunctionLines()
  " 現在位置を保存
  let cur = line('.')
  normal! H
  let cur_top = line('.')
  execute 'normal ' . cur . 'G'
  " 関数先頭へ移動
  normal! [[
  let s = line('.')
  " 関数末尾へ移動
  normal! ][
  let e = line('.')
  " 結果表示
  echo e - s + 1
  " 保存していた位置に戻る
  execute 'normal ' . cur_top . 'G'
  normal! z<CR>
  execute 'normal ' . cur . 'G'
endfunction
command! FuncLines call CountFunctionLines()
nnoremap <silent> <leader>l :FuncLines<CR>


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
vnoremap if ][k<ESC>V[[j


cnoremap <C-a> <Home>


" 検索時に/, ?を楽に入力する
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'


"inoremap <silent> jj <Esc>:w <cr>
"inoremap <silent> ff <Esc>:w <cr>

inoremap <expr> <CR>  pumvisible() ? '<C-y>' : '<C-]><C-G>u<CR>'
inoremap <expr> <Esc> pumvisible() ? '<C-e>' : '<Esc>'

" function! s:Tab()
"   if pumvisible()
"     call feedkeys("\<C-n>")
"     return ''
"   else
"     let ret = TriggerSnippet()
"     if ret == "\t" && search('\W\I\i*\%#', 'bcn')
"       "call feedkeys("\<C-n>\<C-n>", 'n')
"       "call feedkeys("\<S-Tab>", 'm')
"       return "\<C-n>"
"     endif
"     return ret
"   endif
" endfunction
function! s:Tab()
  if pumvisible()
    call feedkeys("\<C-n>")
    return ''
  else
    let ret = TriggerSnippet()
    "if ret == "\t" && search('\W\I\i*\%#', 'bcn')
    "  "call feedkeys("\<C-n>\<C-n>", 'n')
    "  "call feedkeys("\<S-Tab>", 'm')
    "  return "\<C-n>"
    "endif
    return ret
  endif
endfunction
if exists('*TriggerSnippet')
  inoremap <silent> <Tab>   <C-R>=<SID>Tab()<CR>
else
  "coml inoremap <expr> <Tab> pumvisible() ? '<C-n>' : '<C-]><Tab>'
endif
"compl inoremap <expr>   <S-Tab> pumvisible() ? '<C-p>' : '<C-n>'
"inoremap <expr>   <S-Tab> pumvisible() ? '<C-p>' : '<C-p><C-n>'
"inoremap <expr>   <S-Tab> pumvisible() ? '<C-p>' : '<Tab>'


if exists('*smartchr#one_of')

  "TODO 行末
  inoremap <expr> , smartchr#one_of(', ', ',')

  " 演算子の間に空白を入れる
  inoremap <expr> + smartchr#one_of(' = ', ' == ', '=')
  inoremap <expr> + smartchr#one_of(' + ', '++', '+')
  inoremap <expr> - smartchr#one_of(' - ', '--', '-')
  inoremap <expr> * smartchr#one_of(' * ', '*')
  inoremap <expr> / smartchr#one_of(' / ', '/')
  inoremap <expr> % smartchr#one_of(' % ', '%')
  inoremap <expr> & smartchr#one_of(' & ', ' && ', '&')
  inoremap <expr> <Bar> smartchr#one_of(' <Bar> ', ' <Bar><Bar> ', '<Bar>')
endif



"if &filetype == "c"
" 下記の文字は連続して現れることがまれなので、二回続けて入力したら改行する
"?inoremap <buffer><expr> } smartchr#one_of('}', '}<cr>')
"?inoremap <buffer><expr> ; smartchr#one_of(';', ';<cr>')
"endif



"TODO
"バッファ切り替えイベントでも、カーソルラインをセットする。
"ftpluginのCとAWKを統合する。


nnoremap ]] ]]zt
nnoremap [[ [[zt
nnoremap ][ ][zb
nnoremap [] []zb


" CUSTOMER

set tag+=;

"nnoremap <C-s> :%s/
"vnoremap <C-s> :s/
nnoremap <C-s>   :g#.#s    /
nnoremap <leader><C-s>   :g#.#s    /<C-R>//<C-R><C-W>/
nnoremap <A-s> :g#.#s    /<C-R>//
vnoremap <C-s> :s    /
"vnoremap <C-S-s> :s    /<C-R>/

au GUIEnter * simalt ~x
"au GUIEnter * set transparency=238
"let tppp = 220
let tppp = 229
exe 'au GUIEnter * set transparency=' . tppp

set noundofile

"nnoremap n nzz
"nnoremap N Nzz
"" nnoremap * *zz
"" nnoremap # #zz
"" nnoremap g* g*zz
"" nnoremap g# g#zz
nnoremap * *
nnoremap # #
nnoremap g* g*
nnoremap g# g#

"inoremap <expr> + smartchr#one_of(' = ', ' == ', '=')

"" " diff
nnoremap <expr> <leader>d &diff ? ':diffoff<CR>' : ':diffthis<CR>'
"" " diffup (diffthisを実行)
nnoremap <expr> <leader>D &diff ? ':diffupdate<CR>' : ':diffthis<CR>'

" diff
"nnoremap <silent><expr> <leader>d &diff ? ':diffupdate<CR>' : ':diffthis<CR>'
" diffup (diffthisを実行)
"nnoremap <silent><expr> <leader>D &diff ? ':diffoff<CR>' : ':diffthis<CR>'



" コマンドラインでのキーバインドを Emacs スタイルにします >
" 行頭へ移動
cnoremap <C-A>		<Home>
" 一文字戻る
cnoremap <C-B>		<Left>
" カーソルの下の文字を削除
cnoremap <C-D>		<Del>
" 行末へ移動
cnoremap <C-E>		<End>
" 一文字進む
cnoremap <C-F>		<Right>
" コマンドライン履歴を一つ進む
cnoremap <C-N>		<Down>
" コマンドライン履歴を一つ戻る
cnoremap <C-P>		<Up>
" 前の単語へ移動
"cnoremap <Esc><C-B>	<S-Left>
" 次の単語へ移動
"cnoremap <Esc><C-F>	<S-Right>



" 上でも修正
set splitbelow
nnoremap <silent> <leader>" :disp<CR>
nnoremap <silent> <leader>p :disp<CR>
nnoremap <silent> <leader>P :disp<CR>



nnoremap <silent><expr> <leader>. stridx(&isk, '.') < 0 ? ':setl isk+=.<CR>' : ':set isk-=.<CR>'


" hi SLWinNr guifg=#000000 guibg=#e6e3c8 gui=bold cterm=bold ctermfg=yellow cterm=underline
" hi SLWinNr guibg=#ffffff guifg=#a63318 gui=bold
" hi SLFileName guifg=#ede39e guibg=#000000

"set statusline=%m[%2{winnr()}]%r%h%w\ %F%m\ \ \ \ %=%{winnr()}:\ [%{(&ff)},\ %{&fenc},\ %Y,\ %1{stridx(&isk,'.')<0?'-':'.'}]\ [%4l,%3v]\ [%3p%%:%L]
"set statusline=%m[%2{winnr()}]%r%h%w\ %<%F%m\ \ \ \ %=%{(&ff)},\ %{&fenc},\ %Y,\ %1{stridx(&isk,'.')<0?'-':'.'}\ [%4l\ %3v]\ %3p%%\ %L
"set statusline=%#SLWinNr#\ %{winnr()}\ %##%r%h%w\ %<%F%m\ \ \ %=%#Macro#\ %{(&ff)},\ %{&fenc},\ %Y,\ %1{stridx(&isk,'.')<0?'-':'.'}\ %##[%4l\ %3v]%#Macro#%3p%%\ %L\ %##\ %{repeat('\ ',winwidth(0)-120)}
"set statusline=%#SLWinNr#\ %{winnr()}\ %##%r%h%w\ %<%F%m\ \ \ %=%#Macro#\ %{(&ff)},\ %{&fenc},\ %Y,\ %1{stridx(&isk,'.')<0?'-':'.'}\ %##[%4l\ %3v]%#Macro#%3p%%\ %L\ %##\ %{repeat('\ ',winwidth(0)-140)}
"set statusline=%#SLWinNr#\ %{winnr()}\ %##%r%h%w\ %<%F%m\ \ \ %=%#Macro#\ %{(&ff)},\ %{&fenc},\ %Y,\ %1{stridx(&isk,'.')<0?'-':'.'}\ %##[%4l\ %3v]%#Macro#%3p%%\ %L\ %##\ %{repeat('\ ',winwidth(0)-max([len(fnamemodify('.',':p').bufname('.'))+50,120]))}
set statusline=%#SLWinNr#\ %{winnr()}\ %##%r%h%w\ %<%F%m\ \ \ %=%#Macro#\ %{(&ff)},\ %{&fenc},\ %Y,\ %1{stridx(&isk,'.')<0?'-':'.'}\ %##\ [%4l\ %3v]\ %#Macro#%3p%%\ %L\ %##\ %{repeat('\ ',winwidth(0)-b:buf_name_len)}
set statusline=\ %{winnr()}%m\ %##%r%h%w\ %<%#SLFileName#\ %F\ %##%m\ \ \ %=%#SLFileName#\ %{(&ff)},\ %{&fenc},\ %Y,\ %1{stridx(&isk,'.')<0?'-':'.'}\ %##\ [%4l\ %3v]\ %#SLFileName#%3p%%\ %L\ %##\ %{repeat('\ ',winwidth(0)-b:buf_name_len)}
augroup MyVimrcStatusline
  au!
  "au BufNewFile,BufRead,BufFilePost,BufEnter,BufWinEnter,BufNew,FilterReadPost,FileReadPost * let b:buf_name_len = max([len(fnamemodify(bufname('.'),':p'))+60, 120])
  " M$ Windowsの不具合対策 他のドライブのファイルを読み込んだときにバグがある?
  au BufNewFile,BufRead,BufFilePost,BufWinEnter,BufNew,FilterReadPost,FileReadPost * let b:buf_name_len = max([len(fnamemodify(bufname('.'),':p'))+60, 120])
augroup end
"function! Buf_name_len_set()
"  try
"    return max([len(fnamemodify(bufname('.'),':p'))+60, 120])
"  endtry
"endfunction
"au BufNewFile,BufRead * let b:buf_name_len = max([len(fnamemodify('.',':p') . bufname('.'))+30, 120])
"echo max([len(fnamemodify(".", ":p") . bufname(".")) + 40, 120]


nnoremap # g*
nnoremap g* #


nnoremap q <c-v>


nnoremap <silent><expr> <leader>n &relativenumber ?  ':set number norelativenumber<CR>' : ':set relativenumber<CR>'
"inoremap <silent> jj <Esc>
inoremap <silent> <C-j> <Esc>
nnoremap <C-w><C-w> <C-w>p
nnoremap <silent><C-q> :q<CR>


nnoremap <C-f> gt
nnoremap <C-b> gT


nnoremap <C-k> H
nnoremap <C-j> L


nnoremap K :<C-u>ls!<CR>:b 

nnoremap <silent> <up> <esc>3<C-w>+:call <SID>best_scrolloff()<CR>
nnoremap <silent> <down> <esc>3<C-w>-:call <SID>best_scrolloff()<CR>
nnoremap <silent> <left> <esc>5<C-w><:call <SID>best_scrolloff()<CR>
nnoremap <silent> <right> <esc>5<C-w>>:call <SID>best_scrolloff()<CR>
nnoremap <silent> <s-up> <esc><C-w>+:call <SID>best_scrolloff()<CR>
nnoremap <silent> <s-down> <esc><C-w>-:call <SID>best_scrolloff()<CR>
nnoremap <silent> <s-left> <esc><C-w><:call <SID>best_scrolloff()<CR>
nnoremap <silent> <s-right> <esc><C-w>>:call <SID>best_scrolloff()<CR>
nnoremap <silent> <c-up> <C-w>_:call <SID>best_scrolloff()<CR>
nnoremap <silent> <c-down> 1<C-w>_:call <SID>best_scrolloff()<CR>
nnoremap <silent> <c-left> 1<C-w><bar>:call <SID>best_scrolloff()<CR>
nnoremap <silent> <c-right> <C-w><bar>:call <SID>best_scrolloff()<CR>
nnoremap <silent> <a-up> <C-w>K:call <SID>best_scrolloff()<CR>
nnoremap <silent> <a-down> <C-w>J:call <SID>best_scrolloff()<CR>
nnoremap <silent> <a-left> <C-w>H:call <SID>best_scrolloff()<CR>
nnoremap <silent> <a-right> <C-w>L:call <SID>best_scrolloff()<CR>


"nnoremap <C-Tab> <C-w>p

" CUSTOMER CUSTOMER
com! C1 :vs C:\Users\PK65278\Desktop\work\9A305_IDC0055
com! E1SMC :vs C:\Users\PK65278\Desktop\work\E1最終ソース\E1_UTF8

"nnoremap p ]p
"nnoremap P [p

nnoremap <C-o> O<Esc>
nnoremap <A-o> o<Esc>

au BufNewFile,BufRead *.xms setf xms

" CUSTOMER Style C only
nnoremap ]] ]]kf(bzt
nnoremap ]] :call <SID>cfunc()<CR>zt
nnoremap [[ [[kf(bzt

function! s:cfunc()
  let fline = line('.')
  normal! ]]kf(b
  if fline == line('.')
    normal! j]]kf(b
  end
endfunc

set isfname-=:

" CUSTOMER end



" TODO
"ウィンドウサイズが変わるごとに、set scrolloff=5 を変更
"無名バッファで、カレントディレクトリを設定できるようにする。
" diffのカラーリングを見やすくする

" vimrc
" gvimrc
" vitamin
" syntax xms
" syntax C
" syntax vim


nnoremap <silent>       <s-pageup> :exe 'se transparency=' . (&transparency + 1)<CR>
nnoremap <silent><expr> <s-pagedown> (&transparency > 1) ? (":exe 'se transparency=' . (&transparency - 1)<CR>") : ("")

nnoremap <silent><expr> <pageup>   ':se transparency=' . min([&transparency + 3, 255]) . '<CR>'
nnoremap <silent><expr> <pagedown> ':se transparency=' . max([&transparency - 3,   1]) . '<CR>'

nnoremap <silent>       <c-pageup>   :exe 'se transparency=' . (&transparency == tppp ? 255 : tppp) <CR>
nnoremap <silent>       <c-pagedown> :exe 'se transparency=' . (&transparency == tppp ?  50 : tppp) <CR>

"nnoremap <silent> <Home>   :se transparency=238<CR>
"nnoremap <silent> <S-Home> :se transparency=238<CR>
"nnoremap <silent> <End>    :se transparency=5<CR>
"nnoremap <silent> <S-End>  :se transparency=5<CR>

"nnoremap <C-g> :vim "\<<C-R><C-W>\>" *.c *.h<CR>
nnoremap <C-g> :vim "" <Left><Left>
nnoremap <leader>g :vim "\<<C-R><C-W>\>" 
"nnoremap <leader>G :vim "<C-R><C-W>" *.c *.h<CR>
nnoremap <leader>G :vim "<C-R><C-W>" 



"nnoremap <C-g> <C-]>
"nnoremap <CR> <C-]>zz
nnoremap <expr> <CR>   (&ft != 'qf') ? ('<C-]>z<CR>' . (winheight(0)/4) . '<C-y>') : ('<CR>')
nnoremap <expr> <S-CR> (&ft != 'qf') ? (':tselect<CR>') : ('<CR>')
"nnoremap <expr> <S-CR> (&ft != 'qf') ? ('<C-]>z<CR>' . (winheight(0)/4) . '<C-y>') : ('<CR>')
"function! Jump(c)
"  echo a:c
"  return
"  if a:c < 1
"    tag
"  else
"    exe "normal " . a:c . "G"
"  endif
"endfunction
"com! -count JUMP :call Jump(<q-count>)
"nnoremap <CR> :JUMP<CR>
nnoremap <expr> <C-w><CR> (&ft != 'qf') ? ('<C-w><C-]>z<CR>' . (winheight(0)/4) . '<C-y>') : ('<CR>')
nnoremap <BS><CR> <C-w><C-]>

nnoremap ? /\<\><Left><Left>
nnoremap & /<C-p>\\|\<<C-r><C-w>\><CR>
"nnoremap ! /<C-p>\\|<C-r><C-w><CR>
nnoremap ! /<C-R>*<CR>
nnoremap _ /\<<C-R>*\><CR>

cnorema <C-g> \<\><Left><Left>
cnorema <C-t> \\|

" /			/				o
" /\<\>			?				 
" *			*				o
" g*			#				o
" / 追加		/ <C-p> <C-t>			 
" /\<\> 追加		/ <C-p> <C-g> <C-t>		 
" * 追加		&				o
" g* 追加		!				 

" _ ! ?
" / ? * # & _ ! @

" 沙羅 追加
" 通常 単語
" 通常 カーソル下の単語 コピペ
" Enter要　不要

au BufNewFile,BufRead,FileType * set textwidth=0


nnoremap <C-w><C-t> <C-w>T
nnoremap <leader>l :<C-u>echo len("<C-r><C-w>")<CR>

au BufNewFile,BufRead *.c inoremap @ /*  */<Left><Left><Left>
"nnoremap <silent><A-s> :w<CR>
nnoremap <silent><A-w> :w<CR>
nnoremap <silent><C-^> :w<CR>
nnoremap <silent><C-k> :w<CR>

"au BufNewFile,BufRead,FileType qf set modifiable



"TODO
"Enterで 行番号 タグ GoFile
"Misra, Build Report
"Split + 戻る 進む
"
"
nnoremap <silent> <leader>q :<C-u>q<CR>
nnoremap <silent> q <C-w><C-c>
nnoremap <silent> Q <C-w><C-c>
nnoremap <silent> gf :aboveleft sp<CR>gF


"nnoremap <leader>z :<C-u>bdel<CR>
nnoremap <leader>z :<C-u>bdel
nnoremap <silent><expr> <leader>j &cursorcolumn ? ':setlocal nocursorcolumn<CR>' : ':setlocal cursorcolumn<CR>'



" 印刷 print ------------------------------------------------------------------------------------------


" 縦方向に印刷
:set printoptions=portrait:y

" 横方向に印刷
":set printoptions=portrait:n


" 部単位で印刷する
":set printoptions=collate:y
" （1ページ目、1ページ目、1ページ目、2ページ目、2ページ目、2ページ目、3ページ目、、、）

" ページごとに印刷する
":set printoptions=collate:n
" （1ページ目、1ページ目、1ページ目、2ページ目、2ページ目、2ページ目、3ページ目、、、）


" 片面印刷(デフォルト)
":set printoptions=duplex:off
"
" 両面印刷、長辺綴じ。長辺綴じは用紙の長い辺を基点とする綴じ方。
" 両面印刷 綴じ位置が紙の長い辺
:set printoptions=duplex:long
"
" 両面印刷、短辺綴じ。短辺綴じは用紙の短い辺を基点とする綴じ方。
" 両面印刷 綴じ位置が紙の短い辺
":set printoptions=duplex:short


" 用紙サイズ

" 10x14
":set printoptions+=paper:10x14
" A3
":set printoptions+=paper:A3
" A4
:set printoptions+=paper:A4
" A5
":set printoptions+=paper:A5
" B4
":set printoptions+=paper:B4
" B5
":set printoptions+=paper:B5
" executive
":set printoptions+=paper:executive
" folio
":set printoptions+=paper:folio
" ledger
":set printoptions+=paper:ledger
" legal
":set printoptions+=paper:legal
" letter
":set printoptions+=paper:letter
" quarto
":set printoptions+=paper:quarto
" statement
":set printoptions+=paper:statement
" tabloid
":set printoptions+=paper:tabloid


" -----------------------------------------------------------------------------------------------------


"nnoremap <C-f> <C-w>l
"nnoremap <C-b> <C-w>h

nnoremap <C-Left> <C-w>l
nnoremap <C-Right> <C-w>h
nnoremap <C-Down> <C-w>j
nnoremap <C-Up> <C-w>k

"nnoremap cw ciw
"nnoremap dw diw
"nnoremap yw yiw
"nnoremap ciw cw
"nnoremap diw dw
"nnoremap yiw yw


function! s:tab2space()
  let org_et = &expandtab
  setlocal expandtab

  try
    normal gg/	

    while 1
      normal r	n
    endwhile
  catch
  finally
    "let &expandtab = org_et
  endtry
endfunction
command! Tab2space :call s:tab2space()

nnoremap <leader>: :<C-u>set<Space>
nnoremap <leader>; :<C-u>setl<Space>

nnoremap <leader>/ /<Up>\<Bar>


augroup MyVimrcEm
  au!
  au BufNewFile,BufRead,BufFilePost,BufWinEnter,BufNew,FilterReadPost,FileReadPost *.{c,h} so $vim/em.vim
augroup end

nnoremap <leader>$ f;
cnoremap (( \(
cnoremap )) \)

nnoremap <C-z> nop

"set mps+=「:」

set nrformats-=octal

nnoremap y} 0y}
nnoremap y{ 0y{


nnoremap <BS> <C-w>


inoremap <C-H> <C-G>u<C-H>
"inoremap <CR> <C-]><C-G>u<CR>
inoremap <C-/> <C-O>u



"""""""" Completion """"""""""""""

set complete=.,w,b,u,i,t
set completeopt=menuone,preview
" CUSTOMER CUSTOMER
set complete=.,w,b,u,i
set complete=.,w,b,u

function! TrigCompl(key)
  "set timeoutlen=1
  "set ttimeoutlen=1000
  try
    iunmap jj
  catch
  "inoremap ff <C-Y><Esc>:w<CR>
  finally
  endtry
  call feedkeys("\<C-n>\<C-p>")
  return a:key
endfunc

function! SetCpmplKey(str)
  for k in split(a:str, '\zs')
   "exec "inoremap <expr> " . k . " pumvisible() ? '\<C-e>" . k . "' : search('\\k\\k\\%#', 'bcn') ? TrigCompl('" . k . "')" . " : '" . k . "'"
   "exec "inoremap <expr> " . k . " pumvisible() ? '\<C-e>" . k . "' : search('\\k\\{1\\}\\%#', 'bcn') ? TrigCompl('" . k . "')" . " : '" . k . "'"
    exec "inoremap <expr> " . k . " pumvisible() ? '" . k . "' : search('\\k\\{1\\}\\%#', 'bcn') ? TrigCompl('" . k . "')" . " : '" . k . "'"
   "exec "inoremap <expr> " . k . " pumvisible() ? '\<C-e>" . k . "\<C-n>\<C-p>' : search('\\k\\%#', 'bcn') ? TrigCompl('" . k . "')" . " : '" . k . "'"
   "exec "inoremap <buffer><expr> " . k . " pumvisible() ? '\<C-e>" . k . "\<C-n>\<C-p>' : search('\\k\\%#', 'bcn') ? TrigCompl('" . k . "')" . " : '" . k . "'"
   "exec "inoremap <buffer><expr> " . k . " pumvisible() ? '\<C-e>" . k . "\<C-n>\<C-p>' : search('\\k\\k\\%#', 'bcn') ? TrigCompl('" . k . "')" . " : '" . k . "'"
   "exec "inoremap <buffer><expr> " . k . " pumvisible() ? '\<C-e>" . k . "\<C-n>\<C-p>' : search('\\k\\%#', 'bcn') ? '" . k . "\<C-N>\<C-P>'" . " : '" . k . "'"
   "exec "inoremap <buffer><expr> " . k . " pumvisible() ? '\<C-e>" . k . "\<C-X>\<C-D>' : search('\\k\\%#', 'bcn') ? '" . k . "\<C-X>\<C-D>'" . " : '" . k . "'"
  endfor
endfunction
inoremap <expr> <BS> pumvisible() ? (search('\k\k\k\k\%#', 'bcn') ? '<BS>' : "\<BS>") : (search('\k\k\k\%#', 'bcn') ? TrigCompl("\<BS>") : "\<BS>")
"inoremap <expr> <BS> pumvisible() ? (search('\k\k\k\k\%#', 'bcn') ? '<BS>' : "\<C-e>\<BS>") : (search('\k\k\k\%#', 'bcn') ? TrigCompl("\<BS>") : "\<BS>")
"inoremap <buffer><expr> <BS> pumvisible() ? (search('\k\k\k\k\%#', 'bcn') ? '<BS>' : "\<C-e>\<BS>") : (search('\k\k\k\k\%#', 'bcn') ? TrigCompl("\<BS>") : "\<BS>")

call SetCpmplKey('_0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ')
"to gvimrc
"call SetCpmplKey('ァアィイゥウェエォオカガキギクグケゲコゴサザシジスズセゼソゾタダチヂッツヅテデトドナニヌネノハバパヒビピフブプヘベペホボポマミムメモャヤュユョヨラリルレロヮワヰヱヲンヴヵヶヷヸヹヺ')


"" function! SubsubBS()
""   set timeoutlen=100
""   "set ttimeoutlen=1000
""   call feedkeys("\<C-n>\<C-p>")
""   return "\<BS>"
"" endfunc
"inoremap <buffer><expr> <BS> pumvisible() ? (search('\k\k\k\k\%#', 'bcn') ? '<BS>' : "\<C-e>\<BS>") : (search('\k\k\k\k\%#', 'bcn') ? "\<BS>\<C-N>\<C-P>" : "\<BS>")

augroup MyComplete
  au!
  "au CompleteDone * set timeoutlen=200
  au CompleteDone * inoremap <silent> <expr> jj pumvisible() ? '<C-N><C-N>' : '<Esc>:w<CR>'
  "au CompleteDone * try | iunmap ff | catch | finally
  "au CompleteDone * set ttimeoutlen=-1
augroup end

"inoremap <buffer><expr> <C-J> pumvisible() ? '<C-N>' : '<C-J>'
"inoremap <buffer><expr> <C-K> pumvisible() ? '<C-P>' : '<C-K>'

function! Cmpl_j()
  "set timeoutlen=1
  try
    iunmap jj
  catch
  finally
  "inoremap ff <C-Y><Esc>:w<CR>
  endtry
  call feedkeys("\<C-n>")
  return ''
endfunction
function! Cmpl_k()
  "set timeoutlen=1
  try
    iunmap jj
  catch
  finally
  "inoremap ff <C-Y><Esc>:w<CR>
  endtry
  call feedkeys("\<C-p>")
  return ''
endfunction


inoremap <silent> <expr> jj pumvisible() ? '<C-N><C-N>' : '<Esc>:w<CR>'
inoremap <expr> j pumvisible() ? Cmpl_j() : TrigCompl('j')
inoremap <expr> k pumvisible() ? Cmpl_k() : TrigCompl('k')
"inoremap <expr> j pumvisible() ? '<C-N>' : TrigCompl('j')
"inoremap <expr> k pumvisible() ? '<C-P>' : TrigCompl('k')
inoremap <expr> <C-J> pumvisible() ? 'j' : '<C-J>'
inoremap <expr> <C-K> pumvisible() ? 'k' : '<C-K>'

inoremap <expr> ff pumvisible() ? '<C-Y><Esc>:w<CR>' : 'ff'


"inoremap <buffer><expr> jj pumvisible() ? '<C-N><C-N>' : '<Esc>:w<CR>'
"inoremap <buffer><expr> j pumvisible() ? '<C-N>' : TrigCompl('j')
"inoremap <buffer><expr> k pumvisible() ? '<C-P>' : TrigCompl('k')
"inoremap <buffer><expr> <C-J> pumvisible() ? 'j' : '<C-J>'
"inoremap <buffer><expr> <C-K> pumvisible() ? 'k' : '<C-K>'
"inoremap <buffer><expr> <M-J> pumvisible() ? 'j' : '<M-J>'
"inoremap <buffer><expr> <M-K> pumvisible() ? 'k' : '<M-K>'

"inoremap <Tab> <C-]><Tab>

"""""""" Completion End """"""""""""""


" CUSTOMER CUSTOMER
ab df #define
ab ul ulong
ab us ushort
ab uc uchar

set shiftround





if has('win32') || has('win64') " || has('win32unix')
endif


function! Eatchar(pat)
  let c = nr2char(getchar(0))
  return (c =~ a:pat) ? '' : c
endfunc
"例 iabbr <silent> if if ()<Left><C-R>=Eatchar('\s')<CR>

iab <silent> gh Ghddrv_<C-R>=Eatchar('\s')<CR><C-p><C-n>
iab <silent> di Ghddrv_DI()<C-R>=Eatchar('\s')<CR>
iab <silent> ei Ghddrv_EI()<C-R>=Eatchar('\s')<CR>
iab <silent> DI Ghddrv_DI()<C-R>=Eatchar('\s')<CR>
iab <silent> EI Ghddrv_EI()<C-R>=Eatchar('\s')<CR>


nnoremap <silent> ZZ :w<CR>
nnoremap <S-CR> gD


nnoremap <expr> zl &wrap ? 'L' : 'zl'
nnoremap <expr> zh &wrap ? 'H' : 'zh'


nnoremap cp cw<C-r>0



" 基本
" 検索
" 置換
" 補完
" 画面、表示　（ウィンドウ、バッファ、タブ）
" 便利ツール
" 移動、切り替え　（ウィンドウ、バッファ、タブ）
" タブジャンプ
"
" 移動
" 見た目
" 編集
