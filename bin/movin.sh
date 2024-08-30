#!/bin/bash

CONFIG_DIR="$HOME/src/github.com/tavisto/dotfiles"

while getopts "bc" flag
do
  case "$flag" in
    c) clean=1;echo "Running Clean";;
    b) backup=1; echo "Backing up existing";;
    *) echo "Invalid flags!"; exit 1;;
  esac
done

pushd "$CONFIG_DIR"/ || exit
shopt -s dotglob
for file in *
do
  ## Remove the files if they alaredy exist first
  if [[ $backup -gt 0  ]]; then
    echo "Backing up $HOME/$file"
    mv "$HOME/$file" "$HOME/$file.bak"
  fi
  if [[ $clean -gt 0  ]]; then
    echo "Removing $HOME/$file"
    unlink "$HOME/$file"
  fi
  
  if [ "$file" == '.config' ]; then
    echo "Managing config dir linking"
    for config in *
    do
      echo "Linking $config to $XDG_CONFIG_HOME/$config"
      ln -s "$CONFIG_DIR/$config" "$XDG_CONFIG_HOME/$config"
    done
    continue 
  fi

  if [ "$file" != .git ]; then
    echo "Linking $file to $HOME/$file"
    ln -s "$CONFIG_DIR/$file" "$HOME/$file"
  else
    echo "Not linking the .git folder"
  fi

done
popd || exit

