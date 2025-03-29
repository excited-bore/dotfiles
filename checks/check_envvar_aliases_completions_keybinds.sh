#!/usr/bin/env bash


if ! grep -q "/usr/share/bash-completion/bash_completion" ~/.bashrc; then
    echo "[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion" >>~/.bashrc
fi

if ! test -d ~/.bash_aliases.d/; then
    mkdir ~/.bash_aliases.d/
fi

if ! test -f ~/.bash_aliases; then
    if test -f aliases/.bash_aliases; then
        cp -fv aliases/.bash_aliases ~/
    else
        curl -o ~/.bash_aliases https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases
    fi
fi

if ! test -d ~/.bash_completion.d/; then
    mkdir ~/.bash_completion.d/
fi

if ! test -f ~/.bash_completion; then
    if test -f completions/.bash_completion; then
        cp -fv completions/.bash_completion ~/
    else
        curl -o ~/.bash_completion https://raw.githubusercontent.com/excited-bore/dotfiles/main/completions/.bash_completion
    fi
fi

if ! test -d ~/.keybinds.d/; then
    mkdir ~/.keybinds.d/
fi

if ! test -f ~/.keybinds; then
    if test -f keybinds/.keybinds; then
        cp -fv keybinds/.keybinds ~/
    else
        curl -o ~/.keybinds https://raw.githubusercontent.com/excited-bore/dotfiles/main/keybinds/.keybinds
    fi
fi

if test -f ~/.environment.env && ! grep -q "~/.environment.env" ~/.bashrc; then
    printf "\n[ -f ~/.environment.env ] && source ~/.environment.env\n\n" >>~/.bashrc
fi

if ! grep -q "~/.keybinds" ~/.bashrc; then
    printf "\n[ -f ~/.keybinds ] && source ~/.keybinds\n\n" >>~/.bashrc
fi

if ! grep -q "~/.bash_aliases" ~/.bashrc; then
    printf "\n[ -f ~/.bash_aliases ] && source ~/.bash_aliases\n\n" >>~/.bashrc
    if grep -q "complete -F _complete_alias" ~/.bashrc; then
        sed -i '/complete -F _complete_alias "${!BASH_ALIASES\[@\]}"/d' ~/.bashrc
    fi
fi

if ! grep -q "~/.bash_completion" ~/.bashrc; then
    if grep -q "~/.bash_aliases" ~/.bashrc; then
        sed -i 's|\(\[ -f ~/.bash_aliases \] && source ~/.bash_aliases\)|\[ -f \~/.bash_completion \] \&\& source \~/.bash_completion\n\1\n|g' ~/.bashrc
    else
        printf "\n[ -f ~/.bash_completion ] && source ~/.bash_completion\n\n" >>~/.bashrc
    fi
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
#if ! grep -q "~/.bash_aliases.d" ~/.bashrc; then
#
#    echo "if [ -d ~/.bash_aliases.d/ ] && [ \"\$(ls -A ~/.bash_aliases.d/)\" ]; then" >> ~/.bashrc
#    echo "  for alias in ~/.bash_aliases.d/*.sh; do" >> ~/.bashrc
#    echo "      . \"\$alias\" " >> ~/.bashrc
#    echo "  done" >> ~/.bashrc
#    echo "fi" >> ~/.bashrc
#fi

echo "This next $(tput setaf 1)sudo$(tput sgr0) is checks for the envvar, bash_alias, bash_completion and keybind files and dirs in '/root/'."

if test -f /root/.environment.env && ! grep -q "~/.environment.env" /root/.bashrc; then
    printf "\n[ -f ~/.environment.env ] && source ~/.environment.env\n\n" | sudo tee -a /root/.bashrc &>/dev/null
    printf "Added '[ -f ~/.environment.env ] && source ~/.environment.env' to /root/.bashrc\n"
fi

