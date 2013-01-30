#!/usr/bin/awk -f

## .zshrc
## .tmux.conf
## tmux
## .gitconfig
## .vimperatorrc



/^##/ {
	system("ln -s $HOME/dotfiles/" $2 " $HOME/" $2)
}
