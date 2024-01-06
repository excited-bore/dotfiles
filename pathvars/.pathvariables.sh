#!/bin/bash
# Tip: Search binaries with 'whereis'
# And check with 'printenv'

# Don't use all variables; some variables will collosally break your terminal 
# TERM
#export TERM=vt100

# TMPDIR
export TMPDIR=/tmp

# DISTRO stuff (Only used by dotfiles)
#export DIST_BASE="Arch"
#export DIST="Manjaro"
#export ARCH="amd64"
#export PM="pacman"
#export WRAPPER="pamac"

# LS_COLORS
#https://unix.stackexchange.com/questions/498482/bash-tab-completion-colors-differ-from-ls-colors
#export LS_COLORS="di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"
# LC_ALL
#export LC_ALL="en_US.UTF-8"

# PAGER
export PAGER=/usr/bin/less

# LESS
export LESS="--CLEAR-SCREEN --redraw-on-quit --LINE-NUMBERS --line-num-width=2 --window=10 --use-color --color=Ng$ --color=Scb$ --color=Pkg$ --IGNORE-CASE --LONG-PROMPT --chop-long-lines --underline-special  --mouse --QUIET --status-line --no-vbell --follow-name --exit-follow-on-close"
#export LESSEDIT=$EDITOR

# MOAR
#export MOAR='--statusbar=bold -colors 256 -render-unprintable highlight'

# EDITORS
export EDITOR=/usr/bin/nvim
export VISUAL=/usr/bin/nvim

# READLINE
export INPUTRC=~/.inputrc

# DISPLAY
#export DISPLAY=":0.0"

# XDG
# https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
# $XDG_CACHE_HOME defines the base directory relative to which user-specific non-essential data files should be stored. If $XDG_CACHE_HOME is either not set or empty, a default equal to $HOME/.cache should be used. 
export XDG_CACHE_HOME=$HOME/.cache
# $XDG_CONFIG_HOME defines the base directory relative to which user-specific configuration files should be stored. If $XDG_CONFIG_HOME is either not set or empty, a default equal to $HOME/.config should be used.
export XDG_CONFIG_HOME=$HOME/.config
#  $XDG_CONFIG_DIRS defines the preference-ordered set of base directories to search for configuration files in addition to the $XDG_CONFIG_HOME base directory. The directories in $XDG_CONFIG_DIRS should be seperated with a colon ':'.
#If $XDG_CONFIG_DIRS is either not set or empty, a value equal to /etc/xdg should be used. 
export XDG_CONFIG_DIRS=/etc/xdg 
# $XDG_DATA_HOME defines the base directory relative to which user-specific data files should be stored. If $XDG_DATA_HOME is either not set or empty, a default equal to $HOME/.local/share should be used. 
export XDG_DATA_HOME=$HOME/.local/share
# $XDG_DATA_DIRS defines the preference-ordered set of base directories to search for data files in addition to the $XDG_DATA_HOME base directory. The directories in $XDG_DATA_DIRS should be seperated with a colon ':'. 
# If $XDG_DATA_DIRS is either not set or empty, a value equal to /usr/local/share/:/usr/share/ should be used. 
export XDG_DATA_DIRS=/usr/local/share/:/usr/share:$FLATPAKS 
# $XDG_STATE_HOME defines the base directory relative to which user-specific state files should be stored. If $XDG_STATE_HOME is either not set or empty, a default equal to $HOME/.local/state should be used. 
export XDG_STATE_HOME=$HOME/.local/state
# $XDG_RUNTIME_DIR defines the base directory relative to which user-specific non-essential runtime files and other file objects (such as sockets, named pipes, ...) should be stored. The directory MUST be owned by the user, and he MUST be the only one having read and write access to it. Its Unix access mode MUST be 0700. 
export XDG_RUNTIME_DIR=/run/user/1000

# SYSTEMD
# https://systemd.io/ENVIRONMENT/
# Pager stuff
export SYSTEMD_PAGER=$PAGER
export SYSTEMD_PAGERSECURE=1
export SYSTEMD_COLORS=256
export SYSTEMD_LESS="FRXMK $LESS --line-num-width=5"

# Either one of (in order of decreasing importance) emerg, alert, crit, err, warning, notice, info, debug, or an integer in the range 0…7
# This can be overridden with --log-level=.
export SYSTEMD_LOG_LEVEL="warning"
# A boolean. If true, messages written to the tty will be colored according to priority.
# This can be overridden with --log-color=.
#export SYSTEMD_LOG_COLOR="true"
# A boolean. If true, console log messages will be prefixed with a timestamp.
# This can be overridden with --log-time=.
export SYSTEMD_LOG_TIME="true"
# A boolean. If true, messages will be prefixed with a filename and line number in the source code where the message originates.
# This can be overridden with --log-location=.
export SYSTEMD_LOG_LOCATION="true"
# A boolean. If true, messages will be prefixed with the current numerical thread ID (TID).
export SYSTEMD_LOG_TID="true"
# The destination for log messages. One of console (log to the attached tty), console-prefixed (log to the attached tty but with prefixes encoding the log level and "facility", see syslog(3), kmsg (log to the kernel circular log buffer), journal (log to the journal), journal-or-kmsg (log to the journal if available, and to kmsg otherwise), auto (determine the appropriate log target automatically, the default), null (disable log output).
# This can be overridden with --log-target=
export SYSTEMD_LOG_TARGET="auto"

# Firefox hardware acceleration driver
#export LIBVA_DRIVER_NAME="mesa"

# PYTHON
#export PYTHONPATH="/usr/bin/python:/usr/bin/python3:/usr/bin/python3.10"
#export PATH="$PATH:$PYTHONPATH"
#export PYTHON_ARGCOMPLETE_OK="True"

# For arch: Also changeable with 'archlinux-java'
# JAVA
#export JAVA_HOME="/usr/lib/jvm/java-17-openjdk/bin"
#export PATH="$JAVA_HOME:$PATH"

# LUA
#export LUA_PATH=""

# GO
#export PATH="/usr/local/go/bin:/usr/bin/go:/usr/lib/go:/usr/share/go:$PATH"

# SNAP
#export PATH="/snap/bin:/var/lib/snapd/snap/bin:$PATH"

# FLATPAK FOR XDG_DATA_HOME AND XDG_DATA_DIRS
#export FLATPAKS="/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share"


# VIM
export MYVIMRC=~/.config/nvim/init.vim
export MYGVIMRC=~/.config/nvim/init.vim

# RANGER
#export RANGER_LOAD_DEFAULT_RC="~/rc.conf"

# RIPGREP
#export RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "

# FZF
#export FZF_DEFAULT_COMMAND='fd --search-path / --type f --hidden --exclude "*.dll *.so.* *.go *.bin"'
#export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# EMACS
#export PATH="~/.emacs.d/bin/:$PATH"

# KITTY
#export KITTY_PATH="~/.local/bin/"
#export PATH="$KITTY_PATH:$PATH"

# NINJA
#export PATH="/usr/bin/ninja:$PATH"

# NIX (apx included)
#export PATH="$HOME/.nix-profile/bin:$PATH"
