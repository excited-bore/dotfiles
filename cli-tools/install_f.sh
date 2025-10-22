# https://github.com/iffse/pay-respects

hash pay-respects &> /dev/null && SYSTEM_UPDATED='TRUE'

TOP=$(git rev-parse --show-toplevel 2> /dev/null)

if ! test -f $TOP/checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . $TOP/checks/check_all.sh
fi


if ! hash pay-respects &>/dev/null; then
    if [[ $machine == 'Mac' ]] && hash brew &>/dev/null; then
        brew install thefuck    
    elif [[ $distro_base == 'Arch' ]]; then
        if ! test -f $TOP/checks/check_AUR.sh; then
            source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_AUR.sh)
        else
            . $TOP/checks/check_AUR.sh
        fi
        eval "${AUR_ins_y} pay-respects"
    else
        if ! test -f $TOP/cli-tools/pkgmngrs/install_cargo.sh; then
            source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/pkgmngrs/install_cargo.sh)
        else
            . $TOP/cli-tools/pkgmngrs/install_cargo.sh
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
    if test -n "$ansr"; then
        if test -f ~/.bashrc; then
            sed -i '/eval \"\$(pay-respects bash/d' ~/.bashrc 
            if [[ "$ansr" == 'f' ]]; then
                printf "eval \"\$(pay-respects bash)\"\n" >>~/.bashrc
            else
                printf "eval \"\$(pay-respects bash --alias $ansr)\"\n" >>~/.bashrc
            fi
        fi
        
        # Bug in default manjaro bashrc 
        if grep -qE "^xhost" ~/.bashrc; then
            sed -i 's/xhost/hash xhost \&> \/dev\/null \&\& xhost/g' ~/.bashrc
        fi
        
        if test -f ~/.zshrc; then
            sed -i '/eval \"\$(pay-respects zsh/d' ~/.zshrc
            if [[ "$ansr" == 'f' ]]; then
                printf "eval \"\$(pay-respects zsh)\"\n" >>~/.zshrc
            else
                printf "eval \"\$(pay-respects zsh --alias $ansr)\"\n" >>~/.zshrc
            fi
        fi
        unset ansr
    fi
fi
