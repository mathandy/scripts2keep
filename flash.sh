#!/bin/bash
# script to make terminal flash until any key is pressed

set -e
trap ctrl_c INT

function ctrl_c() {
    printf '\e[?5l'
}

if [ -t 0 ]; then
  SAVED_STTY="`stty -g`"
  stty -echo -icanon -icrnl time 0 min 0
fi

count=0
keypress=''
while [ "x$keypress" = "x" ]; do
    printf '\e[?5h'
    sleep 0.5
    printf '\e[?5l'
    sleep 0.5
    keypress="`cat -v`"
done

if [ -t 0 ]; then stty "$SAVED_STTY"; fi

exit 0
