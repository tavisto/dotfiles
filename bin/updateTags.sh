#!/bin/bash

# $HOME/bin/php-ctags.sh %%SOURCE%% %%TAG_NAME%%
CTAGS=$HOME/bin/php-ctags.sh
echo "Updating $1"
case $1 in
auth)
    $HOME/bin/php-ctags.sh $SOURCE_CODE_DIR/internal-api/authentication auth
    ;;
beatport)
    $HOME/bin/php-ctags.sh $SOURCE_CODE_DIR/beatport/trunk/php beatport
    ;;
bp-release)
    $HOME/bin/php-ctags.sh $SOURCE_CODE_DIR/beatport/branches/4.2009.1563/php bp-release
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
email)
    $CTAGS $SOURCE_CODE_DIR/api/app-email-php/ email
    ;;
i18n)
    $CTAGS $SOURCE_CODE_DIR/api/app-i18n-php/ i18n
    ;;
zf)
    $HOME/bin/php-ctags.sh /usr/share/php/Zend zf
    ;;
    *) 
    echo "Usage $0 [project]"
    ;;
esac
