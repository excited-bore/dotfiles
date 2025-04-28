#!/bin/bash

if ! test -f checks/check_all.sh; then
    if type curl &> /dev/null; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)"
    else
        continue
    fi
else
    . ./checks/check_all.sh
fi

if ! type pyenv &> /dev/null; then
    if [[ $machine == 'Mac' ]] && type brew &> /dev/null; then
        brew install pyenv 
    elif [[ "$distro_base" == "Arch" ]]; then
        eval "${pac_ins} pyenv"
    elif [[ $distro_base == "Debian" ]] && ! test -z "$(apt search pyenv 2> /dev/null)"; then
        eval "${pac_ins} pyenv"
    else
        curl https://pyenv.run | bash
    fi 
fi

readyn -p 'Enable pyenv shell integration for current shell?' shell_init
if [[ "$shell_init" == 'y' ]]; then
    export PYENV_ROOT="$HOME/.pyenv"
    [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)" 
fi

if type pyenv &> /dev/null; then
    reade -Q 'GREEN' -i "stable all" -p "What versions to list? [Stable/all]: " vers_all
    if [[ "$vers_all" == 'stable' ]]; then
        all="$(pyenv install -l | grep --color=never -E '[[:space:]][0-9].*[0-9]$' | sed '/rc/d' | xargs| tr ' ' '\n' | tac)" 
        frst="$(echo $all | awk '{print $1}')"
        all="$(echo $all | sed "s/\<$frst\> //g")" 
    else
        all="$(pyenv install -l | awk 'NR>2 {print;}' | tac)" 
        frst="$(echo $all | awk '{print $1}')"
        all="$(echo $all | sed "s/\<$frst\> //g")" 
    fi
    
    printf "Python versions:\n${CYAN}$(echo $all | tr ' ' '\n' | tac | column)${normal}\n" 
    reade -Q 'GREEN' -i "$frst $all" -p "Which version to install?: " vers  

    verss="$(pyenv completions global | sed '/--help/d' | sed '/system/d')" 

    if ! test -z "$vers"; then
        if [[ "${verss}" != *"$vers"* ]]; then 
            pyenv install "$vers" 
        fi
        pyenv global "$vers" 
        [[ "$shell_init" == 'y' ]] && pyenv shell "$vers" 
        python --version
    fi
fi
unset frst vers verss all shell_init
