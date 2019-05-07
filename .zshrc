#!/bin/zsh

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




######## Prompt ########

autoload colors
colors
case `uname` in
    *CYGWIN* )
	PROMPT="%B%U%{${fg[red]}%}[%j] %w %D{%H:%M}%u %U%{${fg[red]}%}%{${fg[magenta]}%}%n%u %U%{${fg[green]}%}%m%u %{${fg[cyan]}%}%~%{${fg[red]}%}
%%%{${reset_color}%} "
	PROMPT="%B%U%{${fg[red]}%}[%j] %w %D{%H:%M}%u %U%{${fg[red]}%}%{${fg[magenta]}%}%n%u %U%{${fg[cyan]}%}%~%u%{${fg[red]}%}
%%%{${reset_color}%} "
	PROMPT="%B%U%{${fg[red]}%}[%j] %w %D{%H:%M}%u %U%{${fg[cyan]}%}%~%u%{${fg[red]}%}
%%%{${reset_color}%} "
	;;
    * )
	PROMPT="%U%{${fg[red]}%}[%j] %w %D{%H:%M}%u %U%{${fg[red]}%}%{${fg[magenta]}%}%n%u %U%{${fg[green]}%}%m%u %{${fg[cyan]}%}%~%{${fg[red]}%}
%%%{${reset_color}%} "
	;;
esac




######## PATH ########

PATH=~/bin:$PATH




######## Completion ########

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




######## History ########

## ヒストリを保存するファイル
HISTFILE=~/.zsh_history
## メモリ上のヒストリ数。
## 大きな数を指定してすべてのヒストリを保存するようにしている。
HISTSIZE=4294967295
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

bindkey "^[[A" history-beginning-search-backward-end
bindkey "^[[B" history-beginning-search-forward-end




######## Changing Directly ########

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

#? ## 行頭の^で "cd .." 実行
#? function up-dir {
#?     local current=${BUFFER}
#?     if [ "${current}" = "" ] ; then
#? 	zle push-input
#? 	BUFFER="cd .."
#? 	zle accept-line
#?     else
#? 	zle self-insert
#?     fi
#? }
#? zle -N up-dir
#? bindkey "\^" up-dir

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
    if [ "${BUFFER}" = "" ] ; then
        zle push-input
        LBUFFER="cd "
    else
        zle expand-or-complete
    fi
}
zle -N input-cd
bindkey "\t" input-cd

## 行頭の ; で "ls" を入力
function input-ls {
    if [ "${BUFFER}" = "" ] ; then
        #? LBUFFER="ls "
        LBUFFER="ms "
	zle accept-line
    else
        zle self-insert
    fi
}
zle -N input-ls
bindkey ";" input-ls




######## ZLE ########
autoload zed

# 改行を入力しやすくする
bindkey "^j" self-insert
bindkey -s "^[^m" "\n"

## jjで "$_" 入力
function input-dollar-underbar {
    LBUFFER=${LBUFFER}'$_'
}
zle -N input-dollar-underbar
bindkey "jj" input-dollar-underbar

## kkで "$" 入力
function input-dollar {
    LBUFFER=${LBUFFER}'$'
}
zle -N input-dollar
bindkey "kk" input-dollar

## 行頭/パイプ後/セミコロン後の . で './' 入力
function input-curdir {
    # 空文字列の比較をしているのは、カーソルが行頭にあるときのため。
    #case `echo -n ${LBUFFER[-1]%%(#)[ 	]#}` in
    #case `echo ${LBUFFER} | sed 's%[ 	]*$%%'` in
    case `echo -n ${LBUFFER%%[ 	]}` in
        *\| | *\; | '' ) LBUFFER=${LBUFFER}'./' ;;
        * )              zle self-insert ;;
    esac
}
zle -N input-curdir
bindkey "." input-curdir

## ~で '~/' 入力
function input-homedir {
    # 空文字列の比較をしているのは、カーソルが行頭にあるときのため。
    case `echo -n ${LBUFFER[-1]}` in
        ' ' | '	' | '|' | ';' | '' ) LBUFFER=${LBUFFER}'~/' ;;
    #case `echo -n ${LBUFFER%%[ 	]}` in
        #*\| | *\; | '' ) LBUFFER=${LBUFFER}'~/' ;;
        * )                          zle self-insert ;;
    esac
}
zle -N input-homedir
bindkey "~" input-homedir

