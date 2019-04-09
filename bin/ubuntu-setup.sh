#!/bin/bash

SRC=$HOME/src

# Set up go path and then go get the powerline-go 
sudo apt install golang
mkdir -p $HOME/src/go
export GOPATH=$HOME/src/go
go get github.com/justjanne/powerline-go

# Set up neovim and set up configs
sudo apt install neovim
cd $SRC/github/tavisto
git clone https://github.com/tavisto/nvim-configs.git
cd $HOME
ln -s $SRC/github/tavisto/nvim-configs .config/nvim
cd .config/nvim
git clone https://github.com/k-takata/minpac.git ~/.config/nvim/pack/minpac/opt/minpac
/usr/bin/nvim -c PackUpdate -c exit

# Set up snap packages
snap install slack --classic
snap install slack-term
