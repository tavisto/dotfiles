#!/bin/bash
##
# Custom functions
# --------------------------------------------------------------------------
##

##
# Provides quick-cd access to the short name of the repo
##
function repo  {
    # Config your source path here
    srcDir="$HOME/src"
    repoDir=''
    relativePath=''
    
    if [ $# -lt 1 -o $# -gt 2 ]; then
        echo "Changes directory to the repository specified, assuming it exists.

Usage:
    $(basename $0) <repo-name> [path]

    repo-name       An abbreviated (or not) name of the repo

    path            (optional) Supply a target path within the repo to switch to.
                    Hint: try passing along `pwd` to jump between the same location
                          in two repositories.
                    e.g. /src/application/config
                         /home/msmartypants/src/my-repo/src/library
"
    else
        # Determine the relative path for later
        if [ $# -eq 2 ]; then
            # Trim any leading slash and/or home dir prefix
            relativePath=`echo "$2" | sed 's!^\(/\|/home/[^/]\+/src/[^/]\+/\)!!'`
        fi

        # Try to match on start of word 1st
        for repo in `ls "$srcDir"`; do
            if [[ "$repo" = $1* ]]; then
                repoDir="$srcDir/$repo"
            fi
        done

        # Fall back to match any part of word 
        for repo in `ls "$srcDir"`; do
            if [[ "$repoDir" = '' && "$repo" = *$1* ]]; then
                repoDir="$srcDir/$repo"
            fi
        done

        if [ "$repoDir" != "" ]; then
            cd "$repoDir"

            # Try to find the path in the repo, if supplied
            if [ -d "$relativePath" ]; then
                cd "$relativePath"
            fi
        else
            echo "No repository like \"$1\" found in \"$srcDir\"."
        fi
    fi
}

################################################################################
# Functions 
################################################################################

function random_line {
        LINES=$( wc -l "$1" | awk '{ print ($1 +1) }' )
        RANDSEED=$( date '+%S%M%I' )
        LINE=$( cat "$1" | awk -v "COUNT=$LINES" -v "SEED=$RANDSEED" 'BEGIN { srand(SEED);i=int(rand()*COUNT) } FNR==i { print $0 }');
        echo "$LINE"
}

function extend_path {
  if [[ $PATH != *:$1* ]]; then
    export PATH="$PATH:$1"
  fi
}

function prepend_path {
  if [[ $PATH != *:$1* ]]; then
    export PATH="$1:$PATH"
  fi
}

function command_exists {
  if command -v "$1" &>/dev/null; then
    return 0
  else
    return 1
  fi
}

function tip {
    echo `random_line "$HOME/.tips"`
}

function mkpmod() {
    mkdir -p "$1/files" "$1/lib" "$1/manifests" "$1/templates" "$1/tests"
}
