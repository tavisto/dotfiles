#!/bin/bash

CONFIG_DIR="$HOME/.home-config"

# Don't copy the repo directory or the . and .. files.
DOTFILES=`ls -aI .hg  $CONFIG_DIR| grep -v '\.\.' | grep -v '\.$'`
for i in $DOTFILES
do
    if [ $1 == 'clean' ]; then
        echo "Removing $HOME/$i"
        rm -v $HOME/$i
    fi
    echo "Linking $CONFIG_DIR/$i to $HOME/$i"
    ln -s $CONFIG_DIR/$i $HOME/$i
done
