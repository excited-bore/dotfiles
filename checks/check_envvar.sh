# !/bin/bash

export PROFILE=~/.profile

if test -f ~/.bash_profile; then
    export PROFILE=~/.bash_profile
fi

if ! test -f $PROFILE; then
    touch $PROFILE
fi

export ENVVAR=~/.bashrc

if [ -f ~/.environment.env ]; then
    export ENVVAR=~/.environment.env
fi

export ALIAS=~/.bashrc

if [ -f ~/.bash_aliases ]; then
    export ALIAS=~/.bash_aliases
fi

if [ -d ~/.bash_aliases.d/ ]; then
    export ALIAS_FILEDIR=~/.bash_aliases.d/
fi


export COMPLETION=~/.bashrc

if [ -f ~/.bash_completion ]; then
    export COMPLETION=~/.bash_completion
fi

if [ -d ~/.bash_completion.d/ ]; then
    export COMPLETION_FILEDIR=~/.bash_completion.d/
fi


export KEYBIND=~/.bashrc

if [ -f ~/.keybinds ]; then
   export KEYBIND=~/.keybinds
fi

if [ -d ~/.keybinds.d/ ]; then
    export KEYBIND_FILEDIR=~/.keybinds.d/
fi

export PROFILE_R=/root/.profile
export ALIAS_R=/root/.bashrc
export COMPLETION_R=/root/.bashrc
export KEYBIND_R=/root/.bashrc
export ENVVAR_R=/root/.bashrc

echo "This next $(tput setaf 1)sudo$(tput sgr0) checks for the profile, environment, bash_alias, bash_completion and keybind files and dirs in '/root/' to generate global variables.";

if sudo test -f /root/.bash_profile; then
    export PROFILE_R=/root/.bash_profile
fi

if ! sudo test -f $PROFILE_R; then
    sudo touch $PROFILE_R
fi

if sudo test -f /root/.environment.env; then
    export ENVVAR_R=/root/.environment.env
fi

if sudo test -f /root/.bash_aliases; then
    export ALIAS_R=/root/.bash_aliases
fi
if sudo test -d /root/.bash_aliases.d/; then
    export ALIAS_FILEDIR_R=/root/.bash_aliases.d/
fi

if sudo test -f /root/.bash_completion; then
    export COMPLETION_R=/root/.bash_completion
fi

if sudo test -d /root/.bash_completion.d/; then
    export COMPLETION_FILEDIR_R=/root/.bash_completion.d/
fi
if sudo test -f /root/.keybinds  ; then
    export KEYBIND_R=/root/.keybinds
fi

if sudo test -d /root/.keybinds.d/  ; then
    export KEYBIND_FILEDIR_R=/root/.keybindsd.d/
fi
