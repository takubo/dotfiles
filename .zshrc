######## プロンプト ########

autoload colors
colors
#PROMPT="%{${fg[magenta]}%}%h %{${fg[red]}%}%n@%~
#PROMPT="%U%{${fg[magenta]}%}%h[%j] --%D{%Y/%m/%d %H:%M:%S}-- %n (%?) %~
#PROMPT="%U%{${fg[magenta]}%}%h[%j] %{${fg[cyan]}%}-%D{%y/%m/%d %H:%M:%S}-%{${fg[magenta]}%} %n (%?) %~
#PROMPT="%U%{${fg[magenta]}%}%h%{${fg[cyan]}%}[%j] %?%{${fg[magenta]}%} -%D{%y/%m/%d %H:%M:%S}- %n%u %{${fg[cyan]}%}%~%{${fg[magenta]}%}
#PROMPT="%U%{${fg[cyan]}%}%h[%j] %? <%D{%y/%m/%d %H:%M:%S}> %n%u %{${fg[yellow]}%}%~%{${fg[cyan]}%}
#PROMPT="%U%{${fg[cyan]}%}%h[%j] %? <%D{%y/%m/%d %H:%M:%S}> %n%u %{${fg[yellow]}%}%~%{${fg[cyan]}%}
PROMPT="%U%{${fg[magenta]}%}%h[%j] %? <%D{%y/%m/%d %H:%M:%S}> %n%u %{${fg[cyan]}%}%~%{${fg[magenta]}%}
%%%{${reset_color}%} "




######## 補完 ########

## 初期化
autoload -U compinit
compinit
## 補完侯補をメニューから選択する。
### select=2: 補完候補を一覧から選択する。
#zstyle ':completion:*:default' menu select
###           ただし、補完候補が5つ以上なければすぐに補完する。
zstyle ':completion:*:default' menu select=5
#
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
## カーソル位置で補完する。
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

## ディレクトリ名を入力するだけで移動
setopt auto_cd
## 移動したディレクトリを記録しておく。"cd -[Tab]"で移動履歴を一覧
setopt auto_pushd




######## プロセス制御 ########

# ^Zで fg 実行
function run-fglast {
    zle push-input
    BUFFER="fg %"
    zle accept-line
}
zle -N run-fglast
bindkey "^z" run-fglast




######## エイリアス ########

alias ls='ls --color=auto'
alias ll='ls -l'
alias la='ls -a'
alias md='mkdir'
alias awk='gawk'
alias v='vim'
alias vg='~/bin/gvim'
alias c='gcc'
alias d='gdb'
alias m='make'
alias -g G='| grep'
alias -g L='| less'
alias -g V='| vim -R -'
alias a='cat'
alias l='ls'
alias e='echo'




######## 数学演算 ########

## 数学ライブラリをload
zmodload -i zsh/mathfunc

function h2b()
{
	echo "ibase=16; obase=2; $@ " | bc
}
function b2h()
{
	echo "ibase=2; obase=16; $@ " | bc
}
function h2d()
{
	echo "ibase=16; obase=10; $@ " | bc
}
function d2h()
{
	echo "ibase=10; obase=16; $@ " | bc
}




######## その他 ########

## 実行したプロセスの消費時間が3秒以上かかったら
## 自動的に消費時間の統計情報を表示する。
#REPORTTIME=3




######## ローカル ########

PATH=~/bin:$PATH




