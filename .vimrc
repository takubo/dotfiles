scriptencoding utf-8
" vim:set ts=8 sts=2 sw=2 tw=0: (この行に関しては:help modelineを参照)
"
" An example for a Japanese version vimrc file.
" 日本語版のデフォルト設定ファイル(vimrc) - Vim 7.4
"
" Last Change: 01-Nov-2018.
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


let g:skip_defaults_vim = 1
let g:no_vimrc_example = 1


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
set nrformats=bin,hex
set shiftround
set fileformats=unix,dos,mac
" for 1st empty buffer
set fileformat=unix
"set tag+=;
set tags+=tags;
"grepコマンドの出力を取り込んで、gfするため。
set isfname-=:

"set viminfo+='100,c
set sessionoptions+=unix,slash
" set_end set end

set showtabline=0

filetype on

syntax enable

colorscheme Vitamin
" TODO hi CursorLine ctermbg=NONE guibg=NONE


set timeoutlen=1100


augroup MyVimrc
  au!

  au QuickfixCmdPost make,grep,grepadd,vimgrep,cbuffer,cfile botright copen
  au QuickfixCmdPost lmake,lgrep,lgrepadd,lvimgrep,lcbuffer,lcfile botright lopen
 "au BufNewFile,BufRead,FileType qf set modifiable

  " grepする際に'|cw'を付けなくても、Quickfixに結果を表示する
  au QuickfixCmdPost vimgrep botright cwindow
  "au QuickfixCmdPost make,grep,grepadd,vimgrep 999wincmd w

  au InsertEnter * set timeoutlen=300
  au InsertLeave * set timeoutlen=1100

  au WinEnter * set cursorline
  au WinEnter * set cursorcolumn
  au WinLeave * set nocursorline
  au WinLeave * set nocursorcolumn

  au BufEnter * set cursorline
  au BufEnter * set cursorcolumn
  au BufLeave * set nocursorline
  au BufLeave * set nocursorcolumn

  "au FileType c,cpp,awk set mps+=?::,=:;

 "au BufNewFile,BufRead,FileType *.awk so $vim/avd/avd.vim
  au BufNewFile,BufRead,FileType * set textwidth=0

  "au BufNewFile,BufRead *.c inoremap @ /*  */<Left><Left><Left>
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

let $PATH = $PATH . 'C:\Oracle\Ora11R2\bin;%SystemRoot%\system32;%SystemRoot%;%SystemRoot%\System32\Wbem;%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\;'
		\ . 'C:\Program Files\Common Files\Compuware;C:\Program Files\WinMerge;C:\Program Files\Subversion\bin;C:\Program Files\TortoiseSVN\bin;'
		\ . 'D:\takubo\bin\;C:\Perl\bin'


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
nnoremap <silent> <Esc><Esc> <Esc>:<C-u>noh<CR>:call clever_f#reset()<CR>:echon <Esc>
"nnoremap <silent> <Esc><Esc> <Esc>:<C-u>noh<CR>:SearchReset<CR>:SearchBuffersReset<CR> TODO multiplesearch
nnoremap cp cw<C-r>0
nnoremap da 0d$
nnoremap <silent> ZZ :<C-u><CR>
nnoremap <silent> ZQ :<C-u><CR>
"nnoremap <C-o> O<Esc>
nnoremap <A-o> o<Esc>

nnoremap <silent><expr> <leader>n !&number <Bar><Bar> &relativenumber ?  ':<C-u>set   number norelativenumber<CR>' : ':<C-u>set relativenumber<CR>'
nnoremap <silent><expr> <leader>N  &number <Bar><Bar> &relativenumber ?  ':<C-u>set nonumber norelativenumber<CR>' : ':<C-u>set number<CR>'

" コメント行後の新規行の自動コメント化のON/OFF
nnoremap <silent><expr> <leader># &formatoptions =~# 'o' ? ':<C-u>set formatoptions-=o<CR>:set formatoptions-=r<CR>' : ':<C-u>set formatoptions+=o<CR>:set formatoptions+=r<CR>'

nnoremap <silent><expr> <leader>. stridx(&isk, '.') < 0 ? ':<C-u>setl isk+=.<CR>' : ':<C-u>setl isk-=.<CR>'
nnoremap <silent><expr> <leader>, stridx(&isk, '_') < 0 ? ':<C-u>setl isk+=_<CR>' : ':<C-u>setl isk-=_<CR>'
nnoremap <silent><expr> <leader>u stridx(&isk, '_') < 0 ? ':<C-u>setl isk+=_<CR>' : ':<C-u>setl isk-=_<CR>'

" ^に、|の機能を重畳
nnoremap <silent> ^ <Esc>:exe v:prevcount ? ('normal! ' . v:prevcount . '<Bar>') : 'normal! ^'<CR>

nnoremap <silent><expr> yd stridx(&isk, '.') < 0 ? ':setl isk+=.<CR>' : ':set isk-=.<CR>'
nnoremap <silent><expr> yu stridx(&isk, '_') < 0 ? ':setl isk+=_<CR>' : ':set isk-=_<CR>'

