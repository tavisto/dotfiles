#!/usr/bin/env bash

BREW='brew install '

packages='macvim vim markdown ctags wget tree bash bash-completion2'
for package in $packages
do
    $BREW $package
done