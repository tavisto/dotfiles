#!/bin/bash

CONFIG_DIR="$HOME/src/github/tavisto/dotfiles"

while getopts "bc" flag
do
	case "$flag" in
		c) clean=1;echo "Running Clean";;
        b) backup=1; echo "Backing up existing";;
	esac
done

pushd $CONFIG_DIR/
shopt -s dotglob
for file in *
do
    ## Remove the files if they alaredy exist first
    if [[ $backup -gt 0  ]]; then
        echo "Removing $HOME/$file"
        mv $HOME/$file $HOME/$file.bak
    fi
    if [[ $clean -gt 0  ]]; then
        echo "Removing $HOME/$file"
        unlink $HOME/$file
    fi

    if [ $file != .git ]; then
        echo "Linking $file to $HOME/$file"
        ln -s $CONFIG_DIR/$file $HOME/$file
    else
        echo "Not linking the .git folder"
    fi
done
popd