"nnoremap <silent> <leader>d :<C-u>pwd<CR>
"nnoremap <silent> <C-o> :<C-u>pwd<CR>
nnoremap <silent> <leader>p :<C-u>disp<CR>
nnoremap <silent> <Leader>m :<C-u>marks<CR>
nnoremap <silent> <Leader>" :<C-u>disp<CR>
nnoremap <silent> <Leader>k :<C-u>make<CR>
"nnoremap <silent> <leader>t :<C-u>ToggleWord<CR>
nnoremap <leader>: :<C-u>setl<Space>
nnoremap <leader>; :<C-u>set<Space>
nnoremap <leader>: q:

nnoremap g; :<C-u>set<Space>
nnoremap <leader>; :<C-u>setl<Space>
nnoremap <C-z> nop

nnoremap <silent><expr> <Leader>c &cursorline ? ':<C-u>set nocursorline<CR>' : ':<C-u>set cursorline<CR>'
nnoremap <silent><expr> <leader>C &cursorcolumn ? ':<C-u>setlocal nocursorcolumn<CR>' : ':<C-u>setlocal cursorcolumn<CR>'

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


" 検索時に/, ?を楽に入力する
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'

cnoremap (( \(
cnoremap )) \)
cnoremap << \<
cnoremap >> \>
cnoremap <Bar><Bar> \<Bar>

cnoremap <expr> <C-t>	  getcmdtype() == ':' ? '../' :
			\ (getcmdtype() == '/' <Bar><Bar> getcmdtype() == '?') ? '\\|' :
			\ '<C-t>'


" Emacs {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{
" コマンドラインでのキーバインドを Emacs スタイルにする
" 行頭へ移動
cnoremap <C-a>		<Home>
" 一文字戻る
cnoremap <C-b>		<Left>
" カーソルの下の文字を削除
cnoremap <C-d>		<Del>
" 行末へ移動
cnoremap <C-e>		<End>
" 一文字進む
cnoremap <C-f>		<Right>
" コマンドライン履歴を一つ進む
cnoremap <C-n>		<Down>
" コマンドライン履歴を一つ戻る
cnoremap <C-p>		<Up>
" Emacs Yank
cnoremap <C-y> <C-R><C-O>*
" 次の単語へ移動
cnoremap <A-f>		<S-Right>
"cnoremap <Esc>f		<S-Right>
" 前の単語へ移動
cnoremap <A-b>		<S-Left>
"cnoremap <Esc><b>	<S-Left>
" Emacs }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}


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

nnoremap <expr> *  (match(expand("<cword>"), '_') == 0) ? ('/\<_\?' . substitute(expand("<cword>"), '^_', '', '') . '\><CR>') : ('/\<_\?<C-r><C-w>\><CR>')
nnoremap <expr> #  (match(expand("<cword>"), '_') == 0) ? ('/_\?' . substitute(expand("<cword>"), '^_', '', '') . '<CR>') : ('/_\?<C-r><C-w><CR>')

nnoremap       g*  *
nnoremap       g#  g*

nnoremap <expr> !  '/<C-p>\\|\<' . ((match(expand("<cword>"), '_') == 0) ? ('_\?' . substitute(expand("<cword>"), '^_', '', '')) : ('_\?<C-r><C-w>')) . '\><CR>'
nnoremap <expr> &  '/<C-p>\\|' . ((match(expand("<cword>"), '_') == 0) ? ('_\?' . substitute(expand("<cword>"), '^_', '', '')) : ('_\?<C-r><C-w>')) . '<CR>'

nnoremap       g!  /<C-p>\\|\<<C-r><C-w>\><CR>
nnoremap       g&  /<C-p>\\|<C-r><C-w><CR>

nnoremap        ?  /<C-p>\<Bar>
nnoremap        ?  /\M
nnoremap    <Bar>  /<C-p>\<Bar>\<\><Left><Left>

"cnoremap <C-g> \<\><Left><Left>

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

nnoremap <C-s>           :<C-u>g$.$s    //<Left>
nnoremap <Leader><C-s>   :<C-u>g$.$s    %%<Left>
nnoremap <Leader>s       :<C-u>g$.$s    /<C-R>///g<Left><Left>
nnoremap S               :<C-u>g$.$s    /<C-R>//<C-R><C-W>/g

nnoremap g<C-s>              :<C-u>s    //<Left>
nnoremap g<Leader><C-s>      :<C-u>s    %%<Left>
nnoremap g<Leader>s          :<C-u>s    /<C-R>///g<Left><Left>
nnoremap gS                  :<C-u>s    /<C-R>//<C-R><C-W>/g

vnoremap <C-s>                    :s    //<Left>
vnoremap <Leader><C-s>            :s    %%<Left>
vnoremap <leader>s                :s    /<C-R>///g<Left><Left>
vnoremap S                        :s    /<C-R>//<C-R><C-W>/g

cnoremap <expr> <C-g> match(getcmdline(), '\(g.\..s\\|s\)    /') == 0 ? '<End>/g' :
                    \ match(getcmdline(), '\(g.\..s\\|s\)    %') == 0 ? '<End>/g' : ''

" Substitute }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}


" Grep {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

"nnoremap <C-g> :<C-u>vim "\<<C-R><C-W>\>" *.c *.h<CR>
nnoremap <C-g> :<C-u>vim "" <Left><Left>
nnoremap <leader>g :<C-u>vim "\<<C-R><C-W>\>" 
"nnoremap <leader>G :<C-u>vim "<C-R><C-W>" *.c *.h<CR>
nnoremap <leader>G :<C-u>vim "<C-R><C-W>" 

