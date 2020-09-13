#!/bin/sh

# install python3
sudo apt-get update
sudo apt-get install vim python3 python3-venv python3-pip python-virtualenv zsh

# install nodejs
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo apt-get install -y build-essential
npm install -g git-jump

# install yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update && sudo apt-get install yarn

# install yarn completion
yarn global add yarn-completions

# install diff-so-dancy
sudo apt-get install -y diff-so-fancy
