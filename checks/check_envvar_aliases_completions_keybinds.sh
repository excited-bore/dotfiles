if ! grep -q "/usr/share/bash-completion/bash_completion" ~/.bashrc; then
    echo "[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion" >>~/.bashrc
fi

if ! [[ -d ~/.aliases.d/ ]]; then
    mkdir ~/.aliases.d/
fi

if ! [[ -f ~/.bash_aliases ]]; then
    if [[ -f aliases/.bash_aliases ]]; then
        cp aliases/.bash_aliases ~/
    else
        wget -O ~/.bash_aliases https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases 
    fi
fi

if ! [[ -d ~/.bash_completion.d/ ]]; then
    mkdir ~/.bash_completion.d/
fi

if ! [ -f ~/.bash_completion ]; then
    if [ -f completions/.bash_completion ]; then
        cp completions/.bash_completion ~/
    else
        wget -O ~/.bash_completion https://raw.githubusercontent.com/excited-bore/dotfiles/main/completions/.bash_completion
    fi
fi

if ! [ -d ~/.keybinds.d/ ]; then
    mkdir ~/.keybinds.d/
fi

if ! [ -f ~/.keybinds ]; then
    if [ -f keybinds/.keybinds ]; then
        cp keybinds/.keybinds ~/
    else
        wget -O ~/.keybinds https://raw.githubusercontent.com/excited-bore/dotfiles/main/keybinds/.keybinds
    fi
fi

# Best to source this at start of ~/.bashrc
if [ -f ~/.environment.env ] && ! grep -q "~/.environment.env" ~/.bashrc; then
    sed -i '1s/^/\[ -f ~\/.environment.env \] \&\& source ~\/.environment.env\n\n/' ~/.bashrc 
fi

if ! grep -q "~/.bash_completion" ~/.bashrc; then
    if grep -q "~/.bash_aliases" ~/.bashrc; then
        sed -i 's|\(\[ -f ~/.bash_aliases \] && source ~/.bash_aliases\)|\[ -f \~/.bash_completion \] \&\& source \~/.bash_completion\n\1\n|g' ~/.bashrc
    else
        printf "\n[ -f ~/.bash_completion ] && source ~/.bash_completion\n\n" >>~/.bashrc
    fi
fi

if ! grep -q "~/.bash_aliases" ~/.bashrc; then
    printf "\n[ -f ~/.bash_aliases ] && source ~/.bash_aliases\n\n" >>~/.bashrc
    if grep -q "complete -F _complete_alias" ~/.bashrc; then
        sed -i '/complete -F _complete_alias "${!BASH_ALIASES\[@\]}"/d' ~/.bashrc
    fi
fi

if ! grep -q "~/.keybinds" ~/.bashrc; then
    printf "\n[ -f ~/.keybinds ] && source ~/.keybinds\n\n" >>~/.bashrc
fi

# I put this here from unused install_fzf code because I hate composing sed commands like these again
#if grep -q "[ -f ~/.bash_aliases ]" ~/.bashrc; then
#        sed -i 's|\[ -f \~/.fzf.bash \] \&\& source \~/.fzf.bash||g' ~/.bashrc
#        sed -i 's|\(\[ -f ~/.bash_aliases \] && source ~/.bash_aliases\)|\[ -f \~/.fzf.bash \] \&\& source \~/.fzf.bash\n\1\n|g' ~/.bashrc
#    fi
#    if grep -q "[ -f ~/.keybinds ]" ~/.bashrc; then
#        sed -i 's|\[ -f \~/.fzf.bash \] \&\& source \~/.fzf.bash||g' ~/.bashrc
#        sed -i 's|\(\[ -f ~/.keybinds \] \&\& source ~/.keybinds\)|\[ -f \~/.fzf.bash \] \&\& source \~/.fzf.bash\n\1\n|g' ~/.bashrc
#    elif grep -q "[ -f ~/.bash_completion ]" ~/.bashrc; then
#        sed -i 's|\[ -f \~/.fzf.bash \] \&\& source \~/.fzf.bash||g' ~/.bashrc
#        sed -i 's|\(\[ -f ~/.bash_completion \] \&\& source \~/.bash_completion\)|\[ -f \~/.fzf.bash \] \&\& source \~/.fzf.bash\n\1\n|g' ~/.bashrc
#    fi
#    if grep -q "complete -F _complete_alias" ~/.bashrc; then
#        sed -i '/complete -F _complete_alias "${!BASH_ALIASES\[@\]}"/d' ~/.bashrc
#        sed -i 's|\(\[ -f \~/.fzf.bash \] \&\& source \~/.fzf.bash\)|\1\n\ncomplete -F _complete_alias "${!BASH_ALIASES\[@\]}"\n|g' ~/.bashrc
#    fi
#

