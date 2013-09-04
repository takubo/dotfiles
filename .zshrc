#bindkey -v

function is-null {
    local current=${BUFFER}
    if [ "${current}" = "" ] ; then
	`bindkey ${KEYS}`
	return ${current}
    else
	`bindkey ${KEYS}`
	return ${current}
    fi
}

#autoload zkbd
#function zkbd_file() {
#    [[ -f ~/.zkbd/${TERM}-${VENDOR}-${OSTYPE} ]] && printf '%s' ~/".zkbd/${TERM}-${VENDOR}-${OSTYPE}" && return 0
#	[[ -f ~/.zkbd/${TERM}-${DISPLAY}          ]] && printf '%s' ~/".zkbd/${TERM}-${DISPLAY}"          && return 0
#	return 1
#}
#
#    [[ ! -d ~/.zkbd ]] && mkdir ~/.zkbd
#keyfile=$(zkbd_file)
#    ret=$?
#    if [[ ${ret} -ne 0 ]]; then
#    zkbd
#keyfile=$(zkbd_file)
#    ret=$?
#    fi
#    if [[ ${ret} -eq 0 ]] ; then
#    source "${keyfile}"
#    else
#    printf 'Failed to setup keys using zkbd.\n'
#    fi
#    unfunction zkbd_file; unset keyfile ret

# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -A key

case `uname` in
    *CYGWIN* )
	key[Home]="[H"
	;;
    * )
	key[Home]=${terminfo[khome]}
	key[End]=${terminfo[kend]}
	key[Insert]=${terminfo[kich1]}
	key[Delete]=${terminfo[kdch1]}
	key[Up]=${terminfo[kcuu1]}
	key[Down]=${terminfo[kcud1]}
	key[Left]=${terminfo[kcub1]}
	key[Right]=${terminfo[kcuf1]}
	key[PageUp]=${terminfo[kpp]}
	key[PageDown]=${terminfo[knp]}
	;;
esac




######## プロンプト ########

autoload colors
colors
#PROMPT="%U%{${fg[magenta]}%}%h:%j - %w %D{%H:%M} - %n%u %{${fg[cyan]}%}%~%{${fg[magenta]}%}
#%%%{${reset_color}%} "
#PROMPT="%{${fg[red]}%}%h:%j %{${fg[magenta]}%}%n %{${fg[blue]}%}%m%u %{${fg[green]}%}%w %D{%H:%M} %{${fg[cyan]}%}%~%{${fg[red]}%}
#%%%{${reset_color}%} "
case `uname` in
    *CYGWIN* )
	PROMPT="%B%U%{${fg[red]}%}[%j] %w %D{%H:%M}%u %U%{${fg[red]}%}%{${fg[magenta]}%}%n%u %U%{${fg[green]}%}%m%u %{${fg[cyan]}%}%~%{${fg[red]}%}
%%%{${reset_color}%} "
	;;
    * )
	PROMPT="%U%{${fg[red]}%}[%j] %w %D{%H:%M}%u %U%{${fg[red]}%}%{${fg[magenta]}%}%n%u %U%{${fg[green]}%}%m%u %{${fg[cyan]}%}%~%{${fg[red]}%}
%%%{${reset_color}%} "
	;;
esac
#PROMPT="%B%U%{${fg[red]}%}%h [%j]%u %{${fg[blue]}%}%~%{${fg[red]}%}
#%%%{${reset_color}%} "
#PROMPT="%B%{${fg[red]}%}[ %h:%j ]%% %{${reset_color}%}"
#RPROMPT="%B%{${fg[blue]}%}[ %~ ]%{${reset_color}%} "




######## 補完 ########

## 初期化
autoload -U compinit
compinit

## 補完侯補をメニューから選択する。
### select=2: 補完候補を一覧から選択する。
#zstyle ':completion:*:default' menu select
###           ただし、補完候補が3つ以上なければすぐに補完する。
zstyle ':completion:*:default' menu select=3
#zstyle ':completion:*:default' menu true

# Shift-Tabで補完候補を逆順する("\e[Z"でも動作する)
bindkey "^[[Z" reverse-menu-complete

