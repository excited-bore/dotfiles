if ! test -f checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ./checks/check_all.sh
fi

if [[ $machine == 'Mac' ]] && hash brew &>/dev/null; then
    brew install pyenv
elif [[ "$distro_base" == "Arch" ]]; then
    eval "${pac_ins_y} base-devel openssl zlib xz tk pyenv"
elif [[ $distro_base == "Debian" ]]; then
    eval "${pac_ins_y} build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev curl git libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev"
    wget-curl https://pyenv.run | bash
else
    wget-curl https://pyenv.run | bash
fi

readyn -p 'Enable pyenv shell integration for current shell?' shell_init
if [[ "$shell_init" == 'y' ]]; then
    export PYENV_ROOT="$HOME/.pyenv"
    [[ -d $PYENV_ROOT/bin ]] && export PATH="$PATH:$PYENV_ROOT/bin"
    eval "$(pyenv init -)"
fi

if type pyenv &>/dev/null; then
    reade -Q 'GREEN' -i "stable all" -p "What versions to list? [Stable/all]: " vers_all
    if [[ "$vers_all" == 'stable' ]]; then
        all="$(pyenv install -l | grep --color=never -E '[[:space:]][0-9].*[0-9]$' | sed '/rc/d' | xargs | tr ' ' '\n' | tac)"
        #frst="$(echo $all | awk '{print $1}')"
        #all="$(echo $all | sed "s/\<$frst\> //g")"
    else
        all="$(pyenv install -l | awk 'NR>2 {print;}' | tac)"
        #frst="$(echo $all | awk '{print $1}')"
        #all="$(echo $all | sed "s/\<$frst\> //g")"
    fi

    printf "Python versions:\n${CYAN}$(echo $all | tr ' ' '\n' | tac | column)${normal}\n"
    reade -Q 'GREEN' -i "$all" -p "Which version to install?: " vers

    verss="$(pyenv completions global | sed '/--help/d' | sed '/system/d')"

    if test -n "$vers"; then
        if [[ "${verss}" != *"$vers"* ]]; then
            pyenv install "$vers"
        fi
        pyenv global "$vers"
        [[ "$shell_init" == 'y' ]] && pyenv shell "$vers"
        python --version
    fi
fi
unset frst vers verss all shell_init
