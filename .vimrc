scriptencoding utf-8
" vim:set ts=8 sts=2 sw=2 tw=0: (この行に関しては:help modelineを参照)
"
" An example for a Japanese version vimrc file.
" 日本語版のデフォルト設定ファイル(vimrc) - Vim 7.4
"
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


let skip_defaults_vim = 1
let no_vimrc_example = 1


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
set matchtime=2
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
set tags=./tags,./tags;
"grepコマンドの出力を取り込んで、gfするため。
set isfname-=:

"set viminfo+='100,c
set sessionoptions+=unix,slash
" set_end set end

set showtabline=0

set display+=lastline

set numberwidth=3

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

  au InsertEnter * set timeoutlen=3000
  au InsertLeave * set timeoutlen=1100

  "au FileType c,cpp,awk set mps+=?::,=:;

 "au BufNewFile,BufRead,FileType *.awk so $vim/avd/avd.vim
  au BufNewFile,BufRead,FileType * set textwidth=0

augroup end


nnoremap Y y$

nnoremap cr caw
nnoremap dr daw
nnoremap yr yiw

nnoremap cs ciw
nnoremap ds diw
nnoremap ys yaw

nnoremap <silent> ZZ <Nop>
nnoremap <silent> ZQ <Nop>

" コメント行の後の新規行の自動コメント化のON/OFF
nnoremap <expr> <leader># &formatoptions =~# 'o' ? ':<C-u>set formatoptions-=o<CR>:set formatoptions-=r<CR>' : ':<C-u>set formatoptions+=o<CR>:set formatoptions+=r<CR>'

nnoremap <silent><expr> <leader>. stridx(&isk, '.') < 0 ? ':<C-u>setl isk+=.<CR>' : ':<C-u>setl isk-=.<CR>'
nnoremap <silent><expr> <leader>, stridx(&isk, '_') < 0 ? ':<C-u>setl isk+=_<CR>' : ':<C-u>setl isk-=_<CR>'
nnoremap <silent><expr> <leader>u stridx(&isk, '_') < 0 ? ':<C-u>setl isk+=_<CR>' : ':<C-u>setl isk-=_<CR>'

nnoremap <silent> <Leader>m :<C-u>marks<CR>
nnoremap <silent> <Leader>" :<C-u>disp<CR>

nnoremap <silent> <leader>N :<C-u>set relativenumber!<CR>

cnoremap <expr> <C-t>	  getcmdtype() == ':' ? '../' :
			\ (getcmdtype() == '/' <Bar><Bar> getcmdtype() == '?') ? '\\|' :
			\ '<C-t>'

nnoremap <leader>; q:

"nnoremap <silent> <leader>t :<C-u>ToggleWord<CR>

"nnoremap  ]]  ]]f(bzt
nnoremap g]]  ]]f(b
"nnoremap  [[  [[f(bzt
nnoremap g[[  [[f(b
"nnoremap  ][  ][zb
nnoremap g][  ][
"nnoremap  []  []zb
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



" Cursor Move, CursorLine, CursorColumn, and Scroll {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{


""" vertical move {{{
nnoremap j  gj
nnoremap k  gk
nnoremap gj  j
nnoremap gk  k

vnoremap j  gj
vnoremap k  gk
vnoremap gj  j
vnoremap gk  k

set noshowcmd
""" }}}


""" horizontal move {{{
" ^に、|の機能を重畳
nnoremap <silent> ^ <Esc>:exe v:prevcount ? ('normal! ' . v:prevcount . '<Bar>') : 'normal! ^'<CR>
""" }}}


""" scroll move {{{
if 0
  nnoremap <silent> <Space>   <C-f>
  nnoremap <silent> <S-Space> <C-b>
else
  let g:comfortable_motion_no_default_key_mappings = v:true
  let g:comfortable_motion_friction = 90.0
  let g:comfortable_motion_air_drag = 6.0
  let g:comfortable_motion_impulse_multiplier = 3.8
  "nnoremap <silent> <Space>   :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0)     )<CR>
  "nnoremap <silent> <S-Space> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * -1)<CR>
  nnoremap <silent> <C-j>   :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0)     )<CR>
  nnoremap <silent> <C-k> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * -1)<CR>
  "let g:comfortable_motion_scroll_down_key = "\<C-e>"
  "let g:comfortable_motion_scroll_up_key = "\<C-y>"
  "let g:comfortable_motion_scroll_down_key = "j"
  "let g:comfortable_motion_scroll_up_key = "k"
endif
vnoremap <silent> <Space>   <C-f>
vnoremap <silent> <S-Space> <C-b>
""" }}}


""" cursorline cursorcolumn {{{
augroup MyVimrc_Cursor
  au!
  au WinEnter * setl cursorline
  au WinEnter * setl cursorcolumn
  au WinLeave * setl nocursorline
  au WinLeave * setl nocursorcolumn

  au BufEnter * setl cursorline
  au BufEnter * setl cursorcolumn
augroup end

nnoremap <silent> <Leader>c :<C-u>setl cursorline!<CR>
nnoremap <silent> <leader>C :<C-u>setl cursorcolumn!<CR>
""" }}}


""" scrolloff {{{
function! s:best_scrolloff()
  let &l:scrolloff = (g:BrowsingScroll || w:BrowsingScroll) ? 99999 : ( winheight(0) < 10 ? 0 : winheight(0) < 20 ? 2 : 5 )
endfunction

let g:BrowsingScroll = v:false
nnoremap z<Space>  :<C-u> let g:BrowsingScroll = !g:BrowsingScroll
                  \ <Bar> exe g:BrowsingScroll ? 'normal! zz' : ''
                  \ <Bar> call <SID>best_scrolloff()
                  \ <Bar> echo g:BrowsingScroll ? 'BrowsingScroll' : 'NoBrowsingScroll'<CR>
nnoremap g<Space>  :<C-u> let w:BrowsingScroll = !w:BrowsingScroll
                  \ <Bar> exe w:BrowsingScroll ? 'normal! zz' : ''
                  \ <Bar> call <SID>best_scrolloff()
                  \ <Bar> echo w:BrowsingScroll ? 'Local BrowsingScroll' : 'Local NoBrowsingScroll'<CR>

augroup MyVimrc_ScrollOff
  au!
  au WinNew     * let w:BrowsingScroll = v:false
  au WinEnter   * call <SID>best_scrolloff()
  au VimResized * call <SID>best_scrolloff()
augroup end
""" }}}


" Cursor Move, CursorLine, CursorColumn, and Scroll }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}



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


" Esc_Esc {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

let g:EscEsc = []

function! EscEsc_Add(str)
  call add(g:EscEsc, a:str)
