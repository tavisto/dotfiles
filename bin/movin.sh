#!/bin/bash

CONFIG_DIR="$HOME/.home-config"

pushd $CONFIG_DIR/
shopt -s dotglob
for file in *
do
    ## Remove the files if they alaredy exist first
    if [[ "$1" == "clean" ]]; then
        echo "Removing $HOME/$file"
        
        mv $HOME/$file $HOME/$file.bak
    fi

    if [ $file != .hg ]; then
        echo "Linking $file to $HOME/$file"
        ln -s $CONFIG_DIR/$file $HOME/$file
    else
        echo "Not linking the .hg folder"
    fi
done
popd
