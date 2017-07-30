scriptencoding utf-8
" vim:set ts=8 sts=2 sw=2 tw=0: (この行に関しては:help modelineを参照)
"
" An example for a Japanese version vimrc file.
" 日本語版のデフォルト設定ファイル(vimrc) - Vim 7.4
"
" Last Change: 19-Jul-2017.
" Maintainer:  MURAOKA Taro <koron.kaoriya@gmail.com>
"
" 解説:
" このファイルにはVimの起動時に必ず設定される、編集時の挙動に関する設定が書
" かれています。GUIに関する設定はgvimrcに書かかれています。
"
" 個人用設定は_vimrcというファイルを作成しそこで行ないます。_vimrcはこのファ
" イルの後に読込まれるため、ここに書かれた内容を上書きして設定することが出来
" ます。_vimrcは$HOMEまたは$VIMに置いておく必要があります。$HOMEは$VIMよりも
" 優先され、$HOMEでみつかった場合$VIMは読込まれません。
"
" 管理者向けに本設定ファイルを直接書き換えずに済ませることを目的として、サイ
" トローカルな設定を別ファイルで行なえるように配慮してあります。Vim起動時に
" サイトローカルな設定ファイル($VIM/vimrc_local.vim)が存在するならば、本設定
" ファイルの主要部分が読み込まれる前に自動的に読み込みます。
"
" 読み込み後、変数g:vimrc_local_finishが非0の値に設定されていた場合には本設
" 定ファイルに書かれた内容は一切実行されません。デフォルト動作を全て差し替え
" たい場合に利用して下さい。
"
" 参考:
"   :help vimrc
"   :echo $HOME
"   :echo $VIM
"   :version

"---------------------------------------------------------------------------
" サイトローカルな設定($VIM/vimrc_local.vim)があれば読み込む。読み込んだ後に
" 変数g:vimrc_local_finishに非0な値が設定されていた場合には、それ以上の設定
" ファイルの読込を中止する。
if 1 && filereadable($VIM . '/vimrc_local.vim')
  unlet! g:vimrc_local_finish
  source $VIM/vimrc_local.vim
  if exists('g:vimrc_local_finish') && g:vimrc_local_finish != 0
    finish
  endif
endif

"---------------------------------------------------------------------------
" ユーザ優先設定($HOME/.vimrc_first.vim)があれば読み込む。読み込んだ後に変数
" g:vimrc_first_finishに非0な値が設定されていた場合には、それ以上の設定ファ
" イルの読込を中止する。
if 1 && exists('$HOME') && filereadable($HOME . '/.vimrc_first.vim')
  unlet! g:vimrc_first_finish
  source $HOME/.vimrc_first.vim
  if exists('g:vimrc_first_finish') && g:vimrc_first_finish != 0
    finish
  endif
endif

" plugins下のディレクトリをruntimepathへ追加する。
for s:path in split(glob($VIM.'/plugins/*'), '\n')
  if s:path !~# '\~$' && isdirectory(s:path)
    let &runtimepath = &runtimepath.','.s:path
  end
endfor
unlet s:path

"---------------------------------------------------------------------------
" 日本語対応のための設定:
"
" ファイルを読込む時にトライする文字エンコードの順序を確定する。漢字コード自
" 動判別機能を利用する場合には別途iconv.dllが必要。iconv.dllについては
" README_w32j.txtを参照。ユーティリティスクリプトを読み込むことで設定される。
source $VIM/plugins/kaoriya/encode_japan.vim
" メッセージを日本語にする (Windowsでは自動的に判断・設定されている)
if !(has('win32') || has('mac')) && has('multi_lang')
  if !exists('$LANG') || $LANG.'X' ==# 'X'
    if !exists('$LC_CTYPE') || $LC_CTYPE.'X' ==# 'X'
      language ctype ja_JP.eucJP
    endif
    if !exists('$LC_MESSAGES') || $LC_MESSAGES.'X' ==# 'X'
      language messages ja_JP.eucJP
    endif
  endif
endif
" MacOS Xメニューの日本語化 (メニュー表示前に行なう必要がある)
if has('mac')
  set langmenu=japanese
endif
" 日本語入力用のkeymapの設定例 (コメントアウト)
if has('keymap')
  " ローマ字仮名のkeymap
  "silent! set keymap=japanese
  "set iminsert=0 imsearch=0
endif
" 非GUI日本語コンソールを使っている場合の設定
if !has('gui_running') && &encoding != 'cp932' && &term == 'win32'
  set termencoding=cp932
endif

"---------------------------------------------------------------------------
" メニューファイルが存在しない場合は予め'guioptions'を調整しておく
if 1 && !filereadable($VIMRUNTIME . '/menu.vim') && has('gui_running')
  set guioptions+=M
endif

"---------------------------------------------------------------------------
" Bram氏の提供する設定例をインクルード (別ファイル:vimrc_example.vim)。これ
" 以前にg:no_vimrc_exampleに非0な値を設定しておけばインクルードはしない。
if 1 && (!exists('g:no_vimrc_example') || g:no_vimrc_example == 0)
  if &guioptions !~# "M"
    " vimrc_example.vimを読み込む時はguioptionsにMフラグをつけて、syntax on
    " やfiletype plugin onが引き起こすmenu.vimの読み込みを避ける。こうしない
    " とencに対応するメニューファイルが読み込まれてしまい、これの後で読み込
    " まれる.vimrcでencが設定された場合にその設定が反映されずメニューが文字
    " 化けてしまう。
    set guioptions+=M
    source $VIMRUNTIME/vimrc_example.vim
    set guioptions-=M
  else
    source $VIMRUNTIME/vimrc_example.vim
  endif
endif

"---------------------------------------------------------------------------
" 検索の挙動に関する設定:
"
" 検索時に大文字小文字を無視 (noignorecase:無視しない)
set ignorecase
" 大文字小文字の両方が含まれている場合は大文字小文字を区別
set smartcase

"---------------------------------------------------------------------------
" 編集に関する設定:
"
" タブの画面上での幅
set tabstop=8
" タブをスペースに展開しない (expandtab:展開する)
set noexpandtab
" 自動的にインデントする (noautoindent:インデントしない)
set autoindent
" バックスペースでインデントや改行を削除できるようにする
set backspace=indent,eol,start
" 検索時にファイルの最後まで行ったら最初に戻る (nowrapscan:戻らない)
set wrapscan
" 括弧入力時に対応する括弧を表示 (noshowmatch:表示しない)
set showmatch
" コマンドライン補完するときに強化されたものを使う(参照 :help wildmenu)
set wildmenu
" テキスト挿入中の自動折り返しを日本語に対応させる
set formatoptions+=mM

"---------------------------------------------------------------------------
" GUI固有ではない画面表示の設定:
"
" 行番号を非表示 (number:表示)
set nonumber
" ルーラーを表示 (noruler:非表示)
set ruler
" タブや改行を表示 (list:表示)
set nolist
" どの文字でタブや改行を表示するかを設定
"set listchars=tab:>-,extends:<,trail:-,eol:<
" 長い行を折り返して表示 (nowrap:折り返さない)
set wrap
" 常にステータス行を表示 (詳細は:he laststatus)
set laststatus=2
" コマンドラインの高さ (Windows用gvim使用時はgvimrcを編集すること)
set cmdheight=2
" コマンドをステータス行に表示
set showcmd
" タイトルを表示
set title
" 画面を黒地に白にする (次行の先頭の " を削除すれば有効になる)
"colorscheme evening " (Windows用gvim使用時はgvimrcを編集すること)