let c_jk_local = 1
"例外をキャッチしないと、最初と最後の要素の次に移動しようとして例外で落ちる。
nnoremap <expr><silent> <C-k> ":\<C-u>try \<Bar> " . (c_jk_local ? ":lprev" : "cprev") . "\<Bar> catch \<Bar> endtry" . "\<CR>"
nnoremap <expr><silent> <C-j> ":\<C-u>try \<Bar> " . (c_jk_local ? ":lnext" : "cnext") . "\<Bar> catch \<Bar> endtry" . "\<CR>"
nnoremap <silent> <Leader>0 :<C-u>let c_jk_local = !c_jk_local<CR>


">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


let s:root_file = '.git'

set grepprg=$HOME/bin/ag\ --line-numbers
set grepprg=/usr/bin/grep\ -an


augroup MyVimrc_Grep
  au!
  exe "au WinEnter * if (&buftype == 'quickfix') | cd " . getcwd() . " | endif"
augroup end

function! CS(str)
  let save_autochdir = &autochdir
  set autochdir

  let pwd = getcwd()

  for i in range(7)
    if glob(s:root_file) != ''  " root_fileファイルの存在確認
      try
        if exists("*CS_Local")
          call CS_Local(a:str)
        else
          exe "silent grep! '" . a:str . "' **/*.c" . " **/*.h" . " **/*.s"
        endif
        call feedkeys("\<CR>:\<Esc>\<C-o>", "tn")  " 見つかった最初へ移動させない。
      finally
      endtry
      break
    endif
    cd ..
  endfor

  exe 'cd ' . pwd
  exe 'set ' . save_autochdir
endfunction

com! CS call CS("\<C-r>\<C-w>")

nnoremap          <leader>g     :<C-u>call CS("\\<<C-r><C-w>\\>")<CR>
nnoremap <silent> <C-g>         :<C-u>call CS("\\<<C-r><C-w>\\>")<CR>
nnoremap          <leader>G     :<C-u>call CS("<C-r><C-w>")<CR>
nnoremap          <leader><C-g> :<C-u>call CS('')<Left><Left>
nnoremap <silent> <C-g>         :<C-u>call CS("\\b<C-r><C-w>\\b")<CR>
nnoremap <silent> <leader>g     :<C-u>call CS("\\b<C-r><C-w>\\b")<CR>
nnoremap          <leader>g     :<C-u>call CS('')<Left><Left>

"<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


" Grep }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}


" Tag, Jump, and Unified CR {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

" Browse
noremap H <C-o>
noremap L <C-i>

" 補償
nnoremap zh H
nnoremap zl L
"nnoremap zm M
nnoremap <expr> zh &wrap ? 'H' : 'zh'
nnoremap <expr> zl &wrap ? 'L' : 'zl'

" ---------------
" Unified CR
"   数字付きなら、行へジャンプ
"   qfなら当該行へジャンプ
"   helpなら当該行へジャンプ
"   それ以外なら、タグジャンプ
" ---------------
function! Unified_CR(mode)
  if v:prevcount
    "この方法(feedkeys)なら、移動行が履歴に残る。"exe v:prevcount"だと、残らない。
    "最後のEscは、コマンドラインに残った数字を消すため。
    call feedkeys(':' . v:prevcount . "\<CR>:\<Esc>", 't')
    return
  elseif &ft == 'qf'
    exe "normal! \<CR>"
    return
  elseif &ft == 'help'
    exe "normal! \<C-]>"
    return
  else
    call JumpToDefine(a:mode)
    return
  endif
endfunction

" TODO
"   ラベルならf:b
"   変数なら、スクロールしない
"   引数のタグ
"   asmのタグ
function! JumpToDefine(mode)
  let w0 = expand("<cword>")
  let w = w0

 "for i in range(2)
  for i in range(2 + 2)
    try
      if a:mode =~? 's'
	exe (a:mode =~? 'p' ? 'p' : (a:mode =~? 'w' ? 's' : '')) . "tselect " . w
      else
	exe (a:mode =~? 'p' ? 'p' : (a:mode =~? 'w' ? 's' : '')) . "tjump " . w
      endif
      " 表示範囲を最適化
      exe "normal! z\<CR>" . (winheight(0)/4) . "\<C-y>"
      " カーソル位置を調整 (C専用)
      call PostTagJumpCursor_C()
      return
    catch /:E426:/
      if w0 =~ '^_'
	" 元の検索語は"_"始まり
	let w = substitute(w0, '^_', '', '')
      else
	" 元の検索語は"_"始まりでない
	let w = '_' . w0
      endif
      let exception = v:exception
    catch /:E433:/
      echohl ErrorMsg | echo matchstr(v:exception, 'E\d\+:.*') | echohl None
      return
    endtry
  endfor
  echohl ErrorMsg | echo matchstr(exception, 'E\d\+:.*') | echohl None
endfunction