## 補完候補に色を付ける。
### "": 空文字列はデフォルト値を使うという意味。
zstyle ':completion:*:default' list-colors ""
## 補完方法毎にグループ化する。
### 補完方法の表示方法
###   %B...%b: 「...」を太字にする。
###   %d: 補完方法のラベル
zstyle ':completion:*' format '%B%d%b'
zstyle ':completion:*' group-name ''
## 補完候補をキャッシュする。
zstyle ':completion:*' use-cache yes
## 詳細な情報を使う。
zstyle ':completion:*' verbose yes
## # カーソルの位置に補なうことで単語を完成させようとする。
setopt complete_in_word
## 補完候補がないときなどにビープ音を鳴らさない。
setopt no_beep
## 辞書順ではなく数字順に並べる。
setopt numeric_glob_sort
## 補完リストを水平にソートする。
setopt LIST_ROWS_FIRST

## -x: export SUDO_PATHも一緒に行う。
## -T: SUDO_PATHとsudo_pathを連動する。
typeset -xT SUDO_PATH sudo_path
## 重複したパスを登録しない。
typeset -U sudo_path
## (N-/): 存在しないディレクトリは登録しない。
##    パス(...): ...という条件にマッチするパスのみ残す。
##            N: NULL_GLOBオプションを設定。
##               globがマッチしなかったり存在しないパスを無視する。
##            -: シンボリックリンク先のパスを評価。
##            /: ディレクトリのみ残す。
sudo_path=({,/usr/pkg,/usr/local,/usr}/sbin(N-/))
## sudo時にはsudo用のパスも使う。
zstyle ':completion:sudo:*' environ PATH="$SUDO_PATH:$PATH"



######## 履歴 ########

## ヒストリを保存するファイル
HISTFILE=~/.zsh_history
## メモリ上のヒストリ数。
## 大きな数を指定してすべてのヒストリを保存するようにしている。
HISTSIZE=10000000
## 保存するヒストリ数
SAVEHIST=$HISTSIZE
## ヒストリファイルにコマンドラインだけではなく実行時刻と実行時間も保存する。
setopt extended_history
## 同じコマンドラインを連続で実行した場合はヒストリに登録しない。
setopt hist_ignore_dups
## スペースで始まるコマンドラインはヒストリに追加しない。
#setopt hist_ignore_space
## すぐにヒストリファイルに追記する。
setopt inc_append_history
## zshプロセス間でヒストリを共有する。
setopt share_history
## C-sでのヒストリ検索が潰されてしまうため、出力停止・開始用にC-s/C-qを使わない。
setopt no_flow_control

## コマンド履歴検索
#Ctrl-P/Ctrl-Nで、入力中の文字から始まるコマンドの履歴が表示される。
#"l"と入力した状態でCtrl-Pを押すと、"ls"や"less"が次々に表示されていく。
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end




######## ディレクトリ移動 ########

## コマンド名がディレクトリ時にcdする
setopt auto_cd
## # cd時に自動的にpushdする。"cd -[Tab]"で移動履歴を一覧
setopt auto_pushd

## 行頭の*で "cd ~" 実行
function ghq2 {
    local current=${BUFFER}
    if [ "${current}" = "" ] ; then
	zle push-input
	BUFFER="cd ~"
	zle accept-line
    else
	zle self-insert
    fi
}
zle -N ghq2
bindkey "\*" ghq2

## 行頭の^で "cd .." 実行
function top-dir2 {
    local current=${BUFFER}
    if [ "${current}" = "" ] ; then
	zle push-input
	BUFFER="cd .."
	zle accept-line
    else
	zle self-insert
    fi
}
zle -N top-dir2
bindkey "\^" top-dir2

## ^]で "popd" 実行
function prev-dir {
    zle push-input
    BUFFER="popd"
    zle accept-line
}
zle -N prev-dir
bindkey "^\]" prev-dir

## \tで "cd " 入力
function input-cd {
    local current=${BUFFER}
    if [ "${current}" = "" ] ; then
	zle push-input
	BUFFER="cd "
	zle end-of-line
    else
	zle expand-or-complete
	#zle self-insert
    fi
}
zle -N input-cd
bindkey "\t" input-cd

## 行頭の ; で "cd -" 実行
function prev-dir2 {
    local current=${BUFFER}
    if [ "${current}" = "" ] ; then
	zle push-input
	BUFFER="cd -"
	zle accept-line
    else
	zle self-insert
    fi
}
zle -N prev-dir2
bindkey ";" prev-dir2



######## プロセス制御 ########

