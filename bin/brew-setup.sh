#!/usr/bin/env bash

BREW='/usr/local/bin/brew'
if [ -f $BREW ]; then
    echo "Tapping all the kegs!"
    taps='homebrew/versions rockstack/rock'
    tapped=`$BREW tap`
    for tap in $taps
    do
        if [[ "$tapped" != *$tap* ]]
        then
            brew_command="$BREW tap $tap"
            $brew_command
        fi
    done

    echo "Updating brew"
    $BREW update
    echo "Installing stuff if needed"
    packages=`cat ~/.brew-list`
    installed=`$BREW list`
    for package in $packages
    do
        if [[ "$installed" != *$package* ]]
        then
            brew_command="$BREW install $package"
            $brew_command
        fi
    done
    echo "Upgrading stuff"
    $BREW upgrade --all
    echo "Linking stuff"
    $BREW linkapps
    echo "Cleaning up old versions"
    $BREW cleanup
fi