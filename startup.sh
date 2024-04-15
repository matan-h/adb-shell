# this file should be in "/sdcard/.adb/startup.sh"
# shellcheck shell=ksh
ENABLE_EXPERIMENTAL_HISTORY=false # Set to true to enable the experimental history workaround

# basic:
# shellcheck disable=SC2164
cd "${OLDPWD:-$HOME}" # always start from $OLDPWD or $HOME

## keys
bind '^L=clear-screen' # ctrl+l => clear screen
bind '^XA=search-history-up' # up-arrow => zsh-like search
# color config
alias ls='ls --color=auto'

## prompt
RED=$'\E[1;31m'
GREEN=$'\E[0;32m'
BLUE=$'\E[1;32m'
DARKBLUE=$'\E[1;36m'
ESC=$'\E[0m'
if [ ! "$USER" ]; then
  USER="$(logname)"
fi

if [ ! "$HOSTNAME" ]; then
  HOSTNAME="$(hostname -s)"
fi
# shellcheck disable=SC2025
# make the prompt 'user@hostname:$PWD' when user is green by default and red on errors.

PS1="\$(if [ \$? -ne 0 ]; then print '$RED';else print '$GREEN';fi)$USER$BLUE@$HOSTNAME$ESC:$DARKBLUE\$PWD$ESC\$ " # the start is red if the last exit code is not 0.

## fix common mistakes and typos
alias sl="ls"
alias "cd.."="cd .."
alias ".."="cd .."

# shortcuts
alias l="ls"
alias ll="ls -lh"
alias la="ls -lAh"

alias rd="rmdir"
alias md="mkdir"

alias cls="clear" # from windows
alias mkdirs="mkdir -pv" # Create directories recursively with verbose
alias rmtree="rm -r" # remove folder recursively
alias untar="tar -xvf" # see xkcd:1168:tar

# mksh fixing: readline options can make multi-line editing glitches
_vi(){
    set +o emacs +o vi-tabcomplete
    vi "$@"
    set -o emacs -o vi-tabcomplete
}

alias vi=_vi

# CD ENV : search in the popular folders before error not found
CDPATH=":/sdcard:/sdcard/Android/data:/"



# a function to help users find the local ip (from gh:omz/sysadmin plugin)
myip(){
if [ -x "$(command -v 'ip')" ]; then
    ip addr | awk '/inet /{print $2}' | grep -v 127.0.0.1
  else
    ifconfig | awk '/inet /{print $2}' | grep -v 127.0.0.1
  fi
}
if [ "$ENABLE_EXPERIMENTAL_HISTORY" = true ]; then
  # experimental history workaround (its disabled by default in mksh for android. see android.stackexchange:152061 mirabilos answer)
  HISTFILE="$HOME/.adb/.history"
  # "print -s": print to the history file, which doesn't exist. This allows the shell history features.
  if [ -f "$HISTFILE" ] ; then
    while read -r p; do print -s "$p"; done < "$HISTFILE"
  fi

  add_to_history(){
    # fc -ln -1: get the last command from history without numbers.
    last_command=$(fc -ln -1 2> /dev/null)||return

    last_line=$(tail -n 1 "$HISTFILE" 2>/dev/null || true)
    if [ "$last_command" != "$last_line" ]; then
          # Append the last command to the file
          echo "$last_command" >> "$HISTFILE"
      else
          return
      fi
  }
  PS1="$PS1\$(add_to_history)";
fi