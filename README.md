# repo for setting files I using

## VIM
### File
vimrc
### Setup
```sh
$ cp vimrc ~/.vimrc
$ mkdir -p ~/.vim/bundle 
$ git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
$ vi
(in vi) :BundleInstall
```

## Git
gitconfig
### Setup
```sh
$ cp gitconfig ~/.gitconfig
```

## tmux
tmux.conf
### Setup
```sh
$ cp tmux.conf ~/.tmux.conf
```

## Bash
bashrc
### Setup
```sh
$ cp bashrc ~/.bashrc
```

## Zsh + Prezto
zshrc
zpreztorc
### Setup
```sh
zsh
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done
cp zshrc ~/.zshrc
cp zpreztorc ~/.zpreztorc
chsh -s /bin/zsh
```
