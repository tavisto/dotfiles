#!/bin/bash
##
# Custom functions
# --------------------------------------------------------------------------
##

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

function weather() {
    curl http://wttr.in
}