## ^で '../' 入力
function input-or-move-updir {
	if [ "${BUFFER}" = "" ] ; then
		BUFFER='cd ../'
		zle accept-line
	else
		# # 空文字列の比較をしているのは、カーソルが行頭にあるときのため。
		# case `echo -n ${LBUFFER[-1]}` in
		# 	' ' | '	' | '|' | ';' | '' ) LBUFFER=${LBUFFER}'../' ;;
		# 	* )                          zle self-insert ;;
		# esac
		zle self-insert
	fi
}
zle -N input-or-move-updir
bindkey "\^" input-or-move-updir

## -で 'cd -' 入力
function go-prev-dir {
    if [ "${BUFFER}" = "" ] ; then
	#LBUFFER="cd -"
	BUFFER="cd -"
	zle accept-line
    else
	zle self-insert
    fi
}
zle -N go-prev-dir
bindkey "\-" go-prev-dir




######## Process Control ########

# ^Zで "fg %" 実行
function run-fg-last {
    #zle push-input
    #BUFFER="fg %"
    #zle accept-line
    fg %
    zle reset-prompt
}
zle -N run-fg-last
bindkey "^z" run-fg-last

## 実行したプロセスの消費時間が5秒以上かかったら
## 自動的に消費時間の統計情報を表示する。
REPORTTIME=5

#function command-time {
#    local current=$BUFFER
#    zle push-input
#    BUFFER="time "${current}
#    zle end-of-line
#}
#zle -N command-time
#bindkey "::" command-time




######## Aliases ########

alias ls='ls --color=auto -v'
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias llh='ls -lh'
alias lah='ls -lah'
alias lo='ls -1'    # one
alias l1='ls -1'
alias lh='ls -1sh'

alias lt='ls -1ht'
alias lT='ls -1hrt'
alias lr='ls -1hrt'
alias llt='ls -lht'
alias llT='ls -lhrt'
alias llr='ls -lhrt'

alias ml='ms -l'
alias ma='ms -a'
alias mla='ms -la'
alias m1='ms -1'

alias df='df -h'
alias md='mkdir'
#alias md='source $HOME/bin/md'

alias grep='grep --color=auto'

#alias awk='gawk'
#alias v='vim'
#alias c='gcc'
#alias d='gdb'
#alias m='make'
# to abbreviations alias -g A='| awk'
# to abbreviations alias -g B='| bc -l'
# to abbreviations alias -g C='| cut'
#ga alias -g C='| clip'
#ga alias -g D='| disp'
# to abbreviations alias -g F='| s2t | cut -f'	#field
# to abbreviations alias -g G='| grep'
#ga alias -g H='| head -n 20'
#ga alias -g J='| japan_numerical'
alias -g L='| less'
# to abbreviations alias -g N='| cat -n'
# to abbreviations alias -g Q='| sort'
# to abbreviations alias -g R='| tr'
# to abbreviations alias -g S='| sed'
#ga alias -g T='| tail'
#ga alias -g U='| iconv -f cp932 -t utf-8'
# to abbreviations alias -g V='| vim -R -'
#ga alias -g W='| wc -l'
# to abbreviations alias -g X='| xargs'
# to abbreviations alias -g Y='| wc'
# EIKMOPZ
alias GD='git diff'
alias GS='git status .'
alias gsh='git status | head -n 20'
alias kakasi='kakasi -iutf8 -outf8'

alias g='cd'
alias e='echo'
alias l='ls'
alias t='cat'
alias m='man'
#alias v='vg'
#alias vg='gvim'
alias af='awk -f'

alias gt='git'
alias mk='make'

alias can='cat -n'
alias dog='cat -n'
alias s2t="sed -e 's/[ \t][ \t]*/\t/g'"
alias psg='ps ax | grep'

alias cc='gcc'
case `uname` in
    *CYGWIN* )	# Cygwin
	alias a='./a.exe'
	alias vim='gvim'
	;;
    * )		# Other Unix or Unix-like
	alias a='./a.out'
	;;
esac