endfunction

com! EscDisp echo g:EscEsc

function! Esc_Esc()
  for i in g:EscEsc
    "echo i
    exe i
  endfor
endfunction

" 'noh'はユーザ定義関数内では(事実上)実行出来ないので、別途実行の要あり。
nnoremap <silent> <Esc><Esc> <Esc>:<C-u>call Esc_Esc() <Bar> noh  <Bar> echon <CR>

call EscEsc_Add('let g:alt_stl_time = 0 | call UpdateStatusline(0)')
call EscEsc_Add('call clever_f#reset()')

" Esc_Esc }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}


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
" 入力 カーソル下の単語 クリップボード 前回
" Enter要 不要

function! s:search_str_num()
  let g:save_lang=$LANG
  let $LANG='C'
  PushPos
  exe '%s!' . @/ . '!!gn'
  PopPos
  let $LANG=g:save_lang
endfunction
function! s:search_str_num()
  let g:save_lang=$LANG
  let $LANG='C'
  PushPos
  let num = CmdOut("silent exe '%s!' . @/ . '!!gn'")
  PopPos
  echo '/' . @/ num
  let $LANG=g:save_lang
endfunction
com! SearchStrNum call <SID>search_str_num()
nnoremap <silent> <leader>n :<C-u>call <SID>search_str_num()<CR>

nnoremap <silent> n n:SearchStrNum<CR>
nnoremap <silent> N N:SearchStrNum<CR>

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

let c_jk_local = 0
"例外をキャッチしないと、最初と最後の要素の次に移動しようとして例外で落ちる。
nnoremap <expr><silent> <A-k> ":\<C-u>try \<Bar> " . (c_jk_local ? ":lprev" : "cprev") . "\<Bar> catch \<Bar> endtry" . "\<CR>"
nnoremap <expr><silent> <A-j> ":\<C-u>try \<Bar> " . (c_jk_local ? ":lnext" : "cnext") . "\<Bar> catch \<Bar> endtry" . "\<CR>"
nnoremap <silent> <Leader>0 :<C-u>let c_jk_local = !c_jk_local<CR>


">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


let g:prj_root_file = '.git'

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
    if glob(g:prj_root_file) != ''  " prj_root_fileファイルの存在確認
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
nnoremap H <C-o>
nnoremap L <C-i>

" 補償
noremap zh H
noremap zl L
"nnoremap zm M
"nnoremap <expr> zh &wrap ? 'H' : 'zh'
"nnoremap <expr> zl &wrap ? 'L' : 'zl'

" 補償の補償
noremap <C-@> zh
noremap <C-^> zl

" ---------------
" Unified CR
"   数字付きなら、行へジャンプ
"   qfなら当該行へジャンプ
"   helpなら当該行へジャンプ
"   それ以外なら、タグジャンプ
" ---------------
function! Unified_CR(mode)
  if v:prevcount
    " jumpする前に登録しないと、v:prevcountが上書されてしまう。
    call histadd('cmd', v:prevcount)
    " jumplistに残すためGを使用
    exe 'normal! ' . v:prevcount . 'G'
    return
  elseif &ft == 'qf'
    call feedkeys("\<CR>:FF2\<CR>", 'nt')
    return
  elseif &ft == 'help'
    call feedkeys("\<C-]>", 'nt')
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

nmap     <silent> <BS><CR>     <BS><BS><CR>

" Tag, Jump, and Unified CR }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}


" Diff {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

set diffopt+=iwhite

" diff Updte
nnoremap <expr> du &diff ? ':<C-u>diffupdate<CR>' : ':<C-u>diffthis<CR>'

" diff Close
nnoremap dc :<C-u>diffoff<CR>

" diff (all window) Quit
nnoremap <silent> dq :<C-u>call PushPos_All() <Bar> exe 'windo diffoff' <Bar> call PopPos_All() <Bar> echo 'windo diffoff'<CR>

" diff (all window and buffer) Quit
nnoremap <silent> dQ :<C-u>call PushPos_All() <Bar> exe 'bufdo diffoff' <Bar> exe 'windo diffoff' <Bar> call PopPos_All()<CR>:echo 'bufdo diffoff <Bar> windo diffoff'<CR>

" diff X(cross)
"nnoremap <silent> <expr> dx winnr('$') != 2 ? ':echoerr "dx error : Number of windows is not 2. "<CR>' :
                "\ winbufnr(1) == winbufnr(2) ? ':echoerr "Buffers are same."<CR>' :
                "\ ':<C-u>call PushPos_All() <Bar> exe "windo diffthis" <Bar> call PopPos_All()<CR>'

" Toggle Scrollbind
nnoremap dx :<C-u>setl scrollbind!<CR>

" diff toggle Ignorecase (lの字形はIに似ている)
nnoremap <expr> dl match(&diffopt, 'icase' ) < 0 ? ':<C-u>set diffopt+=icase<CR>'  : ':<C-u>set diffopt-=icase<CR>'

" diff Y(whi)tespace
nnoremap <expr> dy match(&diffopt, 'iwhite') < 0 ? ':<C-u>set diffopt+=iwhite<CR>' : ':<C-u>set diffopt-=iwhite<CR>'

" diff Visualize option
nnoremap dv :<C-u>echo &diffopt<CR>

nnoremap <Ins> [c^zz:FuncNameStl<CR>
nnoremap <Del> ]c^zz:FuncNameStl<CR>
vnoremap <Ins> [c^
vnoremap <Del> ]c^
nnoremap <C-p> [c^zz:FuncNameStl<CR>
nnoremap <C-n> ]c^zz:FuncNameStl<CR>
nnoremap U <Nop>

" diff accept (obtain and next)
"nnoremap <expr> d<Space> &diff ? 'do[c^' : 'normal! d<Space>'

" diff TODO
nnoremap <expr> d<Space> &diff ? ':<C-u>diffupdate<CR>' :
                       \ winnr('$') == 2 ? ':<C-u>call PushPos_All() <Bar> exe "windo diffthis" <Bar> call PopPos_All()<CR>' :
                       \ ':<C-u>diffthis<CR>'
nmap d<CR> d<Space>

" diff reject (next)
"nnoremap <expr> dr &diff ? '[c^' : ''

" Diff }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}


" Window {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

set noequalalways

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

"----------------------------------------------------------------------------------------

