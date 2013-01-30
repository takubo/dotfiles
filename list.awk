#!/usr/bin/awk -f

## .zshrc
## .tmux.conf


/^##/ {
	system("ln -s $HOME/dotfiles/" $2 " $HOME/" $2)
}