######## Abbreviations ########

setopt extended_glob

typeset -A abbreviations

abbreviations=(
    "A"    "| awk '"
    "B"    "| bc -l"
    "D"    "| cat -n"
#   "CN"   "| cat -n"
    "DX"   "| d2x -s"
    "LC"   "LANG=C"
    "LJ"   "LANG=ja_JP.UTF-8"
#   "LF"   "LANG=fr_FR.UTF-8"
#   "D"    "| disp"
# alias -g C='| cut'
#   "E"    "2>&1 > /dev/null"
# alias -g F='| s2t | cut -f'	#field
    "G"    "| grep"
    "GV"   "| grep -v"
    "HH"   '| head -n $(($LINES-4))'
    "H"    "| head -n 20"
    "Hn"   "| head -n"
    "HN"   "| head -n"
    "I"    "|"
#   "I"    "< /dev/null"
#   "J"    "| japan_numerical"
#   "L"    "| less"
    "L"    "| clip"
    "N"    "> /dev/null"
    "Ne"   "2> /dev/null"
    "N2"   "2> /dev/null"
#   "Na"   "> /dev/null 2>&1"
    "NN"   "> /dev/null 2>&1"
    "Ni"   "< /dev/null"
    "ON"   "-o -name '"
    "O"    "| sort"     # `O'rder
    "Q"    "| sort"     # Quick sort
    "QQ"   "--help"
# alias -g Q='| sort'	# Quick Sort
# alias -g R='| tr'
    "S"    "| sed '"
    "SN"   "| sed -n '"
#   "T"    "| tail"
    "T"    '| tail -n $(($LINES-4))'
    "Tn"   "| tail -n"
    "TN"   "| tail -n 20"
    "U"    "| iconv -f cp932 -t utf-8"
    "UU"   "| iconv -f utf-8 -t cp932"
#   "Ucu"  "| iconv -f cp932 -t utf-8"
#   "Ueu"  "| iconv -f euc-jp -t utf-8"
#   "Uuc"  "| iconv -f utf-8 -t cp932"
#   "Uec"  "| iconv -f euc-jp -t cp932"
#   "Uce"  "| iconv -f cp932 -t euc-jp"
#   "Uue"  "| iconv -f utf-8 -t euc-jp"
    "UN"   "| sort | uniq"
    "V"    "| vim -R -"
    "W"    "| wc -l"
    "X"    "| xargs"
    "F"    "| xargs -i"		# For each
    "XI"   "| xargs -i"
#   "Xn"   "| xargs -n"
#   "XX"   "| xargs"

    "TU"   "| tr 'a-f' 'A-F'"	# To Upper
    "M"    "| mc '"
    "B"    "| xc '"

    "FN"   "| find -name '*"
    "FNS"  "| find -name '.svn' -prune -type f -o -name '"
    "FG"   "| find | xargs grep"

    "AB"   "| awk 'BEGIN{"
    "ABF"  "| awk 'BEGIN{ printf \"%"
    "FOR"  "for (i = 1; i <= NF; i++)"
# alias -g Y='| wc'
)