function! s:SkipTerm(direction)
  if v:prevcount
    return v:prevcount
  endif

  "windowが2つしかないなら、もう一方へ移動することは自明なので、
  "terminalであっても、<Tab>での移動を許す。
  if winnr('$') == 2
    return winnr() == 1 ? 2 : 1
  endif

  let terms = term_list()
  let next_win = winnr()

  for i in range(winnr('$'))
    if a:direction >= 0
      "順方向
      let next_win = ( next_win == winnr('$') ? 1 : next_win + 1 )
    else
      "逆方向
      let next_win = ( next_win == 1 ? winnr('$') : next_win - 1 )
    endif

    let nr = winbufnr(next_win)
    if count(terms, nr) < 1 || term_getstatus(nr) =~# 'normal'
      break
    endif
  endfor

  return next_win
endfunction

"----------------------------------------------------------------------------------------

nnoremap <BS> <C-w>

"----------------------------------------------------------------------------------------

nnoremap <silent> <expr> <BS><BS>  ( <SID>WindowRatio() >= 0 ? "\<C-w>v" : "\<C-w>s" ) . ':diffoff<CR>'
"nnoremap <silent> _                <C-w>s:diffoff<CR>
"nnoremap <silent> <Bar>            <C-w>v:diffoff<CR>
nnoremap <silent> _                <C-w>s:setl noscrollbind<CR>
nnoremap <silent> <Bar>            <C-w>v:setl noscrollbind<CR>
nnoremap <silent> g_               <C-w>n
nnoremap <silent> g<Bar>           :<C-u>vnew<CR>

nnoremap <silent> <expr> <Leader><Leader> ( <SID>WindowRatio() <  0 ? "\<C-w>v" : "\<C-w>s" ) . ':diffoff<CR>'
nnoremap          <expr> <S-BS>           <SID>WindowRatio() >= 0 ? ":vnew\<CR>" : ":new\<CR>"
nnoremap          <expr> <C-BS>           <SID>WindowRatio() <  0 ? ":vnew\<CR>" : ":new\<CR>"

"nnoremap <BS><CR> " Tag, Jump, and Unified CR を参照。

"----------------------------------------------------------------------------------------

if 0
nnoremap <silent>  <Tab>      <Esc>:exe <SID>SkipTerm(+1) . ' wincmd w'<CR>
nnoremap <silent>  <S-Tab>    <Esc>:exe <SID>SkipTerm(-1) . ' wincmd w'<CR>
endif
nnoremap           <C-Tab>    <C-w>w
tnoremap <expr>    <C-Tab>    winnr('$') == 1 ? '<C-w>:tabNext<CR>' : '<C-w>w'
nnoremap           <S-C-Tab>  <C-w>W
tnoremap <expr>    <S-C-Tab>  winnr('$') == 1 ? '<C-w>:tabprevious<CR>' : '<C-w>W'
nnoremap           -          <C-w>p

nnoremap <silent>  <C-w><C-w> <C-w>p
nnoremap           g<Tab>     <C-w>p
nnoremap <silent>  <C-Left>   <C-w>h
nnoremap <silent>  <C-Right>  <C-w>l
nnoremap <silent>  <C-Down>   <C-w>j
nnoremap <silent>  <C-Up>     <C-w>k
tnoremap <silent>  <C-Left>   <C-w>h
tnoremap <silent>  <C-Right>  <C-w>l
tnoremap <silent>  <C-Down>   <C-w>j
tnoremap <silent>  <C-Up>     <C-w>k

"----------------------------------------------------------------------------------------
"TODO

nnoremap <silent> <A-k>     <esc>1<C-w>-:<C-u>call <SID>best_scrolloff()<CR>
nnoremap <silent> <A-j>     <esc>1<C-w>+:<C-u>call <SID>best_scrolloff()<CR>
nnoremap <silent> <A-h>     <esc>3<C-w><
nnoremap <silent> <A-l>     <esc>3<C-w>>

nnoremap <silent> +         <esc>1<C-w>+:<C-u>call <SID>best_scrolloff()<CR>
nnoremap <silent> g+        <esc><C-w>_:<C-u>call <SID>best_scrolloff()<CR>
"nnoremap <silent> _         <esc>1<C-w>-:<C-u>call <SID>best_scrolloff()<CR>
"nnoremap <silent> g_        <esc>1<C-w>_:<C-u>call <SID>best_scrolloff()<CR>
nnoremap <silent> (         <esc>3<C-w><
nnoremap <silent> g(        <esc>1<C-w>|
nnoremap <silent> )         <esc>3<C-w>>
nnoremap <silent> g)        <esc><C-w>|


if 0
  nnoremap <silent> <C-k>     <esc>1<C-w>+:<C-u>call <SID>best_scrolloff()<CR>
  nnoremap <silent> <C-j>     <esc>1<C-w>-:<C-u>call <SID>best_scrolloff()<CR>
  nnoremap <silent> <C-h>     <esc>3<C-w><
  nnoremap <silent> <C-l>     <esc>3<C-w>>
else
  "nnoremap <silent> <C-k> <esc><C-w>k
  "nnoremap <silent> <C-j> <esc><C-w>j
  nnoremap <silent> <C-h> <esc><C-w>h
  nnoremap <silent> <C-l> <esc><C-w>l

  nnoremap <silent> <Space>      <Esc>:exe <SID>SkipTerm(+1) . ' wincmd w'<CR>
  nnoremap <silent> <S-Space>    <Esc>:exe <SID>SkipTerm(-1) . ' wincmd w'<CR>
  "nnoremap <silent> <C-n> <Esc>:exe <SID>SkipTerm(+1) . ' wincmd w'<CR>
  "nnoremap <silent> <C-p> <Esc>:exe <SID>SkipTerm(-1) . ' wincmd w'<CR>
endif

tnoremap <silent> <up>	    <C-w>2+:<C-u>
tnoremap <silent> <down>    <C-w>2-:<C-u>
tnoremap <silent> <left>    <C-w>3<
tnoremap <silent> <right>   <C-w>3>

nnoremap <silent> <S-up>    <esc><C-w>+:<C-u>call	<SID>best_scrolloff()<CR>
nnoremap <silent> <S-down>  <esc><C-w>-:<C-u>call	<SID>best_scrolloff()<CR>
nnoremap <silent> <S-left>  <esc><C-w><
nnoremap <silent> <S-right> <esc><C-w>>

tnoremap <silent> <S-up>    <C-w>+:<C-u>
tnoremap <silent> <S-down>  <C-w>-:<C-u>
tnoremap <silent> <S-left>  <C-w><
tnoremap <silent> <S-right> <C-w>>

nnoremap <silent> <C-up>    <C-w>_:<C-u>call		<SID>best_scrolloff()<CR>
nnoremap <silent> <C-down> 1<C-w>_:<C-u>call		<SID>best_scrolloff()<CR>
nnoremap <silent> <C-left> 1<C-w><bar>:<C-u>call	<SID>best_scrolloff()<CR>
nnoremap <silent> <C-right> <C-w><bar>:<C-u>call	<SID>best_scrolloff()<CR>

