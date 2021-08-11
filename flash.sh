#!/bin/bash
# script to make terminal flash until any key is pressed

# credit:
# https://stackoverflow.com/questions/25532773/change-background-color-of-active-or-inactive-pane-in-tmux/33553372#33553372
# 

# check if tmux version is < 2.1
tmux_is_old=$(awk -v n1="$(tmux -V| cut -d' ' -f2)" -v n2="2.1" 'BEGIN {printf (n1<n2?"1":"0")}')

if [ $tmux_is_old ]; then
    tmux_default=$(tmux show-options -g pane-border-style| cut -d' ' -f2)
else
    # NOTE -- I'm not sure how to retrieve the current setting, please help
    tmux_default=default
fi

flashon () {
    if [[ "$TERM" =~ "screen".* ]]; then
        if [ $tmux_is_old ]; then
            tmux set -g pane-border-style 'fg=colour235,bg=colour200' > /dev/null 2>&1
        else
            tmux select-pane -P 'fg=blue,bg=green' > /dev/null 2>&1
        fi
    else 
        printf '\e[?5h'
    fi
}
flashoff () {
    if [[ "$TERM" =~ "screen".* ]]; then 
        if [ $tmux_is_old ]; then
            tmux set -g pane-border-style "$tmux_default" > /dev/null 2>&1
        else
            tmux select-pane -P "$tmux_default"
        fi
    else 
        printf '\e[?5l'
    fi
}

set -e
trap ctrl_c INT

function ctrl_c() {
    flashoff
}

if [ -t 0 ]; then
  SAVED_STTY="`stty -g`"
  stty -echo -icanon -icrnl time 0 min 0
fi

count=0
keypress=''
while [ "x$keypress" = "x" ]; do
    flashon
    sleep 0.5
    flashoff
    sleep 0.5
    keypress="`cat -v`"
done

if [ -t 0 ]; then stty "$SAVED_STTY"; fi

exit 0
