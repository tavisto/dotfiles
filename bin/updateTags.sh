#!/bin/bash

# $HOME/bin/php-ctags.sh %%SOURCE%% %%TAG_NAME%%

echo "Updating $1"
case $1 in
beatport)
    $HOME/bin/php-ctags.sh /mnt/dev_server/source_code/beatport/trunk/php beatport
    ;;
mobile)
    $HOME/bin/php-ctags.sh /mnt/dev_server/source_code/mobile/trunk/php mobile
    ;;
catalog)
    $HOME/bin/php-ctags.sh /mnt/dev_server/source_code/api/catalog/trunk catalog
    ;;
admin)
    $HOME/bin/php-ctags.sh /mnt/dev_server/source_code/admintools/trunk/server/src at
    ;;
control)
    $HOME/bin/php-ctags.sh /mnt/dev_server/source_code/control/trunk/server/src control 
    ;;
    *) 
    echo "Usage $0 [project]"
    ;;
esac