"----------------------------------------------------------------------------------------

nnoremap <silent> <A-up>    <C-w>K:<C-u>call		<SID>best_scrolloff()<CR>
nnoremap <silent> <A-down>  <C-w>J:<C-u>call		<SID>best_scrolloff()<CR>
nnoremap <silent> <A-left>  <C-w>H:<C-u>call		<SID>best_scrolloff()<CR>
nnoremap <silent> <A-right> <C-w>L:<C-u>call		<SID>best_scrolloff()<CR>

"----------------------------------------------------------------------------------------

nnoremap <silent> q         <C-w><C-c>
nnoremap <silent> <Leader>q :<C-u>q<CR>

"----------------------------------------------------------------------------------------

nnoremap <silent> <C-q>; q:
nnoremap <silent> <C-q>/ q/
nnoremap <silent> <C-q>? q?

"----------------------------------------------------------------------------------------

nnoremap <C-w><C-t> :<C-u>tab split<CR>
tnoremap <C-w><C-t> <C-w>T

"----------------------------------------------------------------------------------------

"kwbd.vim : ウィンドウレイアウトを崩さないでバッファを閉じる
" http://nanasi.jp/articles/vim/kwbd_vim.html
com! Kwbd let s:kwbd_bn = bufnr('%') | enew | exe 'bdel '. s:kwbd_bn | unlet s:kwbd_bn
nnoremap <silent> <C-q><C-q> :<C-u>Kwbd<CR>

" Window }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}


" Terminal {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

function! OpenTerm_Sub(key, val)
  if bufwinnr(a:val) < 0
    return 9999
  endif
  if bufwinnr(v:val) >= winnr()
    let ret = bufwinnr(a:val) - winnr()
  else
    let ret = winnr('$') - winnr() + bufwinnr(a:val)
  endif
  return ret
endfunction

function! OpenTerm()
  let terms = term_list()
  "echo terms
  call map(terms, function('OpenTerm_Sub'))
  "echo terms
  let minval = min(terms)
  "echo minval
  if minval != 0 && minval != 9999
    exe (minval + winnr() - 1) % (winnr('$')) + 1 . ' wincmd w'
  else
    terminal
  endif
endfunction

nnoremap <silent> gt         :<C-u>call OpenTerm()<CR>
nnoremap <silent> gT         :terminal<CR>
nnoremap <silent> <Leader>gt :vsplit<CR>:terminal ++curwin<CR>

tnoremap <C-w>; <C-w>:
tnoremap <Esc><Esc> <C-w>N
tnoremap <S-Ins> <C-w>"*
"tnoremap <C-l> <C-l>
"tnoremap <expr> <S-Del> '<C-w>:call term_sendkeys(bufnr(""), "cd " . expand("#" . winbufnr(1) . ":h"))<CR>'
tnoremap <expr> <S-Del> 'cd ' . expand('#' . winbufnr(1) . ':p:h')

for k in split('0123456789abcdefghijklmnopqrstuvwxyz', '\zs')
  exec 'tnoremap <A-' . k . '> <Esc>' . k
endfor

nmap <expr> o &buftype == 'terminal' ? 'i' : 'o'

" Terminal }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}


" Buffer {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

nnoremap K         :<C-u>ls <CR>:b<Space>
nnoremap gK        :<C-u>ls!<CR>:b<Space>
nnoremap <Leader>K :<C-u>ls <CR>:bdel<Space>

nnoremap <silent> <Del> :<C-u>bnext<CR>
nnoremap <silent> <Ins> :<C-u>bprev<CR>

nnoremap <silent> <A-n> :<C-u>bnext<CR>
nnoremap <silent> <A-p> :<C-u>bprev<CR>

nnoremap <Leader>z :<C-u>bdel
nnoremap <Leader>Z :<C-u>bdel!

" Buffer }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}


" Tab {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

nnoremap <C-t> :<C-u>tabnew<Space>

nnoremap <C-f> gt
nnoremap <C-b> gT

nnoremap <A-f> :tabmove +1<CR>
nnoremap <A-b> :tabmove -1<CR>

nnoremap U gt

" Tab }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}


" Tabline {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

"===============================================================

function! s:tabpage_label_full(n)
  " カレントタブページかどうかでハイライトを切り替える
  "let hi = a:n is tabpagenr() ? '%#TabLineSel#' : '%#TabLine#'
  "let hi = a:n is tabpagenr() ? '%#TabLineSel#' : '%#TabLine#'
  let hi = a:n is tabpagenr() ? '%#Statusline#' : '%#TabLine#'
  "let hi = a:n is tabpagenr() ? '%#SLFileName#' : '%#TabLine#'

  let no = '[' . a:n . ']'

  " タブページ内のバッファのリスト
  let bufnrs = tabpagebuflist(a:n)

  " バッファが複数あったらバッファ数を表示
  let num = '(' . len(bufnrs) . ')'

  " タブページ内に変更ありのバッファがあったら '+' を付ける
  let mod = len(filter(copy(bufnrs), 'getbufvar(v:val, "&modified")')) ? '+' : ''

  " カレントバッファ
  let curbufnr = bufnrs[tabpagewinnr(a:n) - 1]  " tabpagewinnr() は 1 origin
  let fname = pathshorten(bufname(curbufnr))
  "let fname = pathshorten(expand('#' . curbufnr . ':p'))
  let fname = fname == '' ? 'No Name' : fname

  let label = no . ' ' . num . mod . ' '  . fname

  "return '%' . a:n . 'T' . hi . ' < ' . label . '%T > %#TabLineFill#'
  return '%' . a:n . 'T' . hi . ' ◀ ' . label . '%T ▶ %#TabLineFill#'
endfunction

function! s:tabpage_label(n)
  " カレントタブページかどうかでハイライトを切り替える
  "let hi = a:n is tabpagenr() ? '%#TabLineSel#' : '%#TabLine#'
  let hi = a:n is tabpagenr() ? '%#TabLineSel#' : '%#TabLine#'
  return hi . ' [ ' . a:n . ' ] %#TabLineFill#'
endfunction