if ! sudo test -f /root/.bash_aliases; then
    echo "Next $(tput setaf 1)sudo$(tput sgr0) will install '.bash_aliases.d' in /root and source files in it with '/root/.bash_aliases' "
    sudo cp -fv ~/.bash_aliases /root/
    if ! sudo test -d /root/.bash_aliases.d/; then
        sudo mkdir /root/.bash_aliases.d/
        #sudo cp -fv ~/.bash_aliases.d/check_system.sh /root/.bash_aliases.d/check_system.sh
        #sudo cp -fv ~/.bash_aliases.d/bash.sh /root/.bash_aliases.d/bash.sh
        #sudo cp -fv ~/.bash_aliases.d/00-rlwrap_scripts.sh /root/.bash_aliases.d/00-rlwrap_scripts.sh
    fi
    if ! sudo grep -q "~/.bash_aliases" ~/.bashrc; then
        printf "\n[ -f ~/.bash_aliases ] && source ~/.bash_aliases\n\n" | sudo tee -a /root/.bashrc &>/dev/null
        if sudo grep -q "complete -F _complete_alias" /root/.bashrc; then
            sudo sed -i '/complete -F _complete_alias "${!BASH_ALIASES\[@\]}"/d' /root/.bashrc
        fi
    fi
fi

if ! sudo test -f /root/.bash_completion; then
    echo "Next $(tput setaf 1)sudo$(tput sgr0) will install '.bash_completion.d' in /root and source files in it with '/root/.bash_completion"
    if ! sudo test -f /root/.bash_completion; then
        if ! test -f completions/.bash_completion; then
            sudo curl -o /root/.bash_aliases https://raw.githubusercontent.com/excited-bore/dotfiles/main/completions/.bash_completion
        else
            sudo cp -fv completions/.bash_completion /root/
        fi
    fi
    if ! sudo test -d /root/.bash_completion.d/; then
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

if ! sudo test -f /root/.keybinds; then
    echo "Next $(tput setaf 1)sudo$(tput sgr0) will install '.keybinds.d' in /root and source files in it with '/root/.keybinds"
    if ! test -f /root/.keybinds; then
        if ! test -f keybinds/.keybinds; then
            sudo curl -o /root/.bash_aliases https://raw.githubusercontent.com/excited-bore/dotfiles/main/keybinds/.keybinds
        else
            sudo cp -fv keybinds/.keybinds /root/
        fi
    fi
    if ! sudo test -d /root/.keybinds.d/; then
        sudo mkdir /root/.keybinds.d/
    fi
    if ! sudo grep -q "~/.keybinds" /root/.bashrc; then
        printf "\n[ -f ~/.keybinds/ ] && source ~/.keybinds\n" | sudo tee -a /root/.bashrc &>/dev/null
    fi
fi

export PROFILE=~/.profile
export ENVVAR=~/.bashrc
export ALIAS=~/.bashrc
export COMPLETION=~/.bashrc
export KEYBIND=~/.bashrc

if ! test -f $PROFILE; then
    touch $PROFILE
fi

if test -f ~/.bash_profile; then
    export PROFILE=~/.bash_profile
fi

if test -f ~/.environment.env; then
    export ENVVAR=~/.environment.env
fi

if test -f ~/.bash_aliases; then
    export ALIAS=~/.bash_aliases
fi

if test -d ~/.bash_aliases.d/; then
    export ALIAS_FILEDIR=~/.bash_aliases.d/
fi

if test -f ~/.bash_completion; then
    export COMPLETION=~/.bash_completion
fi

if test -d ~/.bash_completion.d/; then
    export COMPLETION_FILEDIR=~/.bash_completion.d/
fi

if test -f ~/.keybinds; then
    export KEYBIND=~/.keybinds
fi

if test -d ~/.keybinds.d/; then
    export KEYBIND_FILEDIR=~/.keybinds.d/
fi

export PROFILE_R=/root/.profile
export ALIAS_R=/root/.bashrc
export COMPLETION_R=/root/.bashrc
export KEYBIND_R=/root/.bashrc
export ENVVAR_R=/root/.bashrc

echo "This next $(tput setaf 1)sudo$(tput sgr0) checks for the profile, environment, bash_alias, bash_completion and keybind files and dirs in '/root/' to generate global variables."

if ! sudo test -f $PROFILE_R; then
    sudo touch $PROFILE_R
fi

if sudo test -f /root/.bash_profile; then
    PROFILE_R=/root/.bash_profile
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
if sudo test -f /root/.keybinds; then
    export KEYBIND_R=/root/.keybinds
fi

if sudo test -d /root/.keybinds.d/; then
    export KEYBIND_FILEDIR_R=/root/.keybindsd.d/
fi
