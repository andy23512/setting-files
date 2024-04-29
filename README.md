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
```sh
zsh
cp Shell/zshrc ~/.zshrc
chsh -s /bin/zsh
mkdir -p ~/.zsh
cd ~/.zsh
curl -o git-completion.bash https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
curl -o _git https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh
```