"---------------------------------------------------------------------------
" ファイル操作に関する設定:
"
" バックアップファイルを作成しない (次行の先頭の " を削除すれば有効になる)
"set nobackup


"---------------------------------------------------------------------------
" ファイル名に大文字小文字の区別がないシステム用の設定:
"   (例: DOS/Windows/MacOS)
"
if filereadable($VIM . '/vimrc') && filereadable($VIM . '/ViMrC')
  " tagsファイルの重複防止
  set tags=./tags,tags
endif

"---------------------------------------------------------------------------
" コンソールでのカラー表示のための設定(暫定的にUNIX専用)
if has('unix') && !has('gui_running')
  let s:uname = system('uname')
  if s:uname =~? "linux"
    set term=builtin_linux
  elseif s:uname =~? "freebsd"
    set term=builtin_cons25
  elseif s:uname =~? "Darwin"
    set term=beos-ansi
  else
    set term=builtin_xterm
  endif
  unlet s:uname
endif

"---------------------------------------------------------------------------
" コンソール版で環境変数$DISPLAYが設定されていると起動が遅くなる件へ対応
if !has('gui_running') && has('xterm_clipboard')
  set clipboard=exclude:cons\\\|linux\\\|cygwin\\\|rxvt\\\|screen
endif

"---------------------------------------------------------------------------
" プラットホーム依存の特別な設定

" WinではPATHに$VIMが含まれていないときにexeを見つけ出せないので修正
if has('win32') && $PATH !~? '\(^\|;\)' . escape($VIM, '\\') . '\(;\|$\)'
  let $PATH = $VIM . ';' . $PATH
endif

if has('mac')
  " Macではデフォルトの'iskeyword'がcp932に対応しきれていないので修正
  set iskeyword=@,48-57,_,128-167,224-235
endif

"---------------------------------------------------------------------------
" KaoriYaでバンドルしているプラグインのための設定

" autofmt: 日本語文章のフォーマット(折り返し)プラグイン.
set formatexpr=autofmt#japanese#formatexpr()

" vimdoc-ja: 日本語ヘルプを無効化する.
if kaoriya#switch#enabled('disable-vimdoc-ja')
  let &rtp = join(filter(split(&rtp, ','), 'v:val !~ "[/\\\\]plugins[/\\\\]vimdoc-ja"'), ',')
endif

" vimproc: 同梱のvimprocを無効化する
if kaoriya#switch#enabled('disable-vimproc')
  let &rtp = join(filter(split(&rtp, ','), 'v:val !~ "[/\\\\]plugins[/\\\\]vimproc$"'), ',')
endif

" go-extra: 同梱の vim-go-extra を無効化する
if kaoriya#switch#enabled('disable-go-extra')
  let &rtp = join(filter(split(&rtp, ','), 'v:val !~ "[/\\\\]plugins[/\\\\]golang$"'), ',')
endif

" Copyright (C) 2009-2016 KaoriYa/MURAOKA Taro


"takubo

if has('win32') || has('win64') " || has('win32unix')
  let s:home = 'C:\cygwin\home\' . $USERNAME
  if isdirectory(s:home)
    let $HOME=s:home
  endif
  let $PATH.=';C:\cygwin\bin'
  let $PATH.=':/cygdrive/c/cygwin/bin'
  "set sh=D:\takubo\bin\zckw\ckw
  "set sh=D:\takubo\bin\zckw\ckw -e\ C:\cygwin\bin\zsh
  "set sh=C:\cygwin\cygwin.bat
  set sh=C:\cygwin\bin\zsh
  "set sh=C:\cygwin\bin\mintty
  "set shcf=-c
  set shcf=-c\	
  "set shellquote=\"
  "set shellxquote=\"\ 
  set shellxquote=\"
  set ssl
  exe 'set rtp+=C:\cygwin\home\' . $USERNAME . '\dotfiles\.vim'
  exe 'set rtp+=C:\cygwin\home\' . $USERNAME . '\dotfiles\.vim\after'
endif

if !isdirectory($HOME . "/vim_buckup")
  call mkdir($HOME . "/vim_buckup")
endif

if !isdirectory($HOME . "/vim_swap")
  call mkdir($HOME . "/vim_swap")
endif

set autochdir
set autoindent
" バックスペースでインデントや改行を削除できるようにする
set backspace=2
set backupdir=$HOME/vim_buckup
set directory=$HOME/vim_swap
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
"リロードするときにアンドゥのためにバッファ全体を保存する
set undoreload=-1
"実際に文字がないところにもカーソルを置けるようにする
set virtualedit=block
set wildmenu
" 長い行を折り返して表示 (nowrap:折り返さない)
set wrap
" 検索時にファイルの最後まで行ったら最初に戻る (nowrapscan:戻らない)
set nowrapscan
set noundofile
set nrformats-=octal
set shiftround
"set fileformats=unix,dos,mac
set fileformats=unix,dos
" for 1st empty buffer
set fileformat=unix
"set tag+=;
set tags+=tags;
set isfname-=:

"set viminfo+='100,c
set sessionoptions+=unix,slash
" set_end set end

filetype on

syntax enable

colorscheme Vitamin
" TODO hi CursorLine ctermbg=NONE guibg=NONE


augroup MyVimrc
  au!

  au QuickfixCmdPost make,grep,grepadd,vimgrep,cbuffer,cfile botright copen
  au QuickfixCmdPost lmake,lgrep,lgrepadd,lvimgrep,lcbuffer,lcfile botright lopen
 "au BufNewFile,BufRead,FileType qf set modifiable

  " grepする際に'|cw'を付けなくても、Quickfixに結果を表示する
  au QuickfixCmdPost vimgrep botright cwindow
  "au QuickfixCmdPost make,grep,grepadd,vimgrep 999wincmd w

  au InsertEnter * set timeoutlen=200
  au InsertLeave * set timeoutlen=15000

  au WinEnter * set cursorline
  au WinEnter * set cursorcolumn
  au WinLeave * set nocursorline
  au WinLeave * set nocursorcolumn

  "au FileType c,cpp,awk set mps+=?::,=:;

 "au BufNewFile,BufRead,FileType *.awk so $vim/avd/avd.vim
  au BufNewFile,BufRead,FileType * set textwidth=0

  au BufNewFile,BufRead *.c inoremap @ /*  */<Left><Left><Left>
augroup end

let g:TypewriterScroll = 0
nnoremap <Leader>H <Esc>:<C-u>let g:TypewriterScroll = !g:TypewriterScroll <Bar> call <SID>best_scrolloff()<CR>

function! s:best_scrolloff()
  if g:TypewriterScroll
    setlocal  scrolloff=9999
  else
    exe "setlocal  scrolloff=" . (winheight(0) < 10 ? 0 : winheight(0) < 20 ? 2 : 5)
  endif
