if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi
if ! type reade &> /dev/null; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/00-rlwrap_scripts.sh)" 
else
    . ./aliases/.bash_aliases.d/00-rlwrap_scripts.sh
fi 
if ! test -f checks/check_envvar.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_envvar.sh)" 
else
    . ./checks/check_envvar.sh
fi

if ! type update-system &> /dev/null; then
    if ! test -f aliases/.bash_aliases.d/update-system.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/update-system.sh)" 
    else
        . ./aliases/.bash_aliases.d/update-system.sh
    fi
fi

if test -z $SYSTEM_UPDATED; then
    readyn -Y "CYAN" -p "Update system?" updatesysm
    if test $updatesysm == "y"; then
        update-system                     
    fi
fi 

if ! type pyenv &> /dev/null; then
    if test $machine == 'Mac' && type brew &> /dev/null; then
        brew install pyenv 
    elif test "$distro_base" == "Arch"; then
        ${pac_ins} pyenv
    elif [ $distro_base == "Debian" ] && ! test -z "$(apt search pyenv 2> /dev/null)"; then
        ${pac_ins} pyenv
    else
        curl https://pyenv.run | bash
    fi 
fi

readyn -p 'Enable pyenv shell integration for current shell?' shell_init
if test "$shell_init" == 'y'; then
    export PYENV_ROOT="$HOME/.pyenv"
    [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)" 
fi

if type pyenv &> /dev/null; then
    reade -Q 'GREEN' -i "stable" -p "What versions to list? [Stable/all]: " "all" vers_all
    if test $vers_all == 'stable'; then
        all="$(pyenv install -l | grep --color=never -E [[:space:]][0-9].*[0-9]$ | sed '/rc/d' | xargs| tr ' ' '\n' | tac)" 
        frst="$(echo $all | awk '{print $1}')"
        all="$(echo $all | sed "s/\<$frst\> //g")" 
    else
        all="$(pyenv install -l | awk 'NR>2 {print;}' | tac)" 
        frst="$(echo $all | awk '{print $1}')"
        all="$(echo $all | sed "s/\<$frst\> //g")" 
    fi
    
    printf "Python versions:\n${CYAN}$(echo $all | tr ' ' '\n' | tac | column)${normal}\n" 
    reade -Q 'GREEN' -i "$frst" -p "Which version to install?: " "$all" vers  

    verss="$(pyenv completions global | sed '/--help/d' | sed '/system/d')" 

    if ! test -z "$vers"; then
        if [[ "${verss}" != *"$vers"* ]]; then 
            pyenv install "$vers" 
        fi
        pyenv global "$vers" 
        test "$shell_init" == 'y' && pyenv shell "$vers" 
        python --version
    fi
fi
unset frst vers verss all shell_init
