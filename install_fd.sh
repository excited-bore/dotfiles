# https://github.com/sharkdp/fd

if ! test -f checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ./checks/check_all.sh
fi

if ! hash fd &> /dev/null; then
    if [[ $distro_base == "Arch" ]]; then
        eval "$pac_ins_y fd"
    elif [[ $distro_base == "Debian" ]]; then
        eval "$pac_ins_y fd-find"
        if ! test -f ~/.local/bin/fd; then
            ln -s /usr/bin/fdfind ~/.local/bin/fd
        fi
    fi
fi

# TODO: Make better check: https://github.com/sharkdp/fd
if hash fd-find &> /dev/null || hash fd &> /dev/null; then
    echo "${green}Fd can read from global gitignore file${normal}"
    readyn -n -p "Generate global gitignore using 'themed' templates? (https://github.com/github/gitignore)" fndgbl
    if [[ $fndgbl == 'y' ]]; then
        if ! test -f install_gitignore.sh; then
            b=$(mktemp)
            wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_gitignore.sh | tee "$b" &> /dev/null
            chmod u+x "$b"
            eval "$b" "global"
            unset b
        else
            ./install_gitignore.sh "global"
        fi 
    fi
fi