function! MakeTabLine()
  let titles = map(range(1, tabpagenr('$')), s:tabpage_label_func)
  let sep = '%#SLFileName# | '  " タブ間の区切り
  let tabpages = sep . join(titles, sep) . sep . '%#TabLineFill#%T'

  if 0
    let info = ''  " 好きな情報を入れる
    let info .= '%#Statusline#  '
    let info .= '%#SLFileName# ' . g:bat_str . ' '
    let info .= '%#Statusline#  '
    let info .= '%#SLFileName# ' . strftime('%Y/%m/%d (%a) %X') . ' '
    let info .= '%#Statusline#  '
    let info .= '%##'
  else
    let info = ''  " 好きな情報を入れる
    let info .= '%#Statusline#  '
    let info .= '%#SLFileName# ' . g:bat_str . ' '
    let info .= '%#Statusline#  '
    let info .= '%#Statusline# ' . strftime('%Y/%m/%d (%a) %X') . ' '
    let info .= '%#Statusline# '
    let info .= '%##'
  endif

  let linfo = ''  " 好きな情報を入れる
  let linfo .= '%#Statusline#  ' . strftime('%Y/%m/%d (%a) %X') . ' '
  let linfo .= '%#Statusline#  '
  let linfo .= '%#SLFileName# ' . g:bat_str . ' '
  let linfo .= '%#Statusline#  '
  let linfo .= '%##  '

  let left = linfo
  "let left = ''
  "let left = '%#Statusline#    %##'

  let right = "%#Statusline#  "
  "let right = "%#hl_func_name_stl#  %{cfi#format('%20s ()', repeat(' ', 20) . '- ()')} "
  "let right .= "%#Statusline#  %{cfi#format('%20s', repeat('-', 20))} "
  "let right .= "%#Statusline# %{cfi#format('%s ()', repeat('-', 10))} "
  let right .= "%#Statusline#" . "%#SLFileName# %{'[ '.&diffopt.' ]'} " . info

  return left . '  %<' . tabpages . '%=  ' . right  " タブリストを左に、情報を右に表示
  "return left . '    %<' . tabpages . '%=  ' . right  " タブリストを左に、情報を右に表示
endfunction

"===============================================================

function! s:toggle_tabline()
  let s:tabline_status = ( s:tabline_status + 1 ) % 3
  if s:tabline_status == 0
    set showtabline=0
  elseif s:tabline_status == 1
    let s:tabpage_label_func = 's:tabpage_label(v:val)'
    set showtabline=2
  elseif s:tabline_status == 2
    let s:tabpage_label_func = 's:tabpage_label_full(v:val)'
    set showtabline=2
  endif
  call Updatetabline(0)
endfunction

nnoremap <silent> <leader>= :<C-u>call <SID>toggle_tabline()<CR>

"===============================================================

function! Updatetabline(dummy)
  set tabline=%!MakeTabLine()
endfunction

" 旧タイマの削除  vimrcを再読み込みする際、古いタイマを削除しないと、どんどん貯まっていってしまう。
if exists('TimerTab')
  call timer_stop(TimerTab)
endif

let UpdatetablineInterval = 1000
let TimerTab = timer_start(UpdatetablineInterval, 'Updatetabline', {'repeat': -1})

"===============================================================

let s:tabline_status = 1  " 初回のtoggle_tabline呼び出しがあるので、ここは本来値-1を設定。
call <SID>toggle_tabline()

"===============================================================

" Tabline }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}


" Transparency {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

let g:my_transparency = 229
let g:my_transparency = 235
augroup MyVimrc_GUI
  au!
  "au GUIEnter * simalt ~x
  "au GUIEnter * ScreenMode 4
  au GUIEnter * ScreenMode 5
  exe 'au GUIEnter * set transparency=' . g:my_transparency
augroup end
nnoremap <silent> <S-PageUp>   :<C-u>ScreenMode 5<CR>
nnoremap <silent> <S-PageDown> :<C-u>ScreenMode 4<CR>

nnoremap <silent><expr> <PageUp>   ':<C-u>se transparency=' .    ( &transparency + 1      ) . '<Bar> Transparency <CR>'
nnoremap <silent><expr> <PageDown> ':<C-u>se transparency=' . max([&transparency - 1,   1]) . '<Bar> Transparency <CR>'   | " transparencyは、0以下を設定すると255になってしまう。

nnoremap <silent>       <C-PageUp>   :exe 'se transparency=' . (&transparency == g:my_transparency ? 255 : g:my_transparency) <Bar> Transparency <CR>
nnoremap <silent>       <C-PageDown> :exe 'se transparency=' . (&transparency == g:my_transparency ?  50 : g:my_transparency) <Bar> Transparency <CR>

com! Transparency echo printf(' Transparency = %4.1f%%', &transparency * 100 / 255.0)

" Transparency }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}


" Statusline {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

let g:stl = "  "
let g:stl = "  "
"let g:stl .= "%#SLFileName#[ %{winnr()} ]%## ( %n ) %m%r%{&autoread?'[AR]':''}%h%w "
"let g:stl .= "%<"
"let g:stl .= "%## %{substitute(expand('%:p'),'/[^/]\\+$','','')} %##%#SLFileName# %t %##   "
 let g:stl .= "%#SLFileName#[ %{winnr()} ]%## ( %n ) "
 let g:stl .= "%##%m%r%{&autoread?'[AR]':''}%h%w "
 let g:stl .= "%##%#SLFileName# %F "
 let g:stl .= "%<"
"let g:stl .= "%## %{&buftype!=''?'':substitute(expand('%:p'),'/[^/]\\+$','','')} "
"let g:stl .= "%## %{&buftype=~'help\\|quickref'?'':substitute(expand('%:p'),'/[^/]\\+$','','')} "
 let g:stl .= "%#SLFileName#%="
 let g:stl .= "%## %5{&fenc==''?'$':&fenc}  %4{&ff}  %4{&ft==''?'none':&ft} "
"let g:stl .= "%#SLFileName# %{&diff?'['.&diffopt.']':''} "
 let g:stl .= "%#SLFileName# %1{stridx(&isk,'.')<0?' ':'.'} %1{stridx(&isk,'_')<0?' ':'_'} "
 let g:stl .= "%1{c_jk_local!=0?'@':' '} %1{&whichwrap=~'h'?'>':'='} %1{g:MigemoIsSlash?'\\':'/'} %{&iminsert?'j':'e'} "
 let g:stl .= "%## %3p%% [%5L] "
"let g:stl .= "%## %5l L, %3v C "
"let g:stl .= "%#SLFileName#%{repeat(' ',winwidth(0)-(exists('b:buf_name_len')?b:buf_name_len:6)+(72))}"
 let g:stl .= "%#SLFileName# %{repeat(' ',winwidth(0)-178)} "
 let g:stl .= "%#SLFileName#"

