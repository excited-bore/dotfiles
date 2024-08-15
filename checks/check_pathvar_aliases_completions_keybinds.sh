#!/usr/bin/env bash

if ! grep -q "/usr/share/bash-completion/bash_completion" ~/.bashrc; then
    echo "[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion" >> ~/.bashrc
fi

if [ ! -f ~/.bash_aliases ]; then
    if ! test -f aliases/.bash_aliases; then
        wget -P ~/ https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases  
    else
        cp -fv aliases/.bash_aliases ~/
    fi 
fi

if [ ! -d ~/.bash_aliases.d/ ]; then
    mkdir ~/.bash_aliases.d/
fi

if ! test -f ~/.bash_aliases.d/check_system.sh; then
    if ! test -f checks/check_system.sh; then
        wget -O ~/.bash_aliases.d/check_system.sh https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh  
    else
        cp -fv checks/check_system.sh ~/.bash_aliases.d/
    fi
fi

if ! test -f ~/.bash_aliases.d/bash.sh; then
    if ! test -f aliases/.bash_aliases.d/bash.sh; then
        wget -O ~/.bash_aliases.d/bash.sh https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/bash.sh  
    else
        cp -fv aliases/.bash_aliases.d/bash.sh ~/.bash_aliases.d/
    fi
fi

if ! test -f ~/.bash_aliases.d/00-rlwrap_scripts.sh; then 
    if ! test -f aliases/.bash_aliases.d/00-rlwrap_scripts.sh; then
        wget -O ~/.bash_aliases.d/00-rlwrap_scripts.sh https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/00-rlwrap_scripts.sh  
    else
        cp -fv aliases/.bash_aliases.d/00-rlwrap_scripts.sh ~/.bash_aliases.d/
    fi
fi


if [ ! -f ~/.bash_completion ]; then
    if ! test -f completions/.bash_completion; then
        wget -P ~/ https://raw.githubusercontent.com/excited-bore/dotfiles/main/completions/.bash_completion
    else
        cp -fv completions/.bash_completion ~/
    fi 
fi

if [ ! -d ~/.bash_completion.d/ ]; then
    mkdir ~/.bash_completion.d/
fi

if [ ! -f ~/.keybinds ]; then
    if ! test -f keybinds/.keybinds; then
        wget -P ~/ https://raw.githubusercontent.com/excited-bore/dotfiles/main/keybinds/.keybinds
    else
        cp -fv keybinds/.keybinds ~/
    fi 
fi

if [ ! -d ~/.keybinds.d/ ]; then
    mkdir ~/.keybinds.d/
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

if test -f ~/.pathvariables.env && ! grep -q "~/.pathvariables.env" ~/.bashrc; then
    printf "\n[ -f ~/.pathvariables.env ] && source ~/.pathvariables.env\n\n" >> ~/.bashrc
fi

if ! grep -q "~/.bash_completion" ~/.bashrc; then
    if grep -q "~/.bash_aliases" ~/.bashrc; then
        sed -i 's|\(\[ -f ~/.bash_aliases \] && source ~/.bash_aliases\)|\[ -f \~/.bash_completion \] \&\& source \~/.bash_completion\n\1\n|g' ~/.bashrc
    else
        printf "\n[ -f ~/.bash_completion ] && source ~/.bash_completion\n\n" >> ~/.bashrc
    fi
fi

if ! grep -q "~/.bash_aliases" ~/.bashrc; then
    printf "\n[ -f ~/.bash_aliases ] && source ~/.bash_aliases\n\n" >> ~/.bashrc
    if grep -q "complete -F _complete_alias" ~/.bashrc; then
        sed -i '/complete -F _complete_alias "${!BASH_ALIASES\[@\]}"/d' ~/.bashrc 
    fi
fi

if ! grep -q "~/.keybinds" ~/.bashrc; then
    printf "\n[ -f ~/.keybinds ] && source ~/.keybinds\n\n" >> ~/.bashrc 
fi

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

echo "This next $(tput setaf 1)sudo$(tput sgr0) is checks for the pathvariable, bash_alias, bash_completion and keybind files and dirs in '/root/'.";