" カーソル位置を調整 (C専用)
function! PostTagJumpCursor_C()
  if search('\%##define\s\+\k\+(', 'bcn')
  "関数形式マクロ
    normal! ww
  elseif search('\%##define\s\+\k\+\s\+', 'bcn')
  "定数マクロ
    normal! ww
  elseif search('\%#.\+;', 'bcn')
  "変数
    normal! f;b
  else
    "関数
    normal! $F(b
  endif
endfunction

" 対象
"   カーソル下  ->  Normal mode デフォルト
"   Visual      ->  Visual mode デフォルト
"   (入力)      ->  対応なし

" タグ動作
"   直接ジャンプ -> なし
"   よきに計らう(タグの数次第で) -> デフォルトとする
"   強制選択

" ウィンドウ
"   そのまま
"   別ウィンドウ
"   プレビュー

" mode
"   s:select
"   p:preview
"   w:別ウィンドウ
"
" 最初の<Esc>がないと、prevcountをうまく処理できない。
nnoremap <silent> <CR>         <Esc>:call Unified_CR('')<CR>
nnoremap <silent> g<CR>        <Esc>:call Unified_CR('p')<CR>
nnoremap <silent> <Leader><CR> <Esc>:call Unified_CR('w')<CR>
nnoremap <silent> <C-CR>       <Esc>:call Unified_CR('s')<CR>
nnoremap <silent> <S-CR>       <Esc>:call Unified_CR('sp')<CR>
nnoremap <silent> <C-S-CR>     <Esc>:call Unified_CR('sw')<CR>
nnoremap          <C-S-CR>     <Esc>:tags<CR>;pop

" Tag, Jump, and Unified CR }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}


" Diff {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

nnoremap <expr> du &diff ? ':diffupdate<CR>' : ':diffthis<CR>'
nnoremap        dc :<C-u>diffoff<CR>
"nnoremap        dq :<C-u>diffoff<CR>

" diff Ignorecase
nnoremap <expr> di match(&diffopt, 'icase' ) < 0 ? ':<C-u>set diffopt+=icase<CR>'  : ':<C-u>set diffopt-=icase<CR>'
" diff Y(whi)tespace
nnoremap <expr> dy match(&diffopt, 'iwhite') < 0 ? ':<C-u>set diffopt+=iwhite<CR>' : ':<C-u>set diffopt-=iwhite<CR>'

" diff Vision option
nnoremap        dv :<C-u>echo &diffopt<CR>

nnoremap <Ins> [c^
nnoremap <Del> ]c^
vnoremap <Ins> [c^
vnoremap <Del> ]c^

" diff Accept (obtain and next)
nnoremap <expr> d<Space> &diff ? do[c^ ' '<C-f>'
" diff Reject (next)
nnoremap <expr> dr &diff ? '[c^' : ''

" diff X(cross)
nnoremap <expr> dx winnr('$') != 2 ? ':echoerr "Windows not 2."<CR>' :
                \  winbufnr(1) == winbufnr(2) ? ':echoerr "Buffers are same."<CR>' :
                \  ':<C-u>windo diffthis<CR>'

" diff (all) Quit
nnoremap dq :windo diffoff<CR>

" diff (all) Quit
"nnoremap <silent> dQ :<C-u>windo call PushPos_All() <Bar> silent bufdo diffoff <Bar> call PopPos_All()<CR>
nnoremap <silent> dQ :<C-u>call PushPos_All() <Bar> silent bufdo diffoff <Bar> call PopPos_All() <Bar> silent windo diffoff<CR>

" Diff }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}


" Window {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

" ---------------
" Window Ratio
"   正方形 w:h = 178:78
"   横長なほど、大きい値が返る。
" ---------------
function! s:WindowRatio()
  let h = winheight(0) + 0.0
  let w = winwidth(0) + 0.0
  return (w / h - 178.0 / 78.0)
endfunction

nnoremap <silent> <Tab>	     <C-w>w
nnoremap <silent> <S-Tab>    <C-w>W
nnoremap <silent> <C-w><C-w> <C-w>p

nnoremap <silent> <up>	    <esc>3<C-w>+:<C-u>call	<SID>best_scrolloff()<CR>
nnoremap <silent> <down>    <esc>3<C-w>-:<C-u>call	<SID>best_scrolloff()<CR>
nnoremap <silent> <left>    <esc>4<C-w><
nnoremap <silent> <right>   <esc>4<C-w>>

nnoremap <silent> <S-up>    <esc><C-w>+:<C-u>call	<SID>best_scrolloff()<CR>
nnoremap <silent> <S-down>  <esc><C-w>-:<C-u>call	<SID>best_scrolloff()<CR>
nnoremap <silent> <S-left>  <esc><C-w><
nnoremap <silent> <S-right> <esc><C-w>>

nnoremap <silent> <C-up>    <C-w>_:<C-u>call		<SID>best_scrolloff()<CR>
nnoremap <silent> <C-down> 1<C-w>_:<C-u>call		<SID>best_scrolloff()<CR>
nnoremap <silent> <C-left> 1<C-w><bar>:<C-u>call	<SID>best_scrolloff()<CR>
nnoremap <silent> <C-right> <C-w><bar>:<C-u>call	<SID>best_scrolloff()<CR>

nnoremap <silent> <A-up>    <C-w>K:<C-u>call		<SID>best_scrolloff()<CR>
nnoremap <silent> <A-down>  <C-w>J:<C-u>call		<SID>best_scrolloff()<CR>
nnoremap <silent> <A-left>  <C-w>H:<C-u>call		<SID>best_scrolloff()<CR>
nnoremap <silent> <A-right> <C-w>L:<C-u>call		<SID>best_scrolloff()<CR>

nnoremap <silent> <C-Left>	<C-w>h
nnoremap <silent> <C-Right>	<C-w>l
nnoremap <silent> <C-Down>	<C-w>j
nnoremap <silent> <C-Up>	<C-w>k

nnoremap <silent> <C-q>: q:
nnoremap <silent> <C-q>/ q/
nnoremap <silent> <C-q>? q?

nnoremap <silent> q <C-w><C-c>
nnoremap <silent> <leader>q :<C-u>q<CR>

nnoremap <C-w><C-t> <C-w>T

"-------------------------------------- TODO -------------------------------

"Unified_BS_Key	nmap <BS> <C-w>
"Unified_BS_Key	nnoremap <c-BS> <C-w>s
"Unified_BS_Key	nnoremap <silent> <s-c-BS> <esc>:<C-u>new<cr>

"Unified_BS_Key	nnoremap <expr> <BS><BS> <SID>WindowRatio() >= 0 ? "\<C-w>v" : "\<C-w>s"
nnoremap <expr> <BS>             <SID>WindowRatio() >= 0 ? "\<C-w>v"    : "\<C-w>s"
nnoremap <expr> <Leader><Leader> <SID>WindowRatio() <  0 ? "\<C-w>v"    : "\<C-w>s"
nnoremap <expr> <S-BS>           <SID>WindowRatio() >= 0 ? ":vnew\<CR>" : ":new\<CR>"
nnoremap <expr> <C-BS>           <SID>WindowRatio() <  0 ? ":vnew\<CR>" : ":new\<CR>"
nnoremap <C-o> :<C-u>new<CR>

"Unified_BS_Key	nnoremap <expr> <BS><CR> <SID>WindowRatio() >= 0 ? "\<C-w>v\<C-]>" : "\<C-w>\<C-]>"
"Unified_BS_Key	noremap <expr> <C-BS><C-CR> <SID>WindowRatio() < 0 ? "\<C-w>v\<C-]>" : "\<C-w>\<C-]>"

