#!/usr/bin/awk -f

## .zshrc
## .screenrc
## .tmux.conf
## tmux
## .gitconfig
## .vimperatorrc
## .exrc
## .vimrc
## .gvimrc
## .vim
## .w3m



/^##/ {
	system("ln -s $HOME/dotfiles/" $2 " $HOME/" $2)
}
