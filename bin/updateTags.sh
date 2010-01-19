#!/bin/bash

# $HOME/bin/php-ctags.sh %%SOURCE%% %%TAG_NAME%%

echo "Updating $1"
case $1 in
beatport)
    $HOME/bin/php-ctags.sh $SOURCE_CODE_DIR/beatport/trunk/php beatport
    ;;
mobile)
    $HOME/bin/php-ctags.sh $SOURCE_CODE_DIR/mobile/trunk/php mobile
    ;;
catalog)
    $HOME/bin/php-ctags.sh $SOURCE_CODE_DIR/api/catalog/trunk catalog
    ;;
admin)
    $HOME/bin/php-ctags.sh $SOURCE_CODE_DIR/admintools/trunk/server/src at
    ;;
control)
    $HOME/bin/php-ctags.sh $SOURCE_CODE_DIR/control/trunk/server/src control 
    ;;
zf)
    $HOME/bin/php-ctags.sh /usr/share/php/Zend zf 
    ;;

    *) 
    echo "Usage $0 [project]"
    ;;
esac
