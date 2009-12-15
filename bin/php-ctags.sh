#!/bin/bash
cd $1 
ctags -f /tmp/$USER-$2 \
-n \
-h ".php.phtml" \
-R \
--extra=+f \
--exclude="\.svn" \
--exclude="*.js" \
--totals=yes \
--sort=yes \
--tag-relative=on \
--PHP-kinds=+cifd \

# when using ctags < 5.7 then these need to be used
#--regex-PHP='/abstract class ([^ ]*)/\1/c/' \
#--regex-PHP='/final class ([^ ]*)/\1/c/' \
#--regex-PHP='/interface ([^ ]*)/\1/c/' \
#--regex-PHP='/(public |static |final |abstract |protected |private )+function ([^ (]*)/\2/f/'

echo "Replacing relative paths with absolute. "
# Replace all the ralative paths to absolute paths 
#sed 's#../home#/home#' /tmp/$USER-$2 >  ~/.vim/tags/$2
sed 's#\.\./#/#' /tmp/$USER-$2 >  ~/.vim/tags/$2

echo "Moved to ~/.vim/tags/$2 ";