# magic-abbrev-expand() {
#     local MATCH
#     OLD_LBUFFER=${LBUFFER}
#     LBUFFER=${LBUFFER%%(#m)[-_a-zA-Z0-9]#}
#     LBUFFER+=" "${abbreviations[$MATCH]:-$MATCH}
#     LBUFFER=${LBUFFER## | }      # 行頭で展開するときはパイプを消す
# 	if [ "${abbreviations[$MATCH][-1]}" != "'" ]; then
# 	# 展開後の末尾が"'"でなければスぺ―ス自体を挿入
#         zle self-insert
#     fi
# }
magic-abbrev-expand() {
	local MATCH
	LBUFFER=${LBUFFER%%(#m)[-_a-zA-Z0-9]#}
	LBUFFER+=${abbreviations[$MATCH]:-$MATCH}
	LBUFFER=${LBUFFER##| }      # 行頭で展開するときはパイプを消す
	if [ "${abbreviations[$MATCH][-1]}" != "'" ]; then
		# 展開後の末尾が'でなければスぺ―ス自体を挿入
		zle self-insert
	fi
}
zle -N magic-abbrev-expand
bindkey " " magic-abbrev-expand




######## Math ########

## 数学ライブラリをload
zmodload -i zsh/mathfunc

## PIをシェル変数として定義
PI=`awk 'BEGIN{ printf "%.12f", atan2(0,-1) }'`




######## Miscellaneous ########

# シェル関数やスクリプトの source 実行時に、 $0 を一時的にその関数／スクリプト名にセットする。
setopt FUNCTION_ARGZERO

# `.' で開始するファイル名にマッチさせるとき、先頭に明示的に `.' を指定する必要がなくなる
#setopt GLOB_DOTS

# ZMV をLoad
autoload zmv

function xawk {
    if [ "${BUFFER}" = "" ] ; then
	LBUFFER="awk 'BEGIN{ print "
	RBUFFER=" }'"
    else
	zle end-of-line
    fi
}
zle -N xawk
bindkey "^e" xawk

function xawk-f {
    if [ "${BUFFER}" = "" ] ; then
	LBUFFER="awk -f "
    else
	zle beginning-of-line
    fi
}
zle -N xawk-f
bindkey "^a" xawk-f

alias AWK="gawk -O -e '
    BEGIN{ OFMT = \"%.8g\"; pi = atan2(0, -1) }
    # deg2rad
    function d2r(deg) { return deg * pi / 180 }
    # rad2deg
    function r2d(rad) { return rad * 180 / pi }
' -e"
function aawk {
    if [ "${BUFFER}" = "" ] ; then
	LBUFFER="AWK 'BEGIN{ print "
	RBUFFER=" }'"
    else
	zle backward-char
    fi
}
zle -N aawk
bindkey "^b" aawk

#function AWK() {
#gawk -e '
#    BEGIN{ OFMT = "%.8g"; pi = atan2(0, -1) }
#    # deg2rad
#    function d2r(deg) { return deg * pi / 180 }
#    # rad2deg
#    function r2d(rad) { return rad * 180 / pi }
#    ' -e "BEGIN{ print $* }"
#}
#
#function aawk {
#    local current=${BUFFER}
#    if [ "${current}" = "" ] ; then
#	BUFFER="AWK '  '"
#	zle forward-word
#	zle backward-char
#	zle backward-char
#    else
#	zle delete-char-or-list
#    fi
#}
#zle -N aawk
#bindkey "^b" aawk

#function zcalc {
#    zle push-input
#    BUFFER='echo $((  ))'
#    zle forward-word
#    zle forward-word
#    zle backward-char
#}
#zle -N zcalc
#bindkey "\#\$" zcalc




######## for GNU Screen ########

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

#function xawk {
#    zle push-input
#    BUFFER="awk 'BEGIN{  }'"
#    zle forward-word
#    zle forward-word
#    zle backward-char
#}
#zle -N xawk
#bindkey "\@\@" xawk

#function zcalc-bc {
#    local current=${BUFFER}
#    #local current
#    #eval local current=${BUFFER}
#    zle push-input
#    #echo "\n"`echo "${BUFFER}" | bc -l`"\n"
#    #echo "\n"$(( ${BUFFER} ))"\n"
#    #BUFFER='echo "'${current}'" | bc -l'
#    #BUFFER='echo $(( '${current}' ))'
#    BUFFER="zgawk 'BEGIN{ print "${current}" }'"
#    zle accept-line
#}
#zle -N zcalc-bc
#bindkey "##" zcalc-bc

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


# コマンドラインでもコメントを使う
setopt interactivecomments

# {}の中に no match があってもエラーとしない。
setopt nonomatch

alias awk='awk -M'

export GREP_COLORS='ms=01;31:mc=01;31:sl=:cx=:fn=35:ln=32:bn=32:se=36'
export LESS='-i -M -R'

function tf {
	unset tf

	# trap '[[ "$tmpfile" ]] && rm -f $tmpfile' 1 2 3 15

	tf=$(mktemp --suffix .$1 2>/dev/null||mktemp --suffix .$1 -t tmp)

	vgg $tf
}

alias dog='source-highlight-esc.sh'


[ -f ~/.zshrc.local ] && source ~/.zshrc.local


# for vim terminal
LANG=ja_JP.UTF-8