augroup MyVimrc_StatusLine
  au!
  au BufAdd,BufNewFile,BufRead,BufFilePost,BufNew,FilterReadPost,FileReadPost,BufEnter,BufWinEnter *
     \ let b:buf_name_len = strdisplaywidth(fnamemodify(bufname(''),':t')) + max([strdisplaywidth(fnamemodify(bufname(''),':p'))+142, 240])
    "\ let b:buf_name_len = strdisplaywidth(fnamemodify(bufname(''),':t')) + max([strdisplaywidth(fnamemodify(bufname(''),':p'))+130, 240])
augroup end

let g:alt_stl_time = 0

function! UpdateStatusline(dummy)
  if g:alt_stl_time > 0 | let g:alt_stl_time -= 1 | endif
  if !g:alt_stl_time | set statusline=%!g:stl | endif
endfunction

let UpdateStatuslineInterval = 1000

" 旧タイマの削除  vimrcを再読み込みする際、古いタイマを削除しないと、どんどん貯まっていってしまう。
if exists('TimerUsl') | call timer_stop(TimerUsl) | endif

let TimerUsl = timer_start(UpdateStatuslineInterval, 'UpdateStatusline', {'repeat': -1})

" 初期設定のために1回は呼び出す。
call UpdateStatusline(0)

" Statusline }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}


" Battery {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

try
  " bat_win.pyが存在しない環境でもエラーとさせないためtryブロック内で実行。
  " filereadable()にしようか。

  py3file $HOME/system_py/bat_win.py

  " Battery (Statusline)
  function! Update_StatuslineBatteryInfo(dummy)
    call py3eval('bat_win_main()')
    let g:bat_str = g:bat_info['ACLine'] . ' ' . g:bat_info['Charging'] . ' ' . g:bat_info['RemainingPercent'] . ' ' . g:bat_info['RemainingTime']
  endfunction

  " 旧タイマの削除
  if exists('TimerUbi')
    call timer_stop(TimerUbi)
  endif

  let UpdateBatteryInfoInterval = 5 * 1000
  let TimerUbi = timer_start(UpdateBatteryInfoInterval, 'Update_StatuslineBatteryInfo', {'repeat': -1})

  " Battery Information
  let bat_info = {}

  call py3eval('bat_win_ini()')

  call Update_StatuslineBatteryInfo(0)
catch
  let bat_str='? ? ---% [--:--:--]'
 "let bat_str='$ y 100% [13:05:24]'
endtry

" Battery }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}


" Mru {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{
if exists('loaded_mru') && 0
  "let MRU_Window_Height = min([20, &lines / 4 ])
  "let MRU_Window_Height = max([8, &lines / 4 ])
  let MRU_Window_Height = 25
  augroup MyVimrc_MRU
    au!
    "au VimResized * let MRU_Window_Height = min([25, &lines / 3 ])
    au VimResized * let MRU_Window_Height = max([8, &lines / 3 ])
  augroup end
  nnoremap <silent> <leader>o :<C-u>MRU<CR>
else
  command! -nargs=* MRU exe 'browse filter %\c' . substitute(<q-args>, '[ *]', '.*', 'g') . '% oldfiles'
  nnoremap <Leader>o :<C-u>MRU<Space>
  " nnoremap <Leader>o  :<C-u>/ oldfiles<Home>browse filter /\c
endif
" Mru }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}
"

" Completion {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

set complete=.,w,b,u,i,t
set completeopt=menuone,preview
set pumheight=25


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
  call feedkeys("\<C-n>\<C-p>", 'n')
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
  call feedkeys(a:key, 'n')
  return ''
endfunction

inoremap <silent> <expr> jj pumvisible() ? '<C-N><C-N>' : '<Esc>:w<CR>'
inoremap          <expr> jj pumvisible() ? '<C-N><C-N>' : '<Esc>:w<CR>'
inoremap <expr> j pumvisible() ? Cmpl_jk("\<C-n>") : TrigCompl('j')
inoremap <expr> k pumvisible() ? Cmpl_jk("\<C-p>") : TrigCompl('k')
inoremap <expr> <C-j> pumvisible() ? 'j' : '<C-n>'
inoremap <expr> <C-k> pumvisible() ? 'k' : '<Esc>'

inoremap <expr> <CR>  pumvisible() ? '<C-y>' : '<C-]><C-G>u<CR>'
inoremap <expr> <Esc> pumvisible() ? '<C-e>' : '<Esc>'

inoremap <expr> gg ( pumvisible() ? '<C-Y>' : '' ) . '<Esc>:<C-u>w<CR>'

" Completion }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}


" i_Esc {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

let g:IEscPre = []
let g:IEscPost = []

function! IEscPre_Add(str)
  call add(g:IEscPre, a:str)
endfunction

function! IEscPost_Add(str)
  call add(g:IEscPost, a:str)
endfunction

com! IEscDisp echo g:IEscPre g:IEscPost

"function! I_Esc()
"  call IEscPre()
"  call feedkeys("\<Esc>", 'ntx')
"  "normal! <Esc>
"  call IEscPost()
"  return ''
"endfunction

function! IEscPre()
  let input = ''
  for i in g:IEscPre
    "echo i
    "exe i
    let input = input . funcref(i)()
  endfor
  "call feedkeys("k", 'ntx')
  return input
endfunction

function! IEscPost()
  for i in g:IEscPost
    "echo i
    exe i
  endfor
  return ''
endfunction

inoremap <expr> <plug>(I_Esc_Write) IEscPre() . "\<Esc>" . ':w<CR>'
"imap , <Plug>(I_Esc_Write)

"call IEscPre_Add('Semi')
"function! Semi()
"  return 'eStert'
"endfunction
"call IEscPost_Add('w')

" i_Esc }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}


" Snippets {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

"source D:/bin/vim74-kaoriya-win32/vim74/plugin/snipMate.vim
if exists('*TriggerSnippet')
  inoremap <silent> <Tab>   <C-R>=<SID>TriggerSnippet()<CR>
endif

" Snippets }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}


" Vim Configure {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

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

com! VEditColor :exe 'vs $VIMRUNTIME/colors/' . g:colors_name . '.vim'
com! VColorEdit :exe 'vs $VIMRUNTIME/colors/' . g:colors_name . '.vim'

let g:vimrc_buf_name = '^' . $vim . '/vimrc$'
let g:color_buf_name1 = '^' . $vimruntime . '/colors/'
let g:color_buf_name2 = '.vim$'
nnoremap <expr> <Leader>v  ( len(win_findbuf(buffer_number(g:vimrc_buf_name))) > 0 ) && win_id2win(reverse(win_findbuf(buffer_number(g:vimrc_buf_name)))[0]) > 0 ?
			\  ( win_id2win(reverse(win_findbuf(buffer_number(g:vimrc_buf_name)))[0]) . '<C-w><C-w>' ) :
			\  ( bufname('')=='' && &buftype=='' && !&modified ) ? ':EVIMRC<CR>' :
			\  ( <SID>WindowRatio() >= 0 ? ':VVIMRC<CR>' : ':VIMRC<CR>' )
