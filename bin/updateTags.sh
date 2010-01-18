#!/bin/bash

# $HOME/bin/php-ctags.sh %%SOURCE%% %%TAG_NAME%%

echo "Updating $1"
case $1 in
zf)
    $HOME/bin/php-ctags.sh /usr/share/php/Zend zf 
    ;;

    *) 
    echo "Usage $0 [project]"
    ;;
esac
