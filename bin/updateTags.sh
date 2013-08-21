#!/bin/bash

# $HOME/bin/php-ctags.sh %%SOURCE%% %%TAG_NAME%%
CTAGS=$HOME/bin/php-ctags.sh
echo "Updating $1"
case $1 in
    all)
        $CTAGS /Volumes/tavis.aitken-nfs/src all
        ;;
    bpapp-php)
        $CTAGS '/Volumes/tavis.aitken-nfs/src/php-*' bpapp-php
        ;;
    zf)
    $CTAGS ~/SourceCode/Zend zf
    ;;
    *)
    echo "Usage $0 [project]"
    ;;
esac