#if ! grep -q "shopt -s expand_aliases" ~/.bashrc; then
#    echo "shopt -s expand_aliases" >> ~/.bashrc
#fi
#
#if ! grep -q "~/.aliases.d" ~/.bashrc; then
#
#    echo "if [ -d ~/.aliases.d/ ] && [ \"\$(ls -A ~/.aliases.d/)\" ]; then" >> ~/.bashrc
#    echo "  for alias in ~/.aliases.d/*.sh; do" >> ~/.bashrc
#    echo "      . \"\$alias\" " >> ~/.bashrc
#    echo "  done" >> ~/.bashrc
#    echo "fi" >> ~/.bashrc
#fi

echo "This next $(tput setaf 1)sudo$(tput sgr0) is checks for the envvar, bash_alias, bash_completion and keybind files and dirs in '/root/'."

if [ -f /root/.environment.env ] && ! grep -q "~/.environment.env" /root/.bashrc; then
    printf "\n[ -f ~/.environment.env ] && source ~/.environment.env\n\n" | sudo tee -a /root/.bashrc &>/dev/null
    printf "Added '[ -f ~/.environment.env ] && source ~/.environment.env' to /root/.bashrc\n"
fi

if ! sudo [ -f /root/.bash_aliases ]; then
    echo "Next $(tput setaf 1)sudo$(tput sgr0) will install '.aliases.d' in /root and source files in it with '/root/.bash_aliases' "
    sudo cp ~/.bash_aliases /root/
    if ! sudo [ -d /root/.aliases.d/ ]; then
        sudo mkdir /root/.aliases.d/
        #sudo cp ~/.aliases.d/check_system.sh /root/.aliases.d/check_system.sh
        #sudo cp ~/.aliases.d/bash.sh /root/.aliases.d/bash.sh
        #sudo cp ~/.aliases.d/00-rlwrap_scripts.sh /root/.aliases.d/00-rlwrap_scripts.sh
    fi
    if ! sudo grep -q "~/.bash_aliases" ~/.bashrc; then
        printf "\n[ -f ~/.bash_aliases ] && source ~/.bash_aliases\n\n" | sudo tee -a /root/.bashrc &>/dev/null
        if sudo grep -q "complete -F _complete_alias" /root/.bashrc; then
            sudo sed -i '/complete -F _complete_alias "${!BASH_ALIASES\[@\]}"/d' /root/.bashrc
        fi
    fi
fi

if ! sudo [ -f /root/.bash_completion ]; then
    echo "Next $(tput setaf 1)sudo$(tput sgr0) will install '.bash_completion.d' in /root and source files in it with '/root/.bash_completion"
    if ! sudo [ -f /root/.bash_completion ]; then
        if ! [ -f completions/.bash_completion ]; then
            sudo wget -O /root/.bash_aliases https://raw.githubusercontent.com/excited-bore/dotfiles/main/completions/.bash_completion
        else
            sudo cp completions/.bash_completion /root/
        fi
    fi
    if ! sudo [ -d /root/.bash_completion.d/ ]; then
        sudo mkdir /root/.bash_completion.d/
    fi

    if ! sudo grep -q "~/.bash_completion" /root/.bashrc; then
        if sudo grep -q "~/.bash_aliases" /root/.bashrc; then
            sudo sed -i 's|\(\[ -f ~/.bash_aliases \] && source ~/.bash_aliases\)|\[ -f \~/.bash_completion \] \&\& source \~/.bash_completion\n\1\n|g' /root/.bashrc &>/dev/null
        else
            printf "\n[ -f ~/.bash_completion ] && source ~/.bash_completion\n\n" | sudo tee -a /root/.bashrc &>/dev/null
        fi
    fi
fi

if ! sudo [ -f /root/.keybinds ]; then
    echo "Next $(tput setaf 1)sudo$(tput sgr0) will install '.keybinds.d' in /root and source files in it with '/root/.keybinds"
    if ! [ -f /root/.keybinds ]; then
        if ! [ -f keybinds/.keybinds ]; then
            sudo wget -O /root/.bash_aliases https://raw.githubusercontent.com/excited-bore/dotfiles/main/keybinds/.keybinds
        else
            sudo cp keybinds/.keybinds /root/
        fi
    fi
    if ! sudo [ -d /root/.keybinds.d/ ]; then
        sudo mkdir /root/.keybinds.d/
    fi
    if ! sudo grep -q "~/.keybinds" /root/.bashrc; then
        printf "\n[ -f ~/.keybinds/ ] && source ~/.keybinds\n" | sudo tee -a /root/.bashrc &>/dev/null
    fi