# ^Zで "fg %" 実行
function run-fglast {
    #zle push-input
    #BUFFER="fg %"
    #zle accept-line
    fg %
    zle reset-prompt
}
zle -N run-fglast
bindkey "^z" run-fglast




######## エイリアス ########

#alias ls='ls -F --color=auto'
alias ls='ls --color=auto'
alias ll='ls -l'
alias la='ls -a'
alias l1='ls -1'
alias lF='ls -F'
alias lla='ls -la'
alias la1='ls -l1'
alias lh='ls -lh'
alias lt='ls -t'
alias lrt='ls -rt'
alias df='df -h'
alias md='mkdir'

#alias awk='gawk'
#alias v='vim'
#alias c='gcc'
#alias d='gdb'
#alias m='make'
alias -g A='| awk'
alias -g B='| bc -l'
alias -g C='| cut'
alias -g D='| disp'
alias -g F='| s2t | cut -f'	#field
alias -g G='| grep'
alias -g H='| head'
alias -g J='| japan_numerical'
alias -g L='| less'
alias -g N='| cat -n'
alias -g Q='| sort'
alias -g R='| tr'
alias -g S='| sed'
alias -g T='| tail'
alias -g U='| iconv -f cp932 -t utf-8'
alias -g V='| vim -R -'
alias -g W='| wc -l'
alias -g X='| xargs'
alias -g Y='| wc'
# EIKMOPZ

alias g='cd'
alias e='echo'
alias l='ls'
alias t='cat'
alias m='man'
alias v='vg'
alias af='awk -f'

#alias gt='git'
#alias mk='make'

#alias o='awk'

#alias search='apt-cache search'
#alias install='sudo apt-get install'

alias can='cat -n'
alias dog='cat -n'
alias s2t="sed -e 's/[ \t][ \t]*/\t/g'"
alias psg='ps ax | grep'

alias cc='gcc'
case `uname` in
    *CYGWIN* ) #Cygwin
	alias a='./a.exe'
	;;
    * ) #other UNIX or UNIX-like
	alias a='./a.out'
	;;
esac



######## 数学演算 ########

## 数学ライブラリをload
zmodload -i zsh/mathfunc




######## その他 ########

## 実行したプロセスの消費時間が3秒以上かかったら
## 自動的に消費時間の統計情報を表示する。
#REPORTTIME=3

# Zed エディタ
autoload zed

# シェル関数やスクリプトの source 実行時に、 $0 を一時的にその関数／スクリプト名にセットする。
setopt FUNCTION_ARGZERO

# `.' で開始するファイル名にマッチさせるとき、先頭に明示的に `.' を指定する必要がなくなる
#setopt GLOB_DOTS

# ZMV をLoad
autoload zmv




######## ローカル ########

PATH=~/bin:$PATH
alias vg='~/bin/gvim'




######## for GNU screen ########

preexec () {
  if [ "$TERM" = "screen" ]; then
    [ ${STY} ] && echo -ne "\ek${1%% *}\e\\"
  fi
}

precmd() {
  chpwd
}

chpwd() {
  if [ "$TERM" = "screen" -a "$PWD" = "$HOME" ]; then
      echo -n "\ek[~]\e\\"
  elif [ "$TERM" = "screen" ]; then
      echo -n "\ek[`basename $PWD`]\e\\"
  fi
}
chpwd




######## 実験場 ########

#function zcalc {
#    zle push-input
#    BUFFER='echo $((  ))'
#    zle forward-word
#    zle forward-word
#    zle backward-char
#}
#zle -N zcalc
#bindkey "\#\$" zcalc
#
#function zcalc-bc {
#    zle push-input
#    BUFFER='echo "" | bc -l'
#    zle forward-char
#    zle forward-char
#    zle forward-char
#    zle forward-char
#    zle forward-char
#    zle forward-char
#}
#zle -N zcalc-bc
#bindkey "\#\#" zcalc-bc