if sudo test -f /root/.pathvariables.env && ! sudo grep -q "~/.pathvariables.env" /root/.bashrc; then
    printf "\n[ -f ~/.pathvariables.env ] && source ~/.pathvariables.env\n\n" | sudo tee -a /root/.bashrc
fi 

if ! sudo test -f /root/.bash_aliases; then
    echo "Next $(tput setaf 1)sudo$(tput sgr0) will install '.bash_aliases.d' in /root and source files in it with '/root/.bash_aliases' "
    sudo cp -fv ~/.bash_aliases /root/
    if ! sudo test -d /root/.bash_aliases.d/; then
        sudo mkdir /root/.bash_aliases.d/
        sudo cp -fv ~/.bash_aliases.d/check_system.sh /root/.bash_aliases.d/check_system.sh
        sudo cp -fv ~/.bash_aliases.d/bash.sh /root/.bash_aliases.d/bash.sh
        sudo cp -fv ~/.bash_aliases.d/00-rlwrap_scripts.sh /root/.bash_aliases.d/00-rlwrap_scripts.sh 
    fi
    if ! sudo grep -q "~/.bash_aliases" ~/.bashrc; then
        printf "\n[ -f ~/.bash_aliases ] && source ~/.bash_aliases\n\n" | sudo tee -a /root/.bashrc &> /dev/null 
        if sudo grep -q "complete -F _complete_alias" /root/.bashrc; then
            sudo sed -i '/complete -F _complete_alias "${!BASH_ALIASES\[@\]}"/d' /root/.bashrc 
        fi
    fi
fi

if ! sudo test -f /root/.bash_completion; then
    echo "Next $(tput setaf 1)sudo$(tput sgr0) will install '.bash_completion.d' in /root and source files in it with '/root/.bash_completion"
    if [ ! -f /root/.bash_completion ]; then
        if ! test -f completions/.bash_completion; then
            sudo wget -P /root/ https://raw.githubusercontent.com/excited-bore/dotfiles/main/completions/.bash_completion 
        else
            sudo cp -fv completions/.bash_completion /root/
        fi 
    fi
    if ! sudo test -d /root/.bash_completion.d/; then
        sudo mkdir /root/.bash_completion.d/
    fi

    if ! sudo grep -q "~/.bash_completion" /root/.bashrc; then
        if sudo grep -q "~/.bash_aliases" /root/.bashrc; then
            sudo sed -i 's|\(\[ -f ~/.bash_aliases \] && source ~/.bash_aliases\)|\[ -f \~/.bash_completion \] \&\& source \~/.bash_completion\n\1\n|g' /root/.bashrc &> /dev/null
        else
            printf "\n[ -f ~/.bash_completion ] && source ~/.bash_completion\n\n" | sudo tee -a /root/.bashrc &> /dev/null
        fi
    fi
fi 

if ! sudo test -f /root/.keybinds; then
    echo "Next $(tput setaf 1)sudo$(tput sgr0) will install '.keybinds.d' in /root and source files in it with '/root/.keybinds"
    if [ ! -f /root/.keybinds ]; then
        if ! test -f keybinds/.keybinds; then
            sudo wget -P /root/ https://raw.githubusercontent.com/excited-bore/dotfiles/main/keybinds/.keybinds 
        else
            sudo cp -fv keybinds/.keybinds /root/
        fi 
    fi
    if ! sudo test -d /root/.keybinds.d/; then
        sudo mkdir /root/.keybinds.d/
    fi
    if ! sudo grep -q "~/.keybinds" /root/.bashrc; then
        printf "\n[ -f ~/.keybinds/ ] && source ~/.keybinds\n" | sudo tee -a /root/.bashrc &> /dev/null
    fi
fi

PATHVAR=~/.bashrc

if [ -f ~/.pathvariables.env ]; then
    PATHVAR=~/.pathvariables.env
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
PATHVAR_R=/root/.bashrc


if sudo test -f /root/.pathvariables.env; then
    PATHVAR_R=/root/.pathvariables.env
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