endfunction
augroup MyVimrc_ScrollOff
  au!
  au BufNewFile,BufRead	* call <SID>best_scrolloff()
  au WinEnter		* call <SID>best_scrolloff()
  au VimResized		* call <SID>best_scrolloff()
augroup end
"kwbd.vim : ウィンドウレイアウトを崩さないでバッファを閉じる
" http://nanasi.jp/articles/vim/kwbd_vim.html
com! Kwbd let kwbd_bn= bufnr("%")|enew|exe "bdel ".kwbd_bn|unlet kwbd_bn

let $PATH = $PATH . 'C:\Oracle\Ora11R2\bin;%SystemRoot%\system32;%SystemRoot%;%SystemRoot%\System32\Wbem;%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\;C:\Program Files\Common Files\Compuware;C:\Program Files\WinMerge;C:\Program Files\Subversion\bin;C:\Program Files\TortoiseSVN\bin;D:\takubo\bin\;C:\Perl\bin'


nnoremap <silent> <Space> <C-f>
nnoremap <silent> <S-Space> <C-b>
vnoremap <silent> <Space> <C-f>
vnoremap <silent> <S-Space> <C-b>
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k
vnoremap j gj
vnoremap k gk
vnoremap gj j
vnoremap gk k
nnoremap Y y$
nnoremap <expr> y} '0y}' . col('.') . "\<Bar>"
nnoremap y{ $y{
nnoremap <expr> yp '0y$' . col('.') . "\<Bar>"
"nnoremap <silent> <Esc><Esc> <Esc>:noh<CR>
nnoremap <silent> <Esc><Esc> <Esc>:noh<CR>:call clever_f#reset()<CR>
"nnoremap <silent> <Esc><Esc> <Esc>:noh<CR>:SearchReset<CR>:SearchBuffersReset<CR> TODO multiplesearch
nnoremap cp cw<C-r>0
nnoremap da 0d$
nnoremap <silent> ZZ :<CR>
nnoremap <silent> ZQ :<CR>
nnoremap <C-o> O<Esc>
nnoremap <A-o> o<Esc>

nnoremap <silent><expr> <leader>n !&number <Bar><Bar> &relativenumber ?  ':set   number norelativenumber<CR>' : ':set relativenumber<CR>'
nnoremap <silent><expr> <leader>N  &number <Bar><Bar> &relativenumber ?  ':set nonumber norelativenumber<CR>' : ':set number<CR>'

" コメント行後の新規行の自動コメント化のON/OFF
nnoremap <silent><expr> <leader># &formatoptions =~# 'o' ?  ':set formatoptions-=o<CR>:set formatoptions-=r<CR>' : ':set formatoptions+=o<CR>:set formatoptions+=r<CR>'

nnoremap <silent><expr> <leader>. stridx(&isk, '.') < 0 ? ':setl isk+=.<CR>' : ':setl isk-=.<CR>'
nnoremap <silent><expr> <leader>, stridx(&isk, '_') < 0 ? ':setl isk+=_<CR>' : ':setl isk-=_<CR>'
nnoremap <silent><expr> <leader>u stridx(&isk, '_') < 0 ? ':setl isk+=_<CR>' : ':setl isk-=_<CR>'

" ^に、|の機能を重畳
nnoremap <silent> ^ <Esc>:exe v:prevcount ? ('normal! ' . v:prevcount . '<Bar>') : 'normal! ^'<CR>

nnoremap <silent><expr> yd stridx(&isk, '.') < 0 ? ':setl isk+=.<CR>' : ':set isk-=.<CR>'
nnoremap <silent><expr> yu stridx(&isk, '_') < 0 ? ':setl isk+=_<CR>' : ':set isk-=_<CR>'

nnoremap <silent> <leader>p :disp<CR>
nnoremap <silent> <Leader>m :marks<CR>
nnoremap <silent> <Leader>" :disp<CR>
nnoremap <silent> <Leader>k :make<CR>
nnoremap <silent> <leader>t :ToggleWord<CR>
nnoremap <leader>: :<C-u>set<Space>
nnoremap <leader>; :<C-u>setl<Space>

nnoremap g; :<C-u>set<Space>
nnoremap <leader>; :<C-u>setl<Space>
nnoremap <C-z> nop
nnoremap <silent><expr> <leader>j &cursorcolumn ? ':setlocal nocursorcolumn<CR>' : ':setlocal cursorcolumn<CR>'

nnoremap  ]]  ]]f(bzt
nnoremap g]]  ]]f(b
nnoremap  [[  [[f(bzt
nnoremap g[[  [[f(b
nnoremap  ][  ][zb
nnoremap g][  ][
nnoremap  []  []zb
nnoremap g[]  []

vnoremap af ][<ESC>V[[
vnoremap if ][k<ESC>V[[j

" Emacs {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{
" コマンドラインでのキーバインドを Emacs スタイルにします
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
" Emacs }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}

" 検索時に/, ?を楽に入力する
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'

cnoremap (( \(
cnoremap )) \)

cnoremap <expr> <C-t>	  getcmdtype() == ':' ? '../' :
			\ (getcmdtype() == '/' <Bar><Bar> getcmdtype() == '?') ? '\\|' :
			\ '<C-t>'


" Search {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{
"? nnoremap <leader>/ /<Up>\<Bar>

"? nnoremap ? /\<\><Left><Left>
"? nnoremap <Bar> /<C-p>\<Bar>

"nnoremap ! /<C-p>\\|<C-r><C-w><CR>
"nnoremap ! /<C-R>*<CR>

"? __nnoremap _ /\<<C-R>*\><CR>

"nnoremap <leader>* /\<_\?<C-r><C-w>\><CR>
"nnoremap <expr> <leader>* (match(expand("<cword>"), '_') == 0) ? ('/\<_\?' . substitute(expand("<cword>"), '^_', '', '') . '\><CR>') : ('/\<_\?<C-r><C-w>\><CR>')
"nnoremap <expr> <leader># (match(expand("<cword>"), '_') == 0) ? ('/_\?' . substitute(expand("<cword>"), '^_', '', '') . '<CR>') : ('/_\?<C-r><C-w><CR>')

"nnoremap ! /<C-p>\\|\<<C-r><C-w>\><CR>

nnoremap <expr> * (match(expand("<cword>"), '_') == 0) ? ('/\<_\?' . substitute(expand("<cword>"), '^_', '', '') . '\><CR>') : ('/\<_\?<C-r><C-w>\><CR>')
nnoremap <expr> # (match(expand("<cword>"), '_') == 0) ? ('/_\?' . substitute(expand("<cword>"), '^_', '', '') . '<CR>') : ('/_\?<C-r><C-w><CR>')

nnoremap        g# g*
nnoremap        g* *

nnoremap <expr> ! '/<C-p>\\|\<' . ((match(expand("<cword>"), '_') == 0) ? ('_\?' . substitute(expand("<cword>"), '^_', '', '')) : ('_\?<C-r><C-w>')) . '\><CR>'
nnoremap <expr> & '/<C-p>\\|' . ((match(expand("<cword>"), '_') == 0) ? ('_\?' . substitute(expand("<cword>"), '^_', '', '')) : ('_\?<C-r><C-w>')) . '<CR>'

nnoremap        g! /<C-p>\\|\<<C-r><C-w>\><CR>
nnoremap        g& /<C-p>\\|<C-r><C-w><CR>

nnoremap     ? /<C-p>\<Bar>
nnoremap     ? /\M
nnoremap <Bar> /<C-p>\<Bar>\<\><Left><Left>

cnoremap <C-g> \<\><Left><Left>

let g:MigemoIsSlash = 0
if has('migemo')
  function! s:toggle_migemo_search()
    let g:MigemoIsSlash = !g:MigemoIsSlash
    if g:MigemoIsSlash
      nnoremap / g/
      nnoremap ? /
      let g:clever_f_use_migemo=1
    else
      nnoremap / /
      nnoremap ? g/
      let g:clever_f_use_migemo=0
    endif
  endfunction

 "nnoremap / /
  nnoremap ? g/
  nnoremap <silent> <leader>/ :<C-u>call <SID>toggle_migemo_search()<CR>
endif

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

" 新規 追加
" 通常 単語囲み
" 入力 カーソル下の単語 クリップボード
" Enter要 不要

" Search }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}


" Substitute {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{
nnoremap <C-s>           :<C-u>g%.%s    /
nnoremap <C-s>           :<C-u>g%.%s    %%<Left>
nnoremap <leader><C-s>   :<C-u>g%.%s    %
nnoremap g<C-s>   :<C-u>g%.%s    /<C-R>//<C-R><C-W>/
nnoremap <A-s>           :<C-u>g%.%s    /<C-R>//
vnoremap <C-s>           :s    /
vnoremap <leader><C-s>   :s    /<C-R>//<C-R><C-W>/
" Substitute }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}


" Grep {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{
"nnoremap <C-g> :vim "\<<C-R><C-W>\>" *.c *.h<CR>
nnoremap <C-g> :vim "" <Left><Left>
nnoremap <leader>g :vim "\<<C-R><C-W>\>" 
"nnoremap <leader>G :vim "<C-R><C-W>" *.c *.h<CR>
nnoremap <leader>G :vim "<C-R><C-W>" 
" Grep }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}


" Tag {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{
"   TODO
"     先頭のアンダーバー
"     関数のみf(b
"     ラベルならf:b
"     変数なら、スクロールしない
"     引数のタグ
"     asmのタグ
"
noremap H <C-o>
noremap L <C-i>
"補償
nnoremap zh H
nnoremap zl L
"nnoremap zm M
nnoremap <expr> zl &wrap ? 'L' : 'zl'
nnoremap <expr> zh &wrap ? 'H' : 'zh'

nnoremap <C-k> H
nnoremap <C-j> L

nnoremap <S-CR> gD

function! MyTag(www)
  exe "tjump " . a:www
  exe 'normal! ' . 'z<CR>' . (winheight(0)/4) . '<C-y>'
endfunction

"nnoremap <expr> <CR>   (&ft != 'qf') ? ('<C-]>z<CR>' . (winheight(0)/4) . '<C-y>') : ('<CR>')

function! PostTagJumpCursor_C()
	if search('\%##define\s\+\k\+(', 'bcn')
		normal! ww
	elseif search('\%##define\s\+\k\+\s\+', 'bcn')
		normal! ww
	elseif search('\%#.\+;', 'bcn')
		normal! f;b
	else
		"関数
		normal! $F(b
	endif
endfunction
function! CR(arg)
	"let w = a:w
	let w0 = expand("<cword>")
	let w = w0
	let g:tacubo = w

	if v:prevcount
		"exe v:prevcount
		"この方法(feedkeys)なら、移動行が履歴に残る。 exeだと、残らない。
		call feedkeys(':' . v:prevcount . "\<CR>:\<Esc>", 't')
	elseif &ft == 'qf'
		exe "normal! \<CR>"
	elseif &ft == 'help'
		exe "normal! \<C-]>"
	else
		"for i in range(2)
		for i in range(2 + 2)
			try
				"exe "normal! \<C-]>z\<CR>" . (winheight(0)/4) . "\<C-y>"
				if a:arg == ''
					exe "tag " . w
				else
					exe "tselect " . w
				endif
				exe "normal! z\<CR>" . (winheight(0)/4) . "\<C-y>"
				call PostTagJumpCursor_C()
				"
				return
			catch
				if w0 =~ '^_'
				" 元の検索語は"_"始まり
					let w = substitute(w0, '^_', '', '')
				else
				" 元の検索語は"_"始まりでない
					let w = '_' . w0
				endif
			endtry
		endfor

		echohl ErrorMsg
		"echo "タグが見つかりません。"
		echo "E***: No Tag Found."
		"echo v:exception
		echohl None
	endif
endfunction
nnoremap <silent> <CR> <Esc>:call CR('')<CR>
nnoremap <silent> g<CR> <Esc>:call CR('g')<CR>
"
"nnoremap <expr> <CR>   (&ft != 'qf') ? (':<C-u>tjump <C-r><C-w><CR>') : ('<CR>')
"? nnoremap <silent><expr> <CR>   (&ft != 'qf') ? (':call MyTag("' . "\<C-r>\<C-w>" . '")<CR>') : ('<CR>')
"? nnoremap <expr> <leader><CR> (&ft != 'qf') ? (':tselect <C-r><C-w><CR>') : ('<CR>')
nnoremap <expr> <S-CR>   (&ft != 'qf') ? ('<C-]>z<CR>' . (winheight(0)/4) . '<C-y>') : ('<CR>')
"? au BufNewFile,BufRead *.jax nnoremap <expr> <S-CR>   (&ft != 'qf') ? ('<C-]>z<CR>' . (winheight(0)/4) . '<C-y>') : ('<CR>')
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
" TODO Quickfix
nnoremap <expr> <C-w><CR> (&ft != 'qf') ? ('<C-w><C-]>z<CR>' . (winheight(0)/4) . '<C-y>') : ('<CR>')
" TODO QuickFix
nnoremap <BS><CR> <C-w><C-]>
nnoremap <leader><CR> <C-w><C-]>

nnoremap <silent> gf :aboveleft sp<CR>gF
" Tag }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}


" Diff {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{
"" diff
nnoremap <expr> <leader>d &diff ? ':diffoff<CR>' : ':diffthis<CR>'
"" diffup (diffthisを実行)
nnoremap <expr> <leader>D &diff ? ':diffupdate<CR>' : ':diffthis<CR>'

nnoremap <expr> <leader><C-d> match(&diffopt, 'iwhite') < 0 ? ':<C-u>set diffopt+=iwhite<CR>' : ':<C-u>set diffopt-=iwhite<CR>'

nnoremap <expr> dx &diff ? ':diffoff<CR>' : ':diffthis<CR>'
nnoremap <expr> du &diff ? ':diffupdate<CR>' : ':diffthis<CR>'
nnoremap <expr> di match(&diffopt, 'iwhite') < 0 ? ':<C-u>set diffopt+=iwhite<CR>' : ':<C-u>set diffopt-=iwhite<CR>'
nnoremap        dq :diffoff<CR>
nnoremap        dc :diffoff<CR>
nnoremap        dz :echo &diffopt<CR>

"nnoremap <silent> <leader>o :%foldopen<CR>
"nnoremap <silent> <leader>O :%foldclose<CR>
" 余りキーマップ	dq, dr, ds. dg, dz, dx, dc, dv, dm
" Diff }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}



" Window {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{
nnoremap <BS> <C-w>

"nnoremap <BS> <C-w>v
nnoremap <BS><BS> <C-w>v
nnoremap <silent> <s-BS> :vnew<cr>
nnoremap <c-BS> <C-w>s
nnoremap <silent> <s-c-BS> <esc>:new<cr>

"nnoremap <c-up> <C-w>K
"nnoremap <c-down> <C-w>J
"nnoremap <c-left> <C-w>H
"nnoremap <c-right> <C-w>L

nnoremap <Tab> <C-w>w
nnoremap <S-Tab> <C-w>W
nnoremap <C-w><C-w> <C-w>p

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

nnoremap <silent> <up>	    <esc>3<C-w>+:call	<SID>best_scrolloff()<CR>
nnoremap <silent> <down>    <esc>3<C-w>-:call	<SID>best_scrolloff()<CR>
nnoremap <silent> <left>    <esc>5<C-w><:call	<SID>best_scrolloff()<CR>
nnoremap <silent> <right>   <esc>5<C-w>>:call	<SID>best_scrolloff()<CR>

nnoremap <silent> <S-up>    <esc><C-w>+:call	<SID>best_scrolloff()<CR>
nnoremap <silent> <S-down>  <esc><C-w>-:call	<SID>best_scrolloff()<CR>
nnoremap <silent> <S-left>  <esc><C-w><:call	<SID>best_scrolloff()<CR>
nnoremap <silent> <S-right> <esc><C-w>>:call	<SID>best_scrolloff()<CR>

nnoremap <silent> <C-up>    <C-w>_:call		<SID>best_scrolloff()<CR>
nnoremap <silent> <C-down> 1<C-w>_:call		<SID>best_scrolloff()<CR>
nnoremap <silent> <C-left> 1<C-w><bar>:call	<SID>best_scrolloff()<CR>
nnoremap <silent> <C-right> <C-w><bar>:call	<SID>best_scrolloff()<CR>

nnoremap <silent> <A-up>    <C-w>K:call		<SID>best_scrolloff()<CR>
nnoremap <silent> <A-down>  <C-w>J:call		<SID>best_scrolloff()<CR>
nnoremap <silent> <A-left>  <C-w>H:call		<SID>best_scrolloff()<CR>
nnoremap <silent> <A-right> <C-w>L:call		<SID>best_scrolloff()<CR>

nnoremap <silent> q <C-w><C-c>
nnoremap <silent> <C-q>: q:
nnoremap <silent> <C-q>/ q/
nnoremap <silent> <C-q>? q?
nnoremap <silent> <leader>q :<C-u>q<CR>

nnoremap <C-Left>	<C-w>h
nnoremap <C-Right>	<C-w>l
nnoremap <C-Down>	<C-w>j
nnoremap <C-Up>		<C-w>k

nnoremap <C-w><C-t> <C-w>T
" Window }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}


" Tab {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{
nnoremap <C-t> :tabnew<Space>
"nnoremap <C-t> :tabnew %<CR> :e 

noremap <C-Tab>   gt
noremap <C-S-Tab> gT

nnoremap <C-f> gt
nnoremap <C-b> gT

nnoremap <silent><expr> <leader>T !&showtabline ? ':<C-u>set showtabline=2<CR>' : ':<C-u>set showtabline=0<CR>'
nnoremap <silent><expr> gt !&showtabline ? ':<C-u>set showtabline=2<CR>' : ':<C-u>set showtabline=0<CR>'
" Tab }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}


" Buffer {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{
nnoremap K :<C-u>ls!<CR>:b 
nnoremap K :<C-u>ls<CR>:b 

nnoremap <silent> <C-n> :bnext<CR>
nnoremap <silent> <C-p> :bprev<CR>

nnoremap <leader>z :<C-u>bdel
nnoremap <leader>Z :<C-u>bdel!
" Buffer }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}


" Transparency {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{
let g:my_transparency = 229
let g:my_transparency = 235
augroup MyVimrc_GUI
  au!
  au GUIEnter * simalt ~x
  exe 'au GUIEnter * set transparency=' . g:my_transparency
augroup end

nnoremap <silent>       <s-pageup> :exe 'se transparency=' . (&transparency + 1)<CR>
nnoremap <silent><expr> <s-pagedown> (&transparency > 1) ? (":exe 'se transparency=' . (&transparency - 1)<CR>") : ("")

nnoremap <silent><expr> <pageup>   ':se transparency=' . min([&transparency + 3, 255]) . '<CR>'
nnoremap <silent><expr> <pagedown> ':se transparency=' . max([&transparency - 3,   1]) . '<CR>'

nnoremap <silent>       <c-pageup>   :exe 'se transparency=' . (&transparency == g:my_transparency ? 255 : g:my_transparency) <CR>
nnoremap <silent>       <c-pagedown> :exe 'se transparency=' . (&transparency == g:my_transparency ?  50 : g:my_transparency) <CR>
" Transparency }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}



" Statusline {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

"set statusline=\ \ %<%#SLFileName#[\ %{winnr()}\ ]%##\ (\ %n\ )\ %##%h%w\ %<%#SLFileName#\ %F\ %##\ %r\ %m\ \ \ %=%#SLFileName#\ %{(&ff)},\ %{&fenc},\ %y,\ %1{stridx(&isk,'.')<0?'\ ':'.'}\ %1{stridx(&isk,'_')<0?'\ ':'_'}\ %1{c_jk_local!=0?'@':'\ '}\ %##\ [%4l\ %3v]\ %#SLFileName#%3p%%\ %L\ %##\ \ %{repeat('\ ',winwidth(0)-b:buf_name_len)}

"let stl_fn = '%t'
"set statusline=\ \ %#SLFileName#[\ %{winnr()}\ ]%##\ (\ %n\ )\ %m\ %r\ %##%h%w\ %<%#SLFileName#\ %{stl_fn}\ %##\ \ \ 
"set statusline=\ \ %#SLFileName#[\ %{winnr()}\ ]%##\ (\ %n\ )\ %m\ %r\ %##%h%w\ %<%#SLFileName#\ %t\ %##\ %F\ \ \ 
"set statusline=\ \ %#SLFileName#[\ %{winnr()}\ ]%##\ (\ %n\ )\ %m\ %r\ %##%h%w\ %<%#SLFileName#\ %F\ %##\ %r\ %m\ \ \ 
              "\%=%#SLFileName#\ %{toupper(&fenc)},\ %{toupper(&ff[0])},\ %y,\ %1{stridx(&isk,'.')<0?'\ ':'.'}\ %1{stridx(&isk,'_')<0?'\ ':'_'}\ %1{c_jk_local!=0?'@':'\ '}\ %1{&whichwrap=~'h'?'>':'='}\ %##%4p%%\ [%4l\ %3v]\ 
              "\%#SLFileName#\ %L\ %##\ \ %{repeat('\ ',winwidth(0)-b:buf_name_len)}
set statusline=\ \ %#SLFileName#[\ %{winnr()}\ ]%##\ (\ %n\ )\ %m\%r%##%h%w\ %#SLFileName#\ %t\ %<%##\ %F\ \ \ 
              \%=%#SLFileName#\ %{toupper(&fenc)},\ %{toupper(&ff[0])},\ %y\ %1{stridx(&isk,'.')<0?'\ ':'.'}\ %1{stridx(&isk,'_')<0?'\ ':'_'}\ %1{c_jk_local!=0?'@':'\ '}\ %1{&whichwrap=~'h'?'>':'='}\ %1{g:MigemoIsSlash?'\\':'/'}\ %##%4p%%\ [%4L]\ 
              \%#SLFileName#\ %3v\ %##\ \ %{repeat('\ ',winwidth(0)-b:buf_name_len)}
let set_stl = 'set statusline='
	\ . '\ \ %#SLFileName#[\ %{winnr()}\ ]%##\ (\ %n\ )\ %m\%r%##%h%w\ %#SLFileName#\ %t\ %<%##\ %F\ \ \ '
        \ . '%=%#SLFileName#\ %{toupper(&fenc)},\ %{toupper(&ff[0])},\ %y\ %1{stridx(&isk,''.'')<0?''\ '':''.''}\ %1{stridx(&isk,''_'')<0?''\ '':''_''}\ %1{c_jk_local!=0?''@'':''\ ''}\ %1{&whichwrap=~''h''?''>'':''=''}\ %1{g:MigemoIsSlash?''\\'':''/''}\ '
	\ . '%{&iminsert?''j'':''e''}\ %##%4p%%\ [%4L]\ '
        \ . '%#SLFileName#\ %3v\ %##\ \ %{repeat(''\ '',winwidth(0)-b:buf_name_len)}'
exe set_stl

augroup MyVimrc_StatusLine
  au!
  "au BufNewFile,BufRead,BufFilePost,BufEnter,BufWinEnter,BufNew,FilterReadPost,FileReadPost * let b:buf_name_len = max([len(fnamemodify(bufname('.'),':p'))+60, 120])
  " M$ Windowsの不具合対策 他のドライブのファイルを読み込んだときにバグがある?
  au BufAdd,BufNewFile,BufRead,BufFilePost,BufEnter,BufWinEnter,BufNew,FilterReadPost,FileReadPost * let b:buf_name_len = max([len(fnamemodify(bufname('.'),':p'))+90, 150])
  "au BufAdd,BufNewFile,BufRead,BufFilePost,BufNew,FilterReadPost,FileReadPost * let b:buf_name_len = max([len(fnamemodify(bufname('.'),':p'))+90, 150])
augroup end
"function! Buf_name_len_set()
"  try
"    return max([len(fnamemodify(bufname('.'),':p'))+60, 120])
"  endtry
"endfunction
"au BufNewFile,BufRead * let b:buf_name_len = max([len(fnamemodify('.',':p') . bufname('.'))+30, 120])
"echo max([len(fnamemodify(".", ":p") . bufname(".")) + 40, 120]
" Statusline }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}



"TODO
"バッファ切り替えイベントでも、カーソルラインをセットする。
"ftpluginのCとAWKを統合する。
"無名バッファで、カレントディレクトリを設定できるようにする。
"Split + 戻る, Split + 進む


"modifide filese
" vimrc
" gvimrc
" vitamin
" syntax xms
" syntax C
" syntax vim


" 基本
" 検索
" 置換
" 補完
" 画面、表示 （ウィンドウ、バッファ、タブ）
" 便利ツール
" 移動、切り替え （ウィンドウ、バッファ、タブ）
" タブジャンプ
"
" 移動
" 見た目
" 編集



inoremap <expr> <CR>  pumvisible() ? '<C-y>' : '<C-]><C-G>u<CR>'
inoremap <expr> <Esc> pumvisible() ? '<C-e>' : '<Esc>'

"source D:/bin/vim74-kaoriya-win32/vim74/plugin/snipMate.vim
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


inoremap <silent> <C-j> <Esc>



inoremap <C-H> <C-G>u<C-H>
"inoremap <CR> <C-]><C-G>u<CR>
inoremap <C-/> <C-O>u



"""""""" Completion """"""""""""""

set complete=.,w,b,u,i,t
set completeopt=menuone,preview


function! TrigCompl(key)
  "set timeoutlen=1
  "set ttimeoutlen=1000
  try
    iunmap jj
  catch
  inoremap <expr> ff pumvisible() ? '<C-Y><Esc>:w<CR>' : 'ff'
  finally
  endtry
  call feedkeys("\<C-n>\<C-p>")
  "call feedkeys("\<C-x>\<C-o>")
  return a:key
endfunc

function! SetJJFF()
  au CompleteDone * inoremap <silent> <expr> jj pumvisible() ? '<C-N><C-N>' : '<Esc>:w<CR>'
  au CompleteDone * try | iunmap ff | catch | finally
endfunction

function! SetCpmplKey(str)
  for k in split(a:str, '\zs')
   "exec "inoremap <expr> " . k . " pumvisible() ? '\<C-e>" . k . "' : search('\\k\\k\\%#', 'bcn') ? TrigCompl('" . k . "')" . " : '" . k . "'"
   "exec "inoremap <expr> " . k . " pumvisible() ? '\<C-e>" . k . "' : search('\\k\\{1\\}\\%#', 'bcn') ? TrigCompl('" . k . "')" . " : '" . k . "'"
    exec "inoremap <expr> " . k . " pumvisible() ? '" . k . "' : search('\\k\\{1\\}\\%#', 'bcn') ? TrigCompl('" . k . "')" . " : '" . k . "'"
   "exec "inoremap <expr> " . k . " pumvisible() ? '\<C-e>" . k . "\<C-n>\<C-p>' : search('\\k\\%#', 'bcn') ? TrigCompl('" . k . "')" . " : '" . k . "'"
  endfor
endfunction
inoremap <expr> <BS> pumvisible() ? (search('\k\k\k\k\%#', 'bcn') ? '<BS>' : "\<BS>") : (search('\k\k\k\%#', 'bcn') ? TrigCompl("\<BS>") : "\<BS>")
"inoremap <expr> <BS> pumvisible() ? (search('\k\k\k\k\%#', 'bcn') ? '<BS>' : "\<C-e>\<BS>") : (search('\k\k\k\%#', 'bcn') ? TrigCompl("\<BS>") : "\<BS>")
"inoremap <buffer><expr> <BS> pumvisible() ? (search('\k\k\k\k\%#', 'bcn') ? '<BS>' : "\<C-e>\<BS>") : (search('\k\k\k\k\%#', 'bcn') ? TrigCompl("\<BS>") : "\<BS>")

call SetCpmplKey('_0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ')


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
  "au CompleteDone * iunmap ff

  au CompleteDone * try | iunmap ff | catch | finally
  au CompleteDone * inoremap <silent> <expr> jj pumvisible() ? '<C-N><C-N>' : '<Esc>:w<CR>'

  au InsertCharPre * try | iunmap ff | catch | finally
  " au InsertCharPre * inoremap <silent> <expr> jj pumvisible() ? '<C-N><C-N>' : '<Esc>:w<CR>'

  au TextChangedI * exe pumvisible() ? "" : "inoremap <silent> <expr> jj pumvisible() ? '<C-N><C-N>' : '<Esc>:w<CR>'"
  au TextChangedI * exe pumvisible() ? "" : "try | iunmap ff | catch | finally"

  au InsertLeave * try | iunmap ff | catch | finally
  au InsertLeave * inoremap <silent> <expr> jj pumvisible() ? '<C-N><C-N>' : '<Esc>:w<CR>'

  au InsertCharPre * exe pumvisible() || v:char != "j" ? "" : "inoremap <silent> <expr> jj pumvisible() ? '<C-N><C-N>' : '<Esc>:w<CR>'"
  au InsertCharPre * exe pumvisible() ? "" : "try | iunmap ff | catch | finally"

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
  inoremap <expr> ff pumvisible() ? '<C-Y><Esc>:w<CR>' : 'ff'
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
  inoremap <expr> ff pumvisible() ? '<C-Y><Esc>:w<CR>' : 'ff'
  endtry
  call feedkeys("\<C-p>")
  return ''
endfunction


inoremap <silent> <expr> jj pumvisible() ? '<C-N><C-N>' : '<Esc>:w<CR>'
inoremap <expr> j pumvisible() ? Cmpl_j() : TrigCompl('j')
inoremap <expr> k pumvisible() ? Cmpl_k() : TrigCompl('k')
"inoremap <expr> j pumvisible() ? '<C-N>' : TrigCompl('j')
"inoremap <expr> k pumvisible() ? '<C-P>' : TrigCompl('k')
imap <expr> <C-J> pumvisible() ? 'j' : '<C-J>'
imap <expr> <C-K> pumvisible() ? 'k' : '<C-K>'


"inoremap <buffer><expr> j pumvisible() ? '<C-N>' : TrigCompl('j')
"inoremap <buffer><expr> k pumvisible() ? '<C-P>' : TrigCompl('k')
"inoremap <buffer><expr> <C-J> pumvisible() ? 'j' : '<C-J>'
"inoremap <buffer><expr> <C-K> pumvisible() ? 'k' : '<C-K>'
"inoremap <buffer><expr> <M-J> pumvisible() ? 'j' : '<M-J>'
"inoremap <buffer><expr> <M-K> pumvisible() ? 'k' : '<M-K>'

"inoremap <Tab> <C-]><Tab>

"""""""" Completion End """"""""""""""



function! Eatchar(pat)
  let c = nr2char(getchar(0))
  return (c =~ a:pat) ? '' : c
endfunc
"例 iabbr <silent> if if ()<Left><C-R>=Eatchar('\s')<CR>



" Cscope
" nnoremap <C-j><C-a> :cscope add cscope.out<CR>
" nnoremap <C-j><C-j> :cscope find 
" nnoremap <C-j>c     :cscope find c 
" nnoremap <C-j>d     :cscope find d 
" nnoremap <C-j>e     :cscope find e 
" nnoremap <C-j>f     :cscope find f 
" nnoremap <C-j>g     :cscope find g 
" nnoremap <C-j>i     :cscope find i 
" nnoremap <C-j>s     :cscope find s 
" nnoremap <C-j>t     :cscope find t 
" nnoremap <C-j>C     :cscope find c <C-r><C-w><CR>
" nnoremap <C-j>D     :cscope find d <C-r><C-w><CR>
" nnoremap <C-j>E     :cscope find e <C-r><C-w><CR>
" nnoremap <C-j>F     :cscope find f <C-r><C-w><CR>
" nnoremap <C-j>G     :cscope find g <C-r><C-w><CR>
" nnoremap <C-j>I     :cscope find i <C-r><C-w><CR>
" nnoremap <C-j>S     :cscope find s <C-r><C-w><CR>
" nnoremap <C-j>T     :cscope find t <C-r><C-w><CR>



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

  if &filetype == "c"
    " 下記の文字は連続して現れることがまれなので、二回続けて入力したら改行する
    inoremap <buffer><expr> } smartchr#one_of('}', '}<cr>')
    inoremap <buffer><expr> ; smartchr#one_of(';', ';<cr>')
  endif
  inoremap <expr> + smartchr#one_of(' = ', ' == ', '=')
endif



">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
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
"<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<



">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
function! s:tab2space()
  setlocal expandtab

  try
    normal! gg/	

    while 1
      normal! r	n
    endwhile
  catch
  finally
    setlocal expandtab&
  endtry
endfunction
command! Tab2space :call s:tab2space()
"<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<



">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
augroup MyVimrc_Em
  au!
  au BufNewFile,BufRead,BufFilePost,BufWinEnter,BufNew,FilterReadPost,FileReadPost *.{c,h} so $vim/em.vim
augroup end
function! D2X(dec)
  "return printf("0x%X", a:dec)
  let hex = printf("0x%X", a:dec)
  return hex . "U" . (len(hex) > 6 ? "UL" : "U")
endfunction
"<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<



nnoremap <leader>l :<C-u>echo len("<C-r><C-w>")<CR>
nnoremap <leader>E :<C-u><C-R>"


"""""""""""""""" Window Ratio
" 正方形 w:h = 178:78
" 横長なほど、大きい値が返る。
function! s:WindowRatio()
  let h = winheight(0) + 0.0
  let w = winwidth(0) + 0.0
  return (w / h - 178.0 / 78.0)
endfunction

nnoremap <expr> <BS><BS> <SID>WindowRatio() >= 0 ? "\<C-w>v" : "\<C-w>s"
nnoremap <expr> <S-BS> <SID>WindowRatio() >= 0 ? ":vnew\<CR>" : ":new\<CR>"
nnoremap <expr> <C-S-BS> <SID>WindowRatio() < 0 ? ":vnew\<CR>" : ":new\<CR>"
nnoremap <expr> <BS><CR> <SID>WindowRatio() >= 0 ? "\<C-w>v\<C-]>" : "\<C-w>\<C-]>"
nnoremap <expr> <C-BS><C-CR> <SID>WindowRatio() < 0 ? "\<C-w>v\<C-]>" : "\<C-w>\<C-]>"
nnoremap <expr> <C-BS><C-BS> <SID>WindowRatio() < 0 ? "\<C-w>v" : "\<C-w>s"
nnoremap <C-w><C-w> <C-w>v

nnoremap <Ins> [c^
nnoremap <del> ]c^


nnoremap <C-Tab> <C-w>p

nnoremap <leader>w <Esc>:w<CR>

"set foldmethod=syntax



">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

set autochdir

let s:root_file = "prj.root"

set grepprg=/usr/bin/grep\ -an
set grepprg=/home/PK65278/ag\ --line-numbers
set grepprg=/home/PK65278/bin/ag
set grepprg=$HOME/bin/ag
function! CS(str)
	"? echo a:str

	let str = a:str
	let pwd = getcwd()
	for i in range(6)
		"pwd
		if filereadable(s:root_file)
			augroup MyVimrc_Grep
				au!
				"au! WinEnter qf
				exe "au WinEnter * if (&buftype == 'quickfix') | cd " . getcwd() . " | endif"
			augroup end
			"exe 'vim !' . str . '!j **/src_*/**/*.c' . " **/src_*/**/*.h" . " **/inc*/**/*.h"
			try
				"exe "silent grep! '" . str . "' **/src_*/**/*.c" . " **/src_*/**/*.h" . " **/inc*/**/*.h"
				exe "silent grep! '" . str . "' **/src_*/**/*.c" . " **/src_*/**/*.h" . " **/src_*/**/*.xms" . " **/src_*/**/*.inc" . " **/inc*/**/*.h"
				"exe "grep! '" . str . "' **/src_*/**/*.c" . " **/src_*/**/*.h" . " **/inc*/**/*.h" . " data/**/*.c" . " data/**/*.xms"
				"set grepprg=ggg
				"exe "grep! -a '" . str . "' " "**/src_*/**/*.c"  "**/src_*/**/*.h"
				"exe "!$HOME/bin/fff " . str
				call feedkeys("\<CR>:\<Esc>\<C-o>", "tn")
			finally
			endtry
			break
		endif
		cd ..
	endfor
	exe "cd " . pwd
endfunction

com! CS call CS("\<C-r>\<C-w>")

nnoremap          <leader>g     :call CS("\\<<C-r><C-w>\\>")<CR>
nnoremap <silent> <C-g>         :call CS("\\<<C-r><C-w>\\>")<CR>
nnoremap          <leader>G     :call CS("<C-r><C-w>")<CR>
nnoremap          <leader><C-g> :call CS('')<Left><Left>
nnoremap <silent> <C-g>         :call CS("\\b<C-r><C-w>\\b")<CR>
nnoremap <silent> <leader>g     :call CS("\\b<C-r><C-w>\\b")<CR>
nnoremap          <leader>g     :call CS('')<Left><Left>

let c_jk_local = 0
"バッファ化すべき
nnoremap <expr><silent> <C-k> (c_jk_local ? ":lprev" : ":cprev") . "\<CR>"
nnoremap <expr><silent> <C-j> (c_jk_local ? ":lnext" : ":cnext") . "\<CR>"
"nnoremap <silent> <leader> :let c_jk_local = !c_jk_local<CR>

"<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


"nnoremap s f_l
"nnoremap S F_h
"nnoremap ci s
"nnoremap cI S

nnoremap S           :<C-u>g#.#s    /<C-R>//

set showtabline=0
nnoremap <C-h> :<C-u>tabs<CR>

" 現在のバッファを、別のタブでも開き直す。
" デフォルトの<C-w>tとの違いは、元のウィンドウも残るということ。
function! TabReopen()
  let b0 = bufnr("%")
  tabnew
  let b1 = bufnr("%")
  execute 'buf  ' b0
  execute 'bdel ' b1
  echo b0 b1
endfunction
nnoremap <C-w>T :<C-u>call TabReopen()<CR>


"cbuf

nnoremap <silent><expr> <leader>r &readonly ? ':<C-u>set noreadonly<CR>' : ':<C-u>set readonly<CR>'
nnoremap <silent><expr> <leader>R &modifiable ? ':<C-u>set nomodifiable<CR>' : ':<C-u>set modifiable<CR>'


set nowildmenu
set wildmode=longest,full
inoremap <C-f> <C-p>

"source $VIMRUNTIME/macros/matchit.vim


" clever-f Configure
let g:clever_f_smart_case=1			"
let g:clever_f_use_migemo=0			"
"let g:clever_f_fix_key_direction=1		"
let g:clever_f_chars_match_any_signs = ';'	" 任意の記号にマッチする文字を設定する
if 0
  let g:clever_f_mark_cursor_color = 'gui=none guifg=black guibg=yellow'
  let g:clever_f_mark_char_color   = 'gui=none guifg=black guibg=red'
  let g:clever_f_mark_cursor = 1
  let g:clever_f_mark_char = 1
endif

cnoremap <C-A>	<Home>
cnoremap <C-D>	<Del>
inoremap <C-E>	<End>
"if exists('loaded_mru')
 "nnoremap <silent> <leader>o :MRU<CR>
  nnoremap          <leader>o :MRU<CR>/
 "nnoremap <silent> <leader><CR> :MRU<CR>
"endif

"set whichwrap+=h,l
nnoremap <silent><expr> <leader>h &whichwrap !~ 'h' ? ':<C-u>set whichwrap+=h,l<CR>' : ':<C-u>set whichwrap-=h,l<CR>'

so D:/bin/vim74-kaoriya-win32/test.vim
so D:/bin/vim74-kaoriya-win32/blockdiff.vim


function! PushPos()
    let s:save_cursor = getcurpos()
    let s:save_top = getpos('w0')
endfunction
com! PushPos :call PushPos()

function! PopPos()
    let save_scrolloff = &scrolloff
    let &scrolloff = 0
    exe "normal! " . s:save_top[1] . "zt"
    let &scrolloff = save_scrolloff

    call setpos('.', s:save_cursor)
    let g:sss = s:save_top
endfunction
com! PopPos :call PopPos()


nnoremap gG G

nnoremap <expr> cr (search("\\k\\%#", 'bcn') ? 'b' : '') . 'cw'
nnoremap <expr> dr (search("\\k\\%#", 'bcn') ? 'b' : '') . 'dw'
nnoremap <expr> yr (search("\\k\\%#", 'bcn') ? 'b' : '') . 'yw'



" US Keyboard
nnoremap ; :
inoremap ' "
inoremap " '


cnoremap <C-y> <C-R><C-O>*

set packpath+=$VIMRUNTIME


com! TVIMRC  :tabnew $vim/vimrc
com! TGVIMRC :tabnew $vim/vimrc

com! VVIMRC  :vsp $vim/vimrc
com! VGVIMRC :vsp $vim/vimrc

com! VIMRC  :sp $vim/vimrc
com! Vimrc  :sp $vim/vimrc
com! GVIMRC :sp $vim/gvimrc
com! GVimrc :sp $vim/gvimrc
com! Gvimrc :sp $vim/gvimrc


"=====================================================================================================================================
if 0
  " diffのコマンド
  set diffexpr=MyDiff()
  function MyDiff()
    let opt = ""
    if &diffopt =~ "iwhite"
      let opt = opt . "-b "
    endif
    silent execute "!git-diff-normal-format " . opt . v:fname_in . " " . v:fname_new . " > " . v:fname_out
    redraw!
  endfunction
endif
"=====================================================================================================================================


nnoremap _    <C-w>s
nnoremap <Bar> <C-w>v

let $PATH.=';C:\cygwin\bin'


"// Windowsでの設定例です。Mac他の場合は外部コマンド部分を読み替えてください。
au FileType plantuml command! OpenUml :!/cygdrive/c/Program\ Files/Google/Chrome/Application/chrome.exe %
