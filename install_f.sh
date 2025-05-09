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

if ! test -f checks/check_AUR.sh; then
    source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_AUR.sh)
else
    . ./checks/check_AUR.sh
fi


SCRIPT_DIR=$(get-script-dir)

if ! hash pay-respects &>/dev/null; then
    if [[ $machine == 'Mac' ]] && type brew &>/dev/null; then
        brew install thefuck    
    elif [[ $distro_base == 'Arch' ]]; then
        eval "${AUR_ins} pay-respects"
    else
        if ! test -f install_cargo.sh; then
            source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_cargo.sh)
        else
            . ./install_cargo.sh
        fi
        cargo install pay-respects
        cargo install pay-respects-module-runtime-rules
        cargo install pay-respects-module-request-ai
    fi
fi

if hash pay-respects &> /dev/null; then
    reade -Q 'GREEN' -i 'f fuk fuck h hell heck hek oops ops egh huhn huh nono again agin alexaplaydespacito' -p "Alias for name 'pay-respects'? [Empty: 'f' - 'pay-respects' cant be used]: " ansr
    if [[ $ansr == 'pay-respects' ]]; then
        printf "'pay-respects' cant be aliased to 'pay-respects'\n"
        printf "Using 'f' as alias\n"
        ansr='f'
    fi
    if test -n $ansr; then
        if test -f ~/.bashrc; then
            sed -i '/eval \"\$(pay-respects bash --alias/d' ~/.bashrc 
            printf "eval \"\$(pay-respects bash --alias $ansr)\"\n" >>~/.bashrc
        fi
        if test -f ~/.zshrc; then
            sed -i '/eval \"\$(pay-respects zsh --alias/d' ~/.zshrc
            printf "eval \"\$(pay-respects zsh --alias $ansr)\"\n" >>~/.zshrc
        fi

        unset ansr
    fi

fi
