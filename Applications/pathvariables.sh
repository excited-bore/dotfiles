#!/bin/bash
# Tip: Search binaries with 'whereis'
# And check with 'printenv'

# Shamelessly stolen from manjaro /etc/profile
# Alternative to export PATH:$PATH
append_path() {
    case ":$PATH:" in
        *:"$1":*)
            ;;
        *)
            PATH="${PATH:+$PATH:}$1"
    esac
}

#https://unix.stackexchange.com/questions/498482/bash-tab-completion-colors-differ-from-ls-colors
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'
export MOAR='--statusbar=bold -colors 256 -render-unprintable highlight'
export PAGER=/usr/local/bin/moar
export SYSTEMD_PAGERSECURE=1
export SYSTEMD_PAGER=$PAGER
export SYSTEMD_COLORS=256
# export SYSTEMD_LESS="FRXMK"

#Don't use or do this 
#export TERM=vt100
 
#export LC_ALL="en_US.UTF-8"
export DISPLAY=":0.0"
export EDITOR="nvim"
#export VISUAL="/usr/bin/code --unity-launch %F"
export VISUAL="nvim"

#Custom variable
export LINE_TPUT=0

export INPUTRC='~/.inputrc'
export RANGER_LOAD_DEFAULT_RC="~/rc.conf"

# Firefox hardware acceleration driver
export LIBVA_DRIVER_NAME="mesa"
export TMPDIR=/tmp


# VIM
export MYVIMRC=".config/nvim/init.vim"
export MYGVIMRC=".config/nvim/init.vim"

# EMACS
append_path '~/.emacs.d/bin/'

# KITTY
export KITTY_PATH=~/.local/bin/
append_path $KITTY_PATH

# PYTHON
export PYTHONPATH='/usr/bin/python:/usr/bin/python3:/usr/bin/python3.10'
append_path $PYTHONPATH
export PYTHON_ARGCOMPLETE_OK="True"

# JAVA
# For arch: Also changeable with 'archlinux-java'
export JAVA_HOME='/usr/lib/jvm/java-17-openjdk/bin'
append_path $JAVA_HOME

# LUA
export LUA_PATH=""

# GO
append_path '/usr/local/go/bin:/usr/bin/go:/usr/lib/go:/usr/share/go'
GOPATH=$HOME/go

# NINJA
append_path '/usr/bin/ninja'


# NIX (also for apx)
export PATH=$PATH:$HOME/.nix-profile/bin

# SNAP
append_path '/snap/bin:/var/lib/snapd/snap/bin'

# SYSTEMD 
# FLATPAK FOR XDG_DATA_HOME AND XDG_DATA_DIRS

FLATPAKS=/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share

export XDG_DATA_HOME=$HOME/.local/share
# $XDG_DATA_HOME defines the base directory relative to which user-specific data files should be stored. If $XDG_DATA_HOME is either not set or empty, a default equal to $HOME/.local/share should be used. 
export XDG_DATA_DIRS=/usr/local/share/:/usr/share:$FLATPAKS 
# $XDG_DATA_DIRS defines the preference-ordered set of base directories to search for data files in addition to the $XDG_DATA_HOME base directory. The directories in $XDG_DATA_DIRS should be seperated with a colon ':'. 
# If $XDG_DATA_DIRS is either not set or empty, a value equal to /usr/local/share/:/usr/share/ should be used. 
export XDG_CONFIG_HOME=$HOME/.config
# $XDG_CONFIG_HOME defines the base directory relative to which user-specific configuration files should be stored. If $XDG_CONFIG_HOME is either not set or empty, a default equal to $HOME/.config should be used.
export XDG_CONFIG_DIRS=/etc/xdg 
#  $XDG_CONFIG_DIRS defines the preference-ordered set of base directories to search for configuration files in addition to the $XDG_CONFIG_HOME base directory. The directories in $XDG_CONFIG_DIRS should be seperated with a colon ':'.
#If $XDG_CONFIG_DIRS is either not set or empty, a value equal to /etc/xdg should be used. 
export XDG_STATE_HOME=$HOME/.local/state
# $XDG_STATE_HOME defines the base directory relative to which user-specific state files should be stored. If $XDG_STATE_HOME is either not set or empty, a default equal to $HOME/.local/state should be used. 
export XDG_CACHE_HOME=$HOME/.cache
# $XDG_CACHE_HOME defines the base directory relative to which user-specific non-essential data files should be stored. If $XDG_CACHE_HOME is either not set or empty, a default equal to $HOME/.cache should be used. 
export XDG_RUNTIME_DIR=/run/user/1000
# $XDG_RUNTIME_DIR defines the base directory relative to which user-specific non-essential runtime files and other file objects (such as sockets, named pipes, ...) should be stored. The directory MUST be owned by the user, and he MUST be the only one having read and write access to it. Its Unix access mode MUST be 0700. 

# Either one of (in order of decreasing importance) emerg, alert, crit, err, warning, notice, info, debug, or an integer in the range 0…7
# This can be overridden with --log-level=.
export SYSTEMD_LOG_LEVEL="warning"
# A boolean. If true, messages written to the tty will be colored according to priority.
# This can be overridden with --log-color=.
export SYSTEMD_LOG_COLOR="true"
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
