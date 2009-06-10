#!/bin/bash
cd $1 
ctags -f /tmp/$2 \
-h ".php" -R \
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
sed 's#../home#/home#' /tmp/$2 >  ~/.vim/tags/$2

echo "Moved to ~/.vim/tags/$2 ";
