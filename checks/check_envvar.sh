# VARS

if ! test -f ~/.profile; then
    touch ~/.profile
fi

if test -z $ENV; then
    if test -f ~/.environment; then
        export ENV=~/.environment  
    else
        export ENV=~/.profile
    fi
fi

if test -z $BASH_ENV; then 
    if test -f ~/.environment; then
        export BASH_ENV=~/.environment
    elif test -f ~/.bash_profile; then 
        export BASH_ENV=~/.bash_profile
    else
        export BASH_ENV=~/.profile
    fi
fi

if test -f ~/.zshenv; then
    export ZSH_ENV=~/.zshenv
elif test -f ~/.environment; then
    export ZSH_ENV= ~/.environment
elif test -f ~/.zprofile; then
    export ZSH_ENV=~/.zprofile
fi

export BASH_ALIAS=~/.bashrc

if test -f ~/.bash_aliases; then
    export BASH_ALIAS=~/.bash_aliases
fi

if test -d ~/.bash_aliases.d/; then
    export BASH_ALIAS_FILEDIR=~/.bash_aliases.d/
fi

export BASH_COMPLETION=~/.bashrc

if test -f ~/.bash_completion; then
    export BASH_COMPLETION=~/.bash_completion
fi

if test -d ~/.bash_completion.d/; then
    export BASH_COMPLETION_FILEDIR=~/.bash_completion.d/
fi

export BASH_KEYBIND=~/.bashrc

if test -f ~/.keybinds; then
    export BASH_KEYBIND=~/.keybinds
fi

if test -d ~/.keybinds.d/; then
    export BASH_KEYBIND_FILEDIR=~/.keybinds.d/
fi

echo "These next $(tput setaf 1)sudo's$(tput sgr0) checks for the profile, environment, bash_alias, bash_completion and keybind files and dirs in '/root/' to generate global variables.";

export ENV_R=/root/.profile
export BASH_ENV_R=/root/.profile
export BASH_ALIAS_R=/root/.bashrc
export BASH_COMPLETION_R=/root/.bashrc
export BASH_KEYBIND_R=/root/.bashrc

if ! sudo test -f /root/.profile; then
    sudo touch /root/.profile
fi

if sudo test -f /root/.environment; then
    export ENV_R=/root/.environment  
else
    export ENV_R=/root/.profile
fi

if sudo test -f /root/.environment; then
    export BASH_ENV_R=/root/.environment
elif sudo test -f /root/.bash_profile; then
    export BASH_ENV_R=/root/.bash_profile
else
    export BASH_ENV_R=/root/.profile
fi

if sudo test -f /root/.zshenv; then
    export ZSH_ENV_R=/root/.zshenv
elif sudo test -f /root/.environment; then
    export ZSH_ENV_R= /root/.environment
elif sudo test -f /root/.zprofile; then
    export ZSH_ENV_R=/root/.zprofile
fi

if sudo test -f /root/.bash_aliases; then
    export BASH_ALIAS_R=/root/.bash_aliases
fi

if sudo test -d /root/.bash_aliases.d/; then
    export BASH_ALIAS_FILEDIR_R=/root/.bash_aliases.d/
fi

if sudo test -f /root/.bash_completion; then
    export BASH_COMPLETION_R=/root/.bash_completion
fi

if sudo test -d /root/.bash_completion.d/; then
    export BASH_COMPLETION_FILEDIR_R=/root/.bash_completion.d/
fi

if sudo test -f /root/.keybinds; then
    export BASH_KEYBIND_R=/root/.keybinds
fi

if sudo test -d /root/.keybinds.d/; then
    export BASH_KEYBIND_FILEDIR_R=/root/.keybindsd.d/
fi