function zcalc-bc {
    #echo "\n"`echo "${BUFFER}" | bc -l`"\n"
    echo "\n"$(( ${BUFFER} ))"\n"
    BUFFER=""
    zle reset-prompt
}
alias zawk="gawk -O -e '
    BEGIN{ OFMT = \"%.8g\"; pi = atan2(0, -1) }
    # deg2rad
    function d2r(deg) { return deg * pi / 180 }
    # rad2deg
    function r2d(rad) { return rad * 180 / pi }
' -e"
function zcalc-bc {
    local current=${BUFFER}
    #local current
    #eval local current=${BUFFER}
    zle push-input
    #echo "\n"`echo "${BUFFER}" | bc -l`"\n"
    #echo "\n"$(( ${BUFFER} ))"\n"
    #BUFFER='echo "'${current}'" | bc -l'
    #BUFFER='echo $(( '${current}' ))'
    BUFFER="zgawk 'BEGIN{ print "${current}" }'"
    zle accept-line
}
zle -N zcalc-bc
bindkey "^j" zcalc-bc

#alias zgawk="gawk -O -e '
#    BEGIN{ OFMT = \"%.8g\"; pi = atan2(0, -1) }
#    # deg2rad
#    function d2r(deg) { return deg * pi / 180 }
#    # rad2deg
#    function r2d(rad) { return rad * 180 / pi }
#' -e"
function q() {
gawk -e '
    BEGIN{ OFMT = "%.8g"; pi = atan2(0, -1) }
    # deg2rad
    function d2r(deg) { return deg * pi / 180 }
    # rad2deg
    function r2d(rad) { return rad * 180 / pi }
    ' -e "BEGIN{ print $* }"
}

function xawk {
    local current=${BUFFER}
    if [ "${current}" = "" ] ; then
	BUFFER="awk 'BEGIN{ print  }'"
	zle forward-word
	zle forward-word
	zle forward-word
	zle backward-char
    else
	zle end-of-line
    fi
}
zle -N xawk
bindkey "^e" xawk

function xawk-f {
    local current=${BUFFER}
    if [ "${current}" = "" ] ; then
	BUFFER="awk -f "
	zle forward-word
	zle forward-word
    else
	zle beginning-of-line
    fi
}
zle -N xawk-f
bindkey "^a" xawk-f

#function zvim {
#    local current=${BUFFER}
#    if [ "${current}" = "" ] ; then
#	BUFFER="vim "
#	#zle accept-line
#    fi
#    zle end-of-line
#}
#zle -N zvim
#bindkey "^e" zvim

## 行頭の , で "cat" 入力
function beg-cat {
    local current=${BUFFER}
    if [ "${current}" = "" ] ; then
	BUFFER="cat "
	zle end-of-line
    else
	zle self-insert
    fi
}
zle -N beg-cat
bindkey "," beg-cat

## jjで "$_" 入力
function input-dollar-underbar {
    BUFFER=${LBUFFER}'$_'${RBUFFER}
    zle forward-char
    zle forward-char
}
zle -N input-dollar-underbar
bindkey "jj" input-dollar-underbar

## kkで "$" 入力
function input-dollar {
    BUFFER=${LBUFFER}'$'${RBUFFER}
    zle forward-char
}
zle -N input-dollar
bindkey "kk" input-dollar

## 行頭の . で "./" 入力
function input-dotsla {
    local current=${BUFFER}
    if [ "${current}" = "" ] ; then
	BUFFER="./"
	zle end-of-line
    else
	zle self-insert
    fi
}
zle -N input-dotsla
bindkey "." input-dotsla


#function xawk {
#    zle push-input
#    BUFFER="awk 'BEGIN{  }'"
#    zle forward-word
#    zle forward-word
#    zle backward-char
#}
#zle -N xawk
#bindkey "\@\@" xawk

### ^^で "cd -" 実行
#function next-dir {
#    zle push-input
#    BUFFER="cd -"
#    zle accept-line
#}
#zle -N next-dir
#bindkey "^\^" next-dir

#function input-cd2 {
#    local current=${BUFFER}
#    if [ "${current}" = "" ] ; then
#	zle push-input
#	BUFFER="cd  - "
#	zle end-of-line
#    else
#	zle self-insert
#    fi
#}

### ^^で "cd .." 実行
#function top-dir {
#    zle push-input
#    BUFFER="cd .."
#    zle accept-line
#}
#zle -N top-dir
#bindkey "\^\^" top-dir


#if [ `uname` =~ "CYGWIN" ] ; then
#    echo "CYG"
#    key[Home]="[H"
#else
#    key[Home]=${terminfo[khome]}
#    key[End]=${terminfo[kend]}
#    key[Insert]=${terminfo[kich1]}
#    key[Delete]=${terminfo[kdch1]}
#    key[Up]=${terminfo[kcuu1]}
#    key[Down]=${terminfo[kcud1]}
#    key[Left]=${terminfo[kcub1]}
#    key[Right]=${terminfo[kcuf1]}
#    key[PageUp]=${terminfo[kpp]}
#    key[PageDown]=${terminfo[knp]}
#fi

#PROMPT="%{${fg[magenta]}%}%h %{${fg[red]}%}%n@%~
#PROMPT="%U%{${fg[magenta]}%}%h[%j] --%D{%Y/%m/%d %H:%M:%S}-- %n (%?) %~
#PROMPT="%U%{${fg[magenta]}%}%h[%j] %{${fg[cyan]}%}-%D{%y/%m/%d %H:%M:%S}-%{${fg[magenta]}%} %n (%?) %~
#PROMPT="%U%{${fg[magenta]}%}%h%{${fg[cyan]}%}[%j] %?%{${fg[magenta]}%} -%D{%y/%m/%d %H:%M:%S}- %n%u %{${fg[cyan]}%}%~%{${fg[magenta]}%}
#PROMPT="%U%{${fg[cyan]}%}%h[%j] %? <%D{%y/%m/%d %H:%M:%S}> %n%u %{${fg[yellow]}%}%~%{${fg[cyan]}%}
#PROMPT="%U%{${fg[cyan]}%}%h[%j] %? <%D{%y/%m/%d %H:%M:%S}> %n%u %{${fg[yellow]}%}%~%{${fg[cyan]}%}
#PROMPT="%U%{${fg[magenta]}%}%h[%j] %? <%w> %n%u %{${fg[cyan]}%}%~%{${fg[magenta]}%}
#PROMPT="%U%{${fg[magenta]}%}%h[%j] %? <%D{%y-%m-%d %H:%M:%S}> %n%u %{${fg[cyan]}%}%~%{${fg[magenta]}%}
#PROMPT="%U%{${fg[magenta]}%}%h[%j] %? - %w %D{%H:%M} - %n%u %{${fg[cyan]}%}%~%{${fg[magenta]}%}








### 行頭の ] で "ls" 実行
#function beg-ls {
#    local current=${BUFFER}
#    if [ "${current}" = "" ] ; then
#	BUFFER="ls"
#	zle accept-line
#    else
#	zle self-insert
#    fi
#}
#zle -N beg-ls
#bindkey "]" beg-ls

#alias c='cc'






### 行頭の , で "cat" 入力
#function beg-cat {
#    local current=${BUFFER}
#    if [ "${current}" = "" ] ; then
#	BUFFER="cat "
#	zle end-of-line
#    else
#	BUFFER=${LBUFFER}" | "${RBUFFER}
#	zle forward-word
#	#zle self-insert
#    fi
#}
#zle -N beg-cat
#bindkey "," beg-cat

### で "./" 入力
#function a-dot-out {
#    local current=${BUFFER}
#    if [ "${current}" = "" ] ; then
#	BUFFER="./a.out "
#	zle end-of-line
#    else
#	zle self-insert
#    fi
#}
#zle -N a-dot-out
#bindkey "&" a-dot-out




#function h2b()
#{
#	echo "ibase=16; obase=2; $@ " | bc
#}
#function b2h()
#{
#	echo "ibase=2; obase=16; $@ " | bc
#}
#function h2d()
#{
#	echo "ibase=16; obase=10; $@ " | bc
#}
#function d2h()
#{
#	echo "ibase=10; obase=16; $@ " | bc
#}
#
#function radcon()
#{
#}


### \tで "cd -" 実行
#function prev-dir2 {
#    local current=${BUFFER}
#    if [ "${current}" = "" ] ; then
#	zle push-input
#	BUFFER="cd -"
#	zle accept-line
#    else
#	zle expand-or-complete
#    fi
#}
#zle -N prev-dir2
#bindkey "\t" prev-dir2

### [で "popd" 実行
#function beg-popd {
#    local current=${BUFFER}
#    if [ "${current}" = "" ] ; then
#	BUFFER="popd"
#	zle accept-line
#    else
#	zle self-insert
#    fi
#}
#zle -N beg-popd
#bindkey "[" beg-popd

#function command-time {
#    local current=$BUFFER
#    zle push-input
#    BUFFER="time "${current}
#    zle end-of-line
#}
#zle -N command-time
#bindkey "::" command-time

#function xawk {
#    zle push-input
#    BUFFER="awk 'BEGIN{  }'"
#    zle forward-word
#    zle forward-word
#    zle backward-char
#}
#zle -N xawk
#bindkey "\@\@" xawk

### ^^で "cd -" 実行
#function next-dir {
#    zle push-input
#    BUFFER="cd -"
#    zle accept-line
#}
#zle -N next-dir
#bindkey "^\^" next-dir

#function input-cd2 {
#    local current=${BUFFER}
#    if [ "${current}" = "" ] ; then
#	zle push-input
#	BUFFER="cd  - "
#	zle end-of-line
#    else
#	zle self-insert
#    fi
#}

### ^^で "cd .." 実行
#function top-dir {
#    zle push-input
#    BUFFER="cd .."
#    zle accept-line
#}
#zle -N top-dir
#bindkey "\^\^" top-dir


#if [ `uname` =~ "CYGWIN" ] ; then
#    echo "CYG"
#    key[Home]="[H"
#else
#    key[Home]=${terminfo[khome]}
#    key[End]=${terminfo[kend]}
#    key[Insert]=${terminfo[kich1]}
#    key[Delete]=${terminfo[kdch1]}
#    key[Up]=${terminfo[kcuu1]}
#    key[Down]=${terminfo[kcud1]}
#    key[Left]=${terminfo[kcub1]}
#    key[Right]=${terminfo[kcuf1]}
#    key[PageUp]=${terminfo[kpp]}
#    key[PageDown]=${terminfo[knp]}
#fi

#PROMPT="%{${fg[magenta]}%}%h %{${fg[red]}%}%n@%~
#PROMPT="%U%{${fg[magenta]}%}%h[%j] --%D{%Y/%m/%d %H:%M:%S}-- %n (%?) %~
#PROMPT="%U%{${fg[magenta]}%}%h[%j] %{${fg[cyan]}%}-%D{%y/%m/%d %H:%M:%S}-%{${fg[magenta]}%} %n (%?) %~
#PROMPT="%U%{${fg[magenta]}%}%h%{${fg[cyan]}%}[%j] %?%{${fg[magenta]}%} -%D{%y/%m/%d %H:%M:%S}- %n%u %{${fg[cyan]}%}%~%{${fg[magenta]}%}
#PROMPT="%U%{${fg[cyan]}%}%h[%j] %? <%D{%y/%m/%d %H:%M:%S}> %n%u %{${fg[yellow]}%}%~%{${fg[cyan]}%}
#PROMPT="%U%{${fg[cyan]}%}%h[%j] %? <%D{%y/%m/%d %H:%M:%S}> %n%u %{${fg[yellow]}%}%~%{${fg[cyan]}%}
#PROMPT="%U%{${fg[magenta]}%}%h[%j] %? <%w> %n%u %{${fg[cyan]}%}%~%{${fg[magenta]}%}
#PROMPT="%U%{${fg[magenta]}%}%h[%j] %? <%D{%y-%m-%d %H:%M:%S}> %n%u %{${fg[cyan]}%}%~%{${fg[magenta]}%}
#PROMPT="%U%{${fg[magenta]}%}%h[%j] %? - %w %D{%H:%M} - %n%u %{${fg[cyan]}%}%~%{${fg[magenta]}%}
### 行頭の , で "cat" 入力
#function beg-cat {
#    local current=${BUFFER}
#    if [ "${current}" = "" ] ; then
#	BUFFER="cat "
#	zle end-of-line
#    else
#	BUFFER=${LBUFFER}" | "${RBUFFER}
#	zle forward-word
#	#zle self-insert
#    fi
#}
#zle -N beg-cat
#bindkey "," beg-cat

### で "./" 入力
#function a-dot-out {
#    local current=${BUFFER}
#    if [ "${current}" = "" ] ; then
#	BUFFER="./a.out "
#	zle end-of-line
#    else
#	zle self-insert
#    fi
#}
#zle -N a-dot-out
#bindkey "&" a-dot-out




#function h2b()
#{
#	echo "ibase=16; obase=2; $@ " | bc
#}
#function b2h()
#{
#	echo "ibase=2; obase=16; $@ " | bc
#}
#function h2d()
#{
#	echo "ibase=16; obase=10; $@ " | bc
#}
#function d2h()
#{
#	echo "ibase=10; obase=16; $@ " | bc
#}
#
#function radcon()
#{
#}


### \tで "cd -" 実行
#function prev-dir2 {
#    local current=${BUFFER}
#    if [ "${current}" = "" ] ; then
#	zle push-input
#	BUFFER="cd -"
#	zle accept-line
#    else
#	zle expand-or-complete
#    fi
#}
#zle -N prev-dir2
#bindkey "\t" prev-dir2

### [で "popd" 実行
#function beg-popd {
#    local current=${BUFFER}
#    if [ "${current}" = "" ] ; then
#	BUFFER="popd"
#	zle accept-line
#    else
#	zle self-insert
#    fi
#}
#zle -N beg-popd
#bindkey "[" beg-popd

#function command-time {
#    local current=$BUFFER
#    zle push-input
#    BUFFER="time "${current}
#    zle end-of-line
#}
#zle -N command-time
#bindkey "::" command-time

#function xawk {
#    zle push-input
#    BUFFER="awk 'BEGIN{  }'"
#    zle forward-word
#    zle forward-word
#    zle backward-char
#}
#zle -N xawk
#bindkey "\@\@" xawk

#function zawk {
#    zle push-input
#    BUFFER="awk 'BEGIN{  }'"
#    zle forward-word
#    zle forward-word
#    zle backward-char
#}
#zle -N zawk
#bindkey "\@\@" zawk

### ^^で "cd -" 実行
#function next-dir {
#    zle push-input
#    BUFFER="cd -"
#    zle accept-line
#}
#zle -N next-dir
#bindkey "^\^" next-dir

#function input-cd2 {
#    local current=${BUFFER}
#    if [ "${current}" = "" ] ; then
#	zle push-input
#	BUFFER="cd  - "
#	zle end-of-line
#    else
#	zle self-insert
#    fi
#}

### ^^で "cd .." 実行
#function top-dir {
#    zle push-input
#    BUFFER="cd .."
#    zle accept-line
#}
#zle -N top-dir
#bindkey "\^\^" top-dir


#if [ `uname` =~ "CYGWIN" ] ; then
#    echo "CYG"
#    key[Home]="[H"
#else
#    key[Home]=${terminfo[khome]}
#    key[End]=${terminfo[kend]}
#    key[Insert]=${terminfo[kich1]}
#    key[Delete]=${terminfo[kdch1]}
#    key[Up]=${terminfo[kcuu1]}
#    key[Down]=${terminfo[kcud1]}
#    key[Left]=${terminfo[kcub1]}
#    key[Right]=${terminfo[kcuf1]}
#    key[PageUp]=${terminfo[kpp]}
#    key[PageDown]=${terminfo[knp]}
#fi

#PROMPT="%{${fg[magenta]}%}%h %{${fg[red]}%}%n@%~
#PROMPT="%U%{${fg[magenta]}%}%h[%j] --%D{%Y/%m/%d %H:%M:%S}-- %n (%?) %~
#PROMPT="%U%{${fg[magenta]}%}%h[%j] %{${fg[cyan]}%}-%D{%y/%m/%d %H:%M:%S}-%{${fg[magenta]}%} %n (%?) %~
#PROMPT="%U%{${fg[magenta]}%}%h%{${fg[cyan]}%}[%j] %?%{${fg[magenta]}%} -%D{%y/%m/%d %H:%M:%S}- %n%u %{${fg[cyan]}%}%~%{${fg[magenta]}%}
#PROMPT="%U%{${fg[cyan]}%}%h[%j] %? <%D{%y/%m/%d %H:%M:%S}> %n%u %{${fg[yellow]}%}%~%{${fg[cyan]}%}
#PROMPT="%U%{${fg[cyan]}%}%h[%j] %? <%D{%y/%m/%d %H:%M:%S}> %n%u %{${fg[yellow]}%}%~%{${fg[cyan]}%}
#PROMPT="%U%{${fg[magenta]}%}%h[%j] %? <%w> %n%u %{${fg[cyan]}%}%~%{${fg[magenta]}%}
#PROMPT="%U%{${fg[magenta]}%}%h[%j] %? <%D{%y-%m-%d %H:%M:%S}> %n%u %{${fg[cyan]}%}%~%{${fg[magenta]}%}
#PROMPT="%U%{${fg[magenta]}%}%h[%j] %? - %w %D{%H:%M} - %n%u %{${fg[cyan]}%}%~%{${fg[magenta]}%}
