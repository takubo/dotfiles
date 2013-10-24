#!/usr/bin/awk -f

## .zshrc
## .screenrc
## .tmux.conf
## tmux
## .gitconfig
## .vimperatorrc
## .vim



/^##/ {
	system("ln -s $HOME/dotfiles/" $2 " $HOME/" $2)
}
