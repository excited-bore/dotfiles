# !/bin/bash

ENVVAR=~/.bashrc

if [ -f ~/.environment.env ]; then
    ENVVAR=~/.environment.env
fi

ALIAS=~/.bashrc

if [ -f ~/.bash_aliases ]; then
    ALIAS=~/.bash_aliases
fi

if [ -d ~/.bash_aliases.d/ ]; then
    ALIAS_FILEDIR=~/.bash_aliases.d/
fi


COMPLETION=~/.bashrc

if [ -f ~/.bash_completion ]; then
    COMPLETION==~/.bash_completion
fi

if [ -d ~/.bash_completion.d/ ]; then
    COMPLETION_FILEDIR=~/.bash_completion.d/
fi


KEYBIND=~/.bashrc

if [ -f ~/.keybinds ]; then
    KEYBIND=~/.keybinds
fi

if [ -d ~/.keybinds.d/ ]; then
    KEYBIND_FILEDIR=~/.keybinds.d/
fi

ALIAS_R=/root/.bashrc
COMPLETION_R=/root/.bashrc
KEYBIND_R=/root/.bashrc
ENVVAR_R=/root/.bashrc

echo "This next $(tput setaf 1)sudo$(tput sgr0) checks for the envvariable, bash_alias, bash_completion and keybind files and dirs in '/root/' to generate global variables.";

if sudo test -f /root/.environment.env; then
    ENVVAR_R=/root/.environment.env
fi

if sudo test -f /root/.bash_aliases; then
    ALIAS_R=/root/.bash_aliases
fi
if sudo test -d /root/.bash_aliases.d/; then
    ALIAS_FILEDIR_R=/root/.bash_aliases.d/
fi

if sudo test -f /root/.bash_completion; then
    COMPLETION_R=/root/.bash_completion
fi

if sudo test -d /root/.bash_completion.d/; then
    COMPLETION_FILEDIR_R=/root/.bash_completion.d/
fi
if sudo test -f /root/.keybinds  ; then
    KEYBIND_R=/root/.keybinds
fi

if sudo test -d /root/.keybinds.d/  ; then
    KEYBIND_FILEDIR_R=/root/.keybindsd.d/
fi
