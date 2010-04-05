#!/bin/bash

# $HOME/bin/php-ctags.sh %%SOURCE%% %%TAG_NAME%%
CTAGS=$HOME/bin/php-ctags.sh
echo "Updating $1"
case $1 in
    auth)
    $CTAGS $SOURCE_CODE_DIR/internal-api/authentication auth
    ;;
    beatport)
    $CTAGS $SOURCE_CODE_DIR/beatport/php-beatport-www beatport
    ;;
    mobile)
    $CTAGS $SOURCE_CODE_DIR/mobile/php-beatport-mobile/php mobile
    ;;
    catalog)
    $CTAGS $SOURCE_CODE_DIR/api/php-api-catalog/php catalog
    ;;
    admin)
    $CTAGS $SOURCE_CODE_DIR/php-admintools/server/src at
    ;;
    control)
    $CTAGS $SOURCE_CODE_DIR/control/trunk/server/src control 
    ;;
    email)
    $CTAGS $SOURCE_CODE_DIR/api/app-email-php/ email
    ;;
    i18n)
    $CTAGS $SOURCE_CODE_DIR/api/app-i18n-php/ i18n
    ;;
    cart)
    $CTAGS $SOURCE_CODE_DIR/internal-api/php-internal-api-cart cart
    ;;
    voids)
    $CTAGS $SOURCE_CODE_DIR/internal-api/app-internal-api-voids-php/ voids 
    ;;
    zf)
    $CTAGS /usr/share/php/Zend zf
    ;;
    *) 
    echo "Usage $0 [project]"
    ;;
esac