fi

# Check one last time if ~/.bash_preexec - for both $USER and root - is the last line in their ~/.bash_profile and ~/.bashrc

if ! [ -f ./checks/check_bash_source_order.sh ]; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_bash_source_order.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_bash_source_order.sh)
    fi
else
    . ./checks/check_bash_source_order.sh
fi

# VARS

if ! [ -f ~/.profile ]; then
    touch ~/.profile
fi

if [ -z $ENV ]; then
    if [ -f ~/.environment.env ]; then
        export ENV=~/.environment.env  
    else
        export ENV=~/.profile
    fi
fi

if [ -z $BASH_ENV ]; then 
    if [ -f ~/.environment.env ]; then
        export BASH_ENV=~/.environment.env
    elif [ -f ~/.bash_profile ]; then 
        export BASH_ENV=~/.bash_profile
    else
        export BASH_ENV=~/.profile
    fi
fi

if [ -f ~/.zshenv ]; then
    export ZSH_ENV=~/.zshenv
elif [ -f ~/.environment.env ]; then
    export ZSH_ENV=~/.environment.env
elif [ -f ~/.zprofile ]; then
    export ZSH_ENV=~/.zprofile
fi

export BASH_ALIAS=~/.bashrc

if [ -f ~/.bash_aliases ]; then
    export BASH_ALIAS=~/.bash_aliases
fi

if [ -d ~/.aliases.d/ ]; then
    export BASH_ALIAS_FILEDIR=~/.aliases.d/
fi

export BASH_COMPLETION=~/.bashrc

if [ -f ~/.bash_completion ]; then
    export BASH_COMPLETION=~/.bash_completion
fi

if [ -d ~/.bash_completion.d/ ]; then
    export BASH_COMPLETION_FILEDIR=~/.bash_completion.d/
fi

export BASH_KEYBIND=~/.bashrc

if [ -f ~/.keybinds ]; then
    export BASH_KEYBIND=~/.keybinds
fi

if [ -d ~/.keybinds.d/ ]; then
    export BASH_KEYBIND_FILEDIR=~/.keybinds.d/
fi

echo "These next $(tput setaf 1)sudo's$(tput sgr0) checks for the profile, environment, bash_alias, bash_completion and keybind files and dirs in '/root/' to generate global variables.";

export ENV_R=/root/.profile
export BASH_ENV_R=/root/.profile
export BASH_ALIAS_R=/root/.bashrc
export BASH_COMPLETION_R=/root/.bashrc
export BASH_KEYBIND_R=/root/.bashrc

if ! sudo [ -f /root/.profile ]; then
    sudo touch /root/.profile
fi

if sudo [ -f /root/.environment.env ]; then
    export ENV_R=/root/.environment.env  
else
    export ENV_R=/root/.profile
fi

if sudo [ -f /root/.environment.env ]; then
    export BASH_ENV_R=/root/.environment.env
elif sudo [ -f /root/.bash_profile ]; then
    export BASH_ENV_R=/root/.bash_profile
else
    export BASH_ENV_R=/root/.profile
fi

if sudo [ -f /root/.zshenv ]; then
    export ZSH_ENV_R=/root/.zshenv
elif sudo [ -f /root/.environment.env ]; then
    export ZSH_ENV_R=/root/.environment.env
elif sudo [ -f /root/.zprofile ]; then
    export ZSH_ENV_R=/root/.zprofile
fi

if sudo [ -f /root/.bash_aliases ]; then
    export BASH_ALIAS_R=/root/.bash_aliases
fi

if sudo [ -d /root/.aliases.d/ ]; then
    export BASH_ALIAS_FILEDIR_R=/root/.aliases.d/
fi

if sudo [ -f /root/.bash_completion ]; then
    export BASH_COMPLETION_R=/root/.bash_completion
fi

if sudo [ -d /root/.bash_completion.d/ ]; then
    export BASH_COMPLETION_FILEDIR_R=/root/.bash_completion.d/
fi

if sudo [ -f /root/.keybinds ]; then
    export BASH_KEYBIND_R=/root/.keybinds
fi

if sudo [ -d /root/.keybinds.d/ ]; then
    export BASH_KEYBIND_FILEDIR_R=/root/.keybindsd.d/
fi