nnoremap <expr> <Leader>V  ( len(win_findbuf(buffer_number(g:color_buf_name1 . g:colors_name . g:color_buf_name2))) > 0 ) ?
			\  ( win_id2win(win_findbuf(buffer_number(g:color_buf_name1 . g:colors_name . g:color_buf_name2))[0]) . '<C-w><C-w>' ) :
			\  ( <SID>WindowRatio() >= 0 ? ':VEditColor<CR>' : ':EditColor<CR>' )

" Vim Configure }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}


" Other Key-Maps {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

nnoremap <leader>w :<C-u>w<CR>
nnoremap <silent><expr> <Leader>r &l:readonly ? ':<C-u>setl noreadonly<CR>' : ':<C-u>setl readonly<CR>'
nnoremap <silent><expr> <Leader>R &l:modifiable ? ':<C-u>setl nomodifiable <BAR> setl readonly<CR>' : ':<C-u>setl modifiable<CR>'
nnoremap <leader>l :<C-u>echo len("<C-r><C-w>")<CR>
nnoremap <silent> yx :PushPos<CR>ggyG:PopPos<CR> | ":echo "All lines yanked."<CR>

"nnoremap <silent> <C-o> :<C-u>echoh hl_func_name<CR>:pwd<CR>:exe 'set statusline=\ \ ' . expand('%:p')<CR>:echoh None<CR>
"nnoremap <silent> <C-o> :<C-u>pwd<CR>:exe 'set statusline=%#SLFileName#\ \ ' . expand('%:p')<CR>
"nnoremap <silent> <C-l> :<C-u>let g:alt_stl_time = 5<CR>:normal! <C-l><CR>:pwd<CR>:exe 'set statusline=%#hl_func_name_stl#\ \ ' . expand('%:p')<CR>
"nnoremap <silent> <C-l> :<C-u>let g:alt_stl_time = 12 <Bar> exe (g:alt_stl_time > 0 ? '' : 'normal! <C-l>') <Bar> pwd <Bar> exe 'set statusline=%#hl_buf_name_stl#\ \ %F'<CR>
nnoremap <silent> <C-o> :<C-u>exe (g:alt_stl_time > 0 ? '' : 'normal! <C-l>')
                      \ <Bar> let g:alt_stl_time = 12
                      \ <Bar> pwd <Bar> echon '        ' &fileencoding '  ' &fileformat '  ' &filetype '    ' printf('L %d  C %d  %3.2f %%  TL %3d', line('.'), col('.'), line('.') * 100.0 / line('$'), line('$'))
                      \ <Bar> exe 'set statusline=%#hl_buf_name_stl#\ \ %F'<CR>
                     "\ <Bar> exe 'set statusline=%#SLFileName#\ \ %F'<CR>
                     "\ . '\ \ \ \ %#SLFileName#\ %5l\ L,\ %v\ C\ ' . '\ \ \ \ %3p%%\ [%L]\ '<CR>

" US Keyboard {{{
nnoremap ; :
vnoremap ; :
cnoremap <expr> ; getcmdline() =~# '^:*$' ? ':' : ';'
cnoremap <expr> : getcmdline() =~# '^:*$' ? ';' : ':'
" US Keyboard }}}


"nnoremap <C-Tab> <C-w>p
inoremap <C-f> <C-p>
inoremap <C-e>	<End>
"inoremap <CR> <C-]><C-G>u<CR>
inoremap <C-H> <C-G>u<C-H>

nnoremap <leader>E :<C-u><C-R>"
"set whichwrap+=h,l
nnoremap <silent><expr> <leader>h &whichwrap !~ 'h' ? ':<C-u>set whichwrap+=h,l<CR>' : ':<C-u>set whichwrap-=h,l<CR>'
nnoremap <silent><expr> <Leader>L &l:wrap ? ':setl nowrap<CR>' : ':setl wrap<CR>'

nnoremap gG G

nnoremap <silent> gf :<C-u>aboveleft sp<CR>gF

" Other Key-Maps }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}


" Clever-f Configuration {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

let g:clever_f_smart_case=1			"
let g:clever_f_use_migemo=0			"
"let g:clever_f_fix_key_direction=1		"
let g:clever_f_chars_match_any_signs = '\\'	" 任意の記号にマッチする文字を設定する
"let g:clever_f_chars_match_any_signs = ';'	" 任意の記号にマッチする文字を設定する
"let g:clever_f_chars_match_any_signs = ';'	" 任意の記号にマッチする文字を設定する
if 1
  hi MyCfC guifg=yellow guibg=black
  let g:clever_f_mark_cursor_color = 'MyCfC'
  "let g:clever_f_mark_char_color   = 'MyCfC'
  let g:clever_f_mark_cursor = 1
  "let g:clever_f_mark_char = 1
endif

"nnoremap <Leader>k :<C-u>let g:clever_f_use_migemo = !g:clever_f_use_migemo<CR>
nnoremap <Leader>k :<C-u>call <SID>clever_f_use_migemo_toggle()<CR>
function! s:clever_f_use_migemo_toggle()
  let g:clever_f_use_migemo = !g:clever_f_use_migemo
  echo g:clever_f_use_migemo ? 'clever_f_use_migemo' : 'No clever_f_use_migemo'
endfunction

" Clever-f Configuration }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}


">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
command! Tab2Space :setlocal   expandtab | retab<CR>
command! Space2Tab :setlocal noexpandtab | retab!<CR>

com! XMLShape :%s/></>\r</g | filetype indent on | setf xml | normal gg=G
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


">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
" 数値比較用の関数 lhs のほうが大きければ正数，小さければ負数，lhs と rhs が等しければ 0 を返す
function! CompNr(lhs, rhs)
    return a:lhs - a:rhs
endfunction
"<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
function! GetKey()
  return nr2char(getchar())
endfunction
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
    PushPos
    let g:now_buf = bufnr('')
    let g:now_win = winnr()
    let g:now_tab = tabpagenr()
endfunction
com! PushPosAll :call PushPos_All()

" ---------------
" PopPos_All:
" ---------------
function! PopPos_All()
    silent exe 'tabnext ' . g:now_tab
    silent exe g:now_win . 'wincmd w'
    silent exe 'buffer ' . g:now_buf
    PopPos
endfunction
com! PopPosAll :call PopPos_All()

