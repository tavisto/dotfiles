#!/bin/bash

# $HOME/bin/php-ctags.sh %%SOURCE%% %%TAG_NAME%%
CTAGS=$HOME/bin/php-ctags.sh
echo "Updating $1"
case $1 in
    zf)
    $CTAGS ~/SourceCode/Zend zf
    ;;
    *) 
    echo "Usage $0 [project]"
    ;;
esac
