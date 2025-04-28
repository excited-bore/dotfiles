#/bin/bash

if ! test -f checks/check_all.sh; then
    if type curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        printf "If not downloading/git cloning the scriptfolder, you should at least install 'curl' beforehand when expecting any sort of succesfull result...\n"
        return 1 || exit 1
    fi
else
    . ./checks/check_all.sh
fi

SCRIPT_DIR=$(pwd)


reade -Q "GREEN" -i "delta difftastic diff-so-fancy riff ydiff diffr colordiff" -p "Which to install? [Delta/diff-so-fancy/riff/ydiff/difftastic/diffr/colordiff]: " pager

if [[ $pager == "bat" ]]; then
    if ! test -f install_bat.sh; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_bat.sh)"
    else
        . ./install_bat.sh
    fi

elif [[ $pager == "riff" ]]; then
    if ! test -f install_cargo.sh; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_cargo.sh)"
    else
        . ./install_cargo.sh
    fi
    cargo install --locked riffdiff

elif [[ $pager == "difftastic" ]]; then
    if ! test -f install_cargo.sh; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_cargo.sh)"
    else
        . ./install_cargo.sh
    fi
    cargo install --locked difftastic

elif [[ $pager == "diffr" ]]; then
    if ! test -f install_cargo.sh; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_cargo.sh)"
    else
        . ./install_cargo.sh
    fi
    cargo install --locked diffr
fi

if [[ "$distro_base" == "Arch" ]]; then
    if [[ $pager == "diff-so-fancy" ]]; then
        eval "$pac_ins diff-so-fancy"
    elif [[ $pager == "colordiff" ]]; then
        eval "$pac_ins colordiff"
    elif [[ $pager == "delta" ]]; then
        eval "$pac_ins git-delta"
    elif [[ $pager == "ydiff" ]]; then
        if ! type pipx &>/dev/null && ! test -f install_pipx.sh; then
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_pipx.sh)"
        elif ! type pipx &>/dev/null; then
            . ./install_pipx.sh
        fi
        pipx install ydiff
    fi
elif [[ "$distro_base" == "Debian" ]]; then
    if [[ $pager == "diff-so-fancy" ]]; then
        eval "$pac_ins npm"
        sudo npm -g install diff-so-fancy
    elif [[ $pager == "colordiff" ]]; then
        eval "$pac_ins colordiff"
    elif [[ $pager == "delta" ]]; then
        eval "$pac_ins git-delta"
    elif [[ $pager == "ydiff" ]]; then
        if ! type pipx &>/dev/null && ! test -f install_pipx.sh; then
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_pipx.sh)"
        elif ! type pipx &>/dev/null; then
            . ./install_pipx.sh
        fi
        pipx install ydiff
    fi
fi