nnoremap <expr> , <SID>WindowRatio() >= 0 ? "\<C-w>v" : "\<C-w>s"
nnoremap <Bar> <C-w>v
"nnoremap -     <C-w>s
nnoremap -     <C-w>p
"nnoremap `     <C-w>p
nnoremap ,     <C-w>p

" Window }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}


" Buffer {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

nnoremap K :<C-u>ls<CR>:<C-u>b 
nnoremap gK :<C-u>ls!<CR>:<C-u>b 

nnoremap <silent> <C-n> :<C-u>bnext<CR>
nnoremap <silent> <C-p> :<C-u>bprev<CR>

nnoremap <leader>z :<C-u>bdel
nnoremap <leader>Z :<C-u>bdel!

" Buffer }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}


" Tab {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

nnoremap <C-t> :<C-u>tabnew<Space>

nnoremap <C-f> gt
nnoremap <C-b> gT

nnoremap <A-f> :tabmove +1<CR>
nnoremap <A-b> :tabmove -1<CR>T

nnoremap <silent><expr> <leader>= !&showtabline ? ':<C-u>set showtabline=2<CR>' : ':<C-u>set showtabline=0<CR>'

nnoremap <C-h> :<C-u>tabs<CR>

" Tab }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}


" Transparency {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

let g:my_transparency = 229
let g:my_transparency = 235
augroup MyVimrc_GUI
  au!
  au GUIEnter * simalt ~x
  exe 'au GUIEnter * set transparency=' . g:my_transparency
augroup end

nnoremap <silent>       <s-pageup> :<C-u>exe 'se transparency=' . (&transparency + 1)<CR>
nnoremap <silent><expr> <s-pagedown> (&transparency > 1) ? (":exe 'se transparency=' . (&transparency - 1)<CR>") : ("")

nnoremap <silent><expr> <pageup>   ':<C-u>se transparency=' . min([&transparency + 3, 255]) . '<CR>'
nnoremap <silent><expr> <pagedown> ':<C-u>se transparency=' . max([&transparency - 3,   1]) . '<CR>'

nnoremap <silent>       <c-pageup>   :exe 'se transparency=' . (&transparency == g:my_transparency ? 255 : g:my_transparency) <CR>
nnoremap <silent>       <c-pagedown> :exe 'se transparency=' . (&transparency == g:my_transparency ?  50 : g:my_transparency) <CR>

" Transparency }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}


" Statusline {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

