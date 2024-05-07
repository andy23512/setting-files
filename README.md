# repo for setting files I using

## VIM
### File
vimrc
### Setup
```sh
$ cp Shell/vimrc ~/.vimrc
$ git clone https://github.com/k-takata/minpac.git ~/.vim/pack/minpac/opt/minpac
$ vim "+call minpac#update()" +qall
```

## Git
gitconfig
### Setup
```sh
$ cp Shell/gitconfig ~/.gitconfig
```

## tmux
tmux.conf
### Setup
```sh
$ cp Shell/tmux.conf ~/.tmux.conf
```

## Bash
bashrc
### Setup
```sh
$ cp Shell/bashrc ~/.bashrc
```

## Zsh
zshrc
### Setup

use [Zsh for Humans](https://github.com/romkatv/zsh4humans/) to setup

```sh
$ vi -d Shell/zshrc ~/.zshrc (ensure the difference is expected)
$ vi -d Shell/p10k.zsh ~/.p10k.zsh (ensure the difference is expected)
$ cp Shell/zshrc ~/.zshrc
$ cp Shell/p10k.zsh ~/.p10k.zsh
```
