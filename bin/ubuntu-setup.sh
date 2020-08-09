#!/bin/bash

SRC=$HOME/src

# Set up neovim and set up configs
sudo apt install neovim fzf
cd $SRC/github/tavisto
git clone https://github.com/tavisto/nvim-configs.git
cd $HOME
ln -s $SRC/github/tavisto/nvim-configs .config/nvim
cd .config/nvim
git clone https://github.com/k-takata/minpac.git ~/.config/nvim/pack/minpac/opt/minpac
/usr/bin/nvim -c PackUpdate -c exit
