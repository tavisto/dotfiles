#!/usr/bin/env bash

BREW=$(which brew)
if [ -f $BREW ]; then

    echo "Installing stuff from Brewfile"
    $BREW bundle
    echo "Updating brew"
    $BREW update
    echo "Upgrading stuff"
    $BREW upgrade
    echo "Cleaning up old versions"
    $BREW cleanup
fi