" Push Pop Pos }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}


" Commnad Output Capture {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

command!
      \ -nargs=+ -bang
      \ -complete=command
      \ CmdOutCapture
      \ call s:cmd_out_capture([<f-args>], <bang>0)

function! s:cmd_out_capture(args, banged)
  new
  silent put =CmdOut(join(a:args))
  1,2delete _
endfunction

command!
      \ -nargs=+ -bang
      \ -complete=command
      \ CmdOutYank
      \ call s:cmd_out_yank([<f-args>], <bang>0)

function! s:cmd_out_yank(args, banged)
  silent let @* = CmdOut(join(a:args))
endfunction

function! CmdOut(cmd)
  redir => result
  silent execute a:cmd
  redir END
  return result
endfunction

function! CmdOutLine(args)
  return split(CmdOut(a:args), '\n')
endfunction

" Commnad Output Capture }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}


" Util {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{
function! TitleCase(str)
  return toupper(a:str[0]) . a:str[1:]
endfunction
" Util }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}




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


"so $vim/PrjTree.vim
so $vim/qf.vim
so $vim/mycfi.vim
so $vim/test.vim
"so $vim/em.vim
"so $vim/my_multiple.vim
"so $vim/buf.vim
so $VIMRUNTIME/macros/matchit.vim
so $vim/anzu.vim
"so $vim/BrowserJump.vim


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


" from default
filetype plugin indent on


com! Date echo '' strftime("%Y/%m/%d (%a) %H:%M:%S")
com! Time Date
com! Bat echo '' bat_str


set renderoptions=type:directx,scrlines:1

"set updatetime=300
augroup MyVimrc_Rendor
  au!
  "au InsertLeave * normal! <C-l>
  "au CursorHold * normal! <C-l>
  "au CursorHold * call feedkeys(":\<C-u>redraw<CR>", 'nx')
  "au CursorHold * redraw
  "au VimResized * normal! <C-l>
  "au CursorHold * let &renderoptions=&renderoptions
augroup end


" {{{
hi HlWord	guifg=#4050cd	guibg=white
hi HlWord	guibg=#4050cd	guifg=white
hi HlWord	guibg=NONE	guifg=NONE
hi HlWord	gui=reverse
hi HlWord	gui=NONE
hi HlWord	guibg=gray30	guifg=gray80
nnoremap <silent> <leader>` :<C-u>match HlWord /\<<C-r><C-w>\>/<CR>
"call EscEsc_Add('PushPosAll')
"call EscEsc_Add('windo match')
"call EscEsc_Add('PopPosAll')
augroup MyHiLight
  au!
  au WinLeave * match
augroup end
" `}}}


set mouse=
set mousehide

"set updatetime=500

augroup MyVimrc_Init
  au!
  au VimEnter * clearjumps | au! MyVimrc_Init
augroup end


nnoremap <expr> <Leader><Space> ":\<C-u>set iminsert=" . (&iminsert ? 0 : 2) . "<CR>"
nnoremap <expr> <Leader>j       ":\<C-u>set iminsert=" . (&iminsert ? 0 : 2) . "<CR>"
"nnoremap <expr>       g<Space> ":\<C-u>set iminsert=" . (&iminsert ? 0 : 2) . "<CR>"


" {{{{{ Jump Test
"nnoremap <silent> % :<C-u>keepjumps normal! %<CR>
"nnoremap <silent> G :<C-u>keepjumps normal! G<CR>
"nnoremap <silent> { :<C-u>keepjumps normal! {<CR>
"nnoremap <silent> } :<C-u>keepjumps normal! }<CR>
" }}}}}


" Refactoring
"nnorema <silent> <C-d> :<C-u>PushPos<CR>:g$.$s    /<C-r>//<C-r><C-w>/g<CR>:PopPos<CR>:echo 'Refactoring'<CR>
nnorema <silent> <C-d> :<C-u>PushPos<CR>:g$.$s    /<C-r>//<C-r><C-w>/g<CR>:PopPos<CR>:let @/='<C-r><C-w>'<CR>
"nnorema <silent> <C-d> :<C-u>call PushPos() <Bar> g$.$s    /<C-r>//<C-r><C-w>/g <Bar> call PopPos() <Bar> echo 'Refactoring'<CR>
"nnorema <silent> <C-d> :<C-u>g$.$s    /<C-r>//<C-r><C-w>/g<CR><C-o>:echo 'Refactoring'<CR>

cnoremap jj *
cnoremap kk _

nnoremap Q K

" Last

" {{{{{ winkey

"unlock g:www
let g:www = 'uivompqdacx'
let g:www = 'vompqdacx'
"lock g:www

for i in range(len(g:www))
  exe "nnoremap <nowait> y" . g:www[i] . " " . i . "\<C-w>\<C-w>"
endfor
nnoremap <silent> <nowait> yu :<C-u>split<CR>
nnoremap <silent> <nowait> yi :<C-u>vsplit<CR>
nnoremap <silent> <nowait> yj :<C-u>new<CR>
nnoremap <silent> <nowait> yl :<C-u>vnew<CR>

"nmap <C-e> <Esc>
"nmap <C-e><C-e> <Esc><Esc>
"vmap <C-e> <Esc>
"cmap <C-e> <Esc>


""" y
""" s
""" r
""" 
""" ;',.
""" jk/
" }}}}}

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

" Ctrl hjkl o ud fb np ^ ]
" TODO }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}



" 1 f順方向 -
" 2 f逆方向 ,
" 3 前のWindow :
" 4 関数名 \\
" 5 画面Auto分割 <BS>
" 5 画面横分割 _
" 6 画面縦分割 +

" - , <BS>
" \\
" : + |


if filereadable('customer.vim')
  so $vim/customer.vim
endif


nnoremap <silent> T [c^zz:FuncNameStl<CR>
nnoremap <silent> t ]c^zz:FuncNameStl<CR>

"nnoremap <silent> M [c^zz:FuncNameStl<CR>
"nnoremap <silent> m ]c^zz:FuncNameStl<CR>
"例外をキャッチしないと、最初と最後の要素の次に移動しようとして例外で落ちる。
nnoremap <expr><silent> M ":\<C-u>try \<Bar> " . (c_jk_local ? ":lprev" : "cprev") . "\<Bar> catch \<Bar> endtry" . "\<CR>"
nnoremap <expr><silent> m ":\<C-u>try \<Bar> " . (c_jk_local ? ":lnext" : "cnext") . "\<Bar> catch \<Bar> endtry" . "\<CR>"
nnoremap <silent> <Leader>0 :<C-u>let c_jk_local = !c_jk_local<CR>

com! AR :setl autoread!