let s:stl = ''
	\ . '\ \ %#SLFileName#[\ %{winnr()}\ ]%##\ (\ %n\ )\ %m\%r%##%h%w\ %#SLFileName#\ %t\ %<%##\ %F\ \ \ \ '
	\ . '%=%#SLFileName#\ %{toupper(&fenc)},%{toupper(&ff[0])}%Y\ '
	\ . '%1{stridx(&isk,''.'')<0?''\ '':''.''}\ %1{stridx(&isk,''_'')<0?''\ '':''_''}\ '
	\ . '%1{c_jk_local!=0?''@'':''\ ''}\ %1{&whichwrap=~''h''?''>'':''=''}\ %1{g:MigemoIsSlash?''\\'':''/''}\ '
	\ . '%{&iminsert?''j'':''e''}\ %##%3p%%\ [%L]\ '
	\ . '%#SLFileName#\ %5l\ L,\ %v\ C\ %##\ \ '
	\ . '%{repeat(''\ '',winwidth(0)-(exists(''b:buf_name_len'')?b:buf_name_len:6)+(g:stl_time==''''?72:0))}'

let g:stl_time_org = '\ \ \ \ ' . '%##\ %{strftime(''%Y/%m/%d(%a)'')}\ ' . '%#SLFileName#\ %{strftime(''%X'')}\ ' . '%##\ \ %#SLFileName#\ %{g:bat_str}\ %##\ \ '

let g:stl_time = g:stl_time_org
nnoremap <silent> <Leader>- :<C-u>let g:stl_time = ( g:stl_time == '' ? g:stl_time_org : '' )<CR>:call UpdateStatusline(0)<CR>

augroup MyVimrc_StatusLine
  au!
  au BufAdd,BufNewFile,BufRead,BufFilePost,BufNew,FilterReadPost,FileReadPost,BufEnter,BufWinEnter * 
    \ let b:buf_name_len = strdisplaywidth(fnamemodify(bufname(''),':t')) + max([strdisplaywidth(fnamemodify(bufname(''),':p'))+130, 240])
augroup end

let g:alt_stl_time = 0
function! UpdateStatusline(dummy)
  if g:alt_stl_time > 0 | let g:alt_stl_time = g:alt_stl_time - 1 | endif
  if !g:alt_stl_time | exe 'set statusline=' . s:stl . g:stl_time | endif
endfunction

" 旧タイマの削除
" vimrcを再読み込みする際、旧タイマを削除しないと、どんどん貯まっていってしまう。
if exists('TimerUsl')
  call timer_stop(TimerUsl)
endif

let UpdateStatuslineInterval = 1000
let TimerUsl = timer_start(UpdateStatuslineInterval, 'UpdateStatusline', {'repeat': -1})

call UpdateStatusline(0)

" Statusline }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}


" Battery {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

try
  " bat_win.pyが存在しない環境でもエラーとさせないためtryブロック内で実行。

  py3file $HOME/bin/bat_win.py

  " Battery (Statusline)
  function! UpdateStlBatteryInfo(dummy)
    call py3eval('bat_win_main()')
    let g:bat_str = g:bat_info['ACLine'] . ' ' . g:bat_info['RemainingPercent'] . ' ' . g:bat_info['RemainingTime']
  endfunction

  " 旧タイマの削除
  if exists('TimerUbi')
    call timer_stop(TimerUbi)
  endif

  let UpdateBatteryInfoInterval = 5 * 1000
  let TimerUbi = timer_start(UpdateBatteryInfoInterval, 'UpdateStlBatteryInfo', {'repeat': -1})

  " Battery Information
  let bat_info = {}

  call py3eval('bat_win_ini()')

  call UpdateStlBatteryInfo(0)
catch
  "let bat_str=': 100% [13:05:24]'
  let bat_str='? ---% [-:--:--]'
endtry

" Battery }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}


" Completion {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

set complete=.,w,b,u,i,t
set completeopt=menuone,preview

" 全文字キーへの補完開始トリガの割り当て
function! SetCpmplKey(str)
  for k in split(a:str, '\zs')
    exec "inoremap <expr> " . k . " pumvisible() ? '" . k . "' : search('\\k\\{1\\}\\%#', 'bcn') ? TrigCompl('" . k . "')" . " : '" . k . "'"
  endfor
endfunction
call SetCpmplKey('_0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ')
inoremap <expr> <BS> pumvisible() ? (search('\k\k\k\k\%#', 'bcn') ? '<BS>' : "\<BS>") : (search('\k\k\k\%#', 'bcn') ? TrigCompl("\<BS>") : "\<BS>")

augroup MyComplete
  au!

  au CompleteDone * try | iunmap gg | catch | finally
  au CompleteDone * inoremap <silent> <expr> jj pumvisible() ? '<C-N><C-N>' : '<Esc>:<C-u>w<CR>'

  au InsertCharPre * try | iunmap gg | catch | finally

  au TextChangedI * exe pumvisible() ? "" : "inoremap <silent> <expr> jj pumvisible() ? '<C-N><C-N>' : '<Esc>:<C-u>w<CR>'"
  au TextChangedI * exe pumvisible() ? "" : "try | iunmap gg | catch | finally"

  au InsertLeave * try | iunmap gg | catch | finally
  au InsertLeave * inoremap <silent> <expr> jj pumvisible() ? '<C-N><C-N>' : '<Esc>:<C-u>w<CR>'

  au InsertCharPre * exe pumvisible() || v:char != "j" ? "" : "inoremap <silent> <expr> jj pumvisible() ? '<C-N><C-N>' : '<Esc>:<C-u>w<CR>'"
  au InsertCharPre * exe pumvisible() ? "" : "try | iunmap gg | catch | finally"

augroup end

" 補完を開始する
function! TrigCompl(key)
  try
    iunmap jj
  catch
    inoremap <expr> gg pumvisible() ? '<C-Y><Esc>:<C-u>w<CR>' : 'gg'
  finally
  endtry
  call feedkeys("\<C-n>\<C-p>")
  return a:key
endfunc

" 補完中のj,kキーの処理を行う
function! Cmpl_jk(key)
  try
    iunmap jj
  catch
  finally
  inoremap <expr> gg pumvisible() ? '<C-Y><Esc>:<C-u>w<CR>' : 'gg'
  endtry
  call feedkeys(a:key)
  return ''
endfunction

inoremap <silent> <expr> jj pumvisible() ? '<C-N><C-N>' : '<Esc>:w<CR>'
inoremap <expr> j pumvisible() ? Cmpl_jk("\<C-n>") : TrigCompl('j')
inoremap <expr> k pumvisible() ? Cmpl_jk("\<C-p>") : TrigCompl('k')
inoremap <expr> <C-j> pumvisible() ? 'j' : '<C-n>'
inoremap <expr> <C-k> pumvisible() ? 'k' : '<Esc>'

inoremap <expr> <CR>  pumvisible() ? '<C-y>' : '<C-]><C-G>u<CR>'
inoremap <expr> <Esc> pumvisible() ? '<C-e>' : '<Esc>'

" Completion }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}


" Snippets {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

"source D:/bin/vim74-kaoriya-win32/vim74/plugin/snipMate.vim
if exists('*TriggerSnippet')
  inoremap <silent> <Tab>   <C-R>=<SID>TriggerSnippet()<CR>
endif

" Snippets }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}


" Configure {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

com! ReVimrc :so $vim/vimrc

com! Vimrc   :sp $vim/vimrc
com! VIMRC   :sp $vim/vimrc
com! EVIMRC  :e $vim/vimrc
com! VVIMRC  :vsp $vim/vimrc
com! TVIMRC  :tabnew $vim/vimrc

com! Gvimrc  :sp $vim/gvimrc
com! GVIMRC  :sp $vim/gvimrc
com! EGVIMRC :e $vim/gvimrc
com! VGVIMRC :vsp $vim/gvimrc
com! TGVIMRC :tabnew $vim/gvimrc

com! EditColor :exe 'sp $VIMRUNTIME/colors/' . g:colors_name . '.vim'
com! ColorEdit :exe 'sp $VIMRUNTIME/colors/' . g:colors_name . '.vim'

let g:vimrc_buf_name = '^' . $vim . '/vimrc$'
let g:color_buf_name1 = '^' . $vimruntime . '/colors/'
let g:color_buf_name2 = '.vim$'
nnoremap <expr> <Leader>v  ( len(win_findbuf(buffer_number(g:vimrc_buf_name))) > 0 ) ?
			\  ( win_id2win(win_findbuf(buffer_number(g:vimrc_buf_name))[0]) . '<C-w><C-w>' ) :
			\  ( <SID>WindowRatio() >= 0 ? ':VVIMRC<CR>' : ':VIMRC<CR>' )
nnoremap <expr> <Leader>V  ( len(win_findbuf(buffer_number(g:color_buf_name1 . g:colors_name . g:color_buf_name2))) > 0 ) ?
			\  ( win_id2win(win_findbuf(buffer_number(g:color_buf_name1 . g:colors_name . g:color_buf_name2))[0]) . '<C-w><C-w>' ) :
			\  ( ':EditColor<CR>' )

" Configure }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}


" Other Key-Maps {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

nnoremap <leader>w <Esc>:<C-u>w<CR>
nnoremap <silent><expr> <Leader>r &l:readonly ? ':<C-u>setl noreadonly<CR>' : ':<C-u>setl readonly<CR>'
nnoremap <silent><expr> <Leader>R &l:modifiable ? ':<C-u>setl nomodifiable<CR>' : ':<C-u>setl modifiable<CR>'
nnoremap <leader>l :<C-u>echo len("<C-r><C-w>")<CR>
nnoremap <silent> ya :PushPos<CR>ggyG:PopPos<CR> | ":echo "All lines yanked."<CR>

"if exists('loaded_mru')
  nnoremap <silent> <leader>o :<C-u>MRU<CR>
"endif

"nnoremap <silent> <C-o> :<C-u>echoh hl_func_name<CR>:pwd<CR>:exe 'set statusline=\ \ ' . expand('%:p')<CR>:echoh None<CR>
"nnoremap <silent> <C-o> :<C-u>pwd<CR>:exe 'set statusline=%#SLFileName#\ \ ' . expand('%:p')<CR>
nnoremap <silent> <C-l> :<C-u>let g:alt_stl_time = 5<CR>:normal! <C-l><CR>:pwd<CR>:exe 'set statusline=%#SLFileName#\ \ ' . expand('%:p')<CR>

" US Keyboard {{{
nnoremap ; :
cnoremap <expr> ; getcmdline() =~# '^:*$' ? ':' : ';'
cnoremap <expr> : getcmdline() =~# '^:*$' ? ';' : ':'
" US Keyboard }}}


nnoremap <C-Tab> <C-w>p
inoremap <C-f> <C-p>
inoremap <C-e>	<End>
"inoremap <CR> <C-]><C-G>u<CR>
inoremap <C-H> <C-G>u<C-H>

nnoremap <leader>E :<C-u><C-R>"
"set whichwrap+=h,l
nnoremap <silent><expr> <leader>h &whichwrap !~ 'h' ? ':<C-u>set whichwrap+=h,l<CR>' : ':<C-u>set whichwrap-=h,l<CR>'
nnoremap <silent><expr> <Leader>L &l:wrap ? ':setl nowrap<CR>' : ':setl wrap<CR>'

nnoremap _    <C-w>s
nnoremap <Bar> <C-w>v

nnoremap gG G

nnoremap <expr> cr (search("\\k\\%#", 'bcn') ? 'b' : '') . 'cw'
nnoremap <expr> dr (search("\\k\\%#", 'bcn') ? 'b' : '') . 'dw'
nnoremap <expr> yr (search("\\k\\%#", 'bcn') ? 'b' : '') . 'yw'

nnoremap <silent> gf :<C-u>aboveleft sp<CR>gF

" Other Key-Maps }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}


" Clever-f Configuration {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{
let g:clever_f_smart_case=1			"
let g:clever_f_use_migemo=0			"
"let g:clever_f_fix_key_direction=1		"
let g:clever_f_chars_match_any_signs = '\\'	" 任意の記号にマッチする文字を設定する
if 0
  let g:clever_f_mark_cursor_color = 'gui=none guifg=black guibg=yellow'
  let g:clever_f_mark_char_color   = 'gui=none guifg=black guibg=red'
  let g:clever_f_mark_cursor = 1
  let g:clever_f_mark_char = 1
endif
" Clever-f Configuration }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}


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
"<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
function! Eatchar(pat)
  let c = nr2char(getchar(0))
  return (c =~ a:pat) ? '' : c
endfunc
"例 iabbr <silent> if if ()<Left><C-R>=Eatchar('\s')<CR>
"<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


" Push Pop Pos {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

"" データ構造定義 """"""""""""""""
"  dict {
"    'TopRow' : #;
"    'Cursor' : [];
"  } s:SavePos[スタック];
""""""""""""""""""""""""""""""""""

let s:SavePos = []

function! PushPos()
  " 画面最上行番号取得 (インデックス1が行番号)
  let toprow = getpos('w0')[1]

  " カーソル位置取得
  let cursor = getcurpos()

  " スタックへ保存
  call add(s:SavePos, {'TopRow' : toprow, 'Cursor' : cursor})
endfunction
com! PushPos :call PushPos()

function! ApplyPos()
  " " スタックが空なら何もしない
  " if empty(s:SavePos) | return | endif

  " silentを付けて回る!!!!!!

  " スタックトップの要素を取得
  let savepos = get(s:SavePos, len(s:SavePos)- 1)

  " 画面最上行番号を復帰
  " scrolloffを一旦0にしないと、上手く設定できない。
  let save_scrolloff = &scrolloff
  let &scrolloff = 0
  exe "normal! " . savepos['TopRow'] . "zt"
  let &scrolloff = save_scrolloff

  " カーソル位置を復帰
  call setpos('.', savepos['Cursor'])
endfunction
com! ApplyPos :call ApplyPos()

function! DropPos()
  " " スタックが空なら何もしない
  " if empty(s:SavePos) | return | endif

  " スタックトップの要素を除去
  call remove(s:SavePos, len(s:SavePos)- 1)
endfunction
com! DropPos :call DropPos()

function! PopPos()
  call ApplyPos()
  call DropPos()
endfunction
com! PopPos :call PopPos()

" ---------------
" PushPos_All:
" ---------------
function! PushPos_All()
    let s:now_win = winnr()
    let s:now_tab = tabpagenr()
    let s:now_buf = bufnr('')
    "PushPos
endfunction

" ---------------
" PopPos_All:
" ---------------
function! PopPos_All()
    silent exe 'tabnext ' . s:now_tab
    silent exe s:now_win . 'wincmd w'
    silent exe 'buffer ' . s:now_buf
    "PopPos
endfunction

" Push Pop Pos }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}


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


so $vim/exp.vim
so $vim/qf.vim
so $vim/func_name.vim
so $vim/test.vim
"so $VIMRUNTIME/macros/matchit.vim


"set foldmethod=syntax
set nowildmenu
set wildmode=longest,full


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

set packpath+=$VIMRUNTIME

let $PATH.=';C:\cygwin\bin'

" Windowsでの設定例です。Mac他の場合は外部コマンド部分を読み替えてください。
au FileType plantuml command! OpenUml :!/cygdrive/c/Program\ Files/Google/Chrome/Application/chrome.exe %

"nnoremap <silent> <Leader>F :<C-u>help function-list<CR>
com! FL help function-list<CR>

com! XMLShape :%s/></>\r</g | filetype indent on | setf xml | normal gg=G

" from default
filetype plugin indent on


" TODO {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

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


" 検索
" 置換
" Grep
" Diff
" タグ
" 補完
" Snippet
" 画面、表示 （ウィンドウ、バッファ、タブ）
" 移動、切り替え （ウィンドウ、バッファ、タブ）

" 基本
" 移動
" 見た目
" 編集
" 便利ツール

" Completion CScope Snippets cnext_cprev

" TODO }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}


