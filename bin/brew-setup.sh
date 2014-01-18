#!/usr/bin/env bash

BREW='/usr/local/bin/brew'
packages='rock-cli git macvim vim markdown ctags wget tree bash bash-completion2'
if [ -f $BREW ]; then
    $BREW install $packages
    $BREW linkapps
fi