#!/bin/bash

# $HOME/bin/php-ctags.sh %%SOURCE%% %%TAG_NAME%%
CTAGS=$HOME/bin/php-ctags.sh
echo "Updating $1"
case $1 in
    all)
        $CTAGS /Volumes/taitken.bplwebdev002/source-code all
        ;;
    zf)
    $CTAGS ~/SourceCode/Zend zf
    ;;
    *)
    echo "Usage $0 [project]"
    ;;
esac
