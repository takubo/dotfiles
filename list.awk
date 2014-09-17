#!/usr/bin/awk -f

## .zshrc
## .screenrc
## .tmux.conf
## tmux
## .gitconfig
## .vimperatorrc
## .vim
## .w3m



/^##/ {
	system("ln -s $HOME/dotfiles/" $2 " $HOME/" $2)
}
