#!/bin/sh

# copy vimrc and setup vundle
\cp vimrc ~/.vimrc
\mkdir -p ~/.vim/bundle/
\git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
echo | echo | vim +PluginInstall +qall &>/dev/null

# copy gitconfig
\cp gitconfig ~/.gitconfig

# copy tmux conf
\cp tmux.conf ~/.tmux.conf

# get git completion file
\wget  -P ~ https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
\mv ~/git-completion.bash ~/.git-completion.bash

# get django completion file
\wget -P ~ https://raw.githubusercontent.com/django/django/master/extras/django_bash_completion
\mv ~/django_bash_completion ~/.django_bash_completion

# copy bashrc
\cp bashrc ~/.bashrc
. ~/.bashrc
