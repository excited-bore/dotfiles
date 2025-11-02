TOP=$(git rev-parse --show-toplevel 2> /dev/null)

if ! test -f $TOP/checks/check_all.sh; then
    if hash curl &> /dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . $TOP/checks/check_all.sh
fi


if [[ $distro_base == 'Arch' ]]; then 
    if hash pamac &> /dev/null && grep -q "#EnableAUR" /etc/pamac.conf; then
        if ! test -f $TOP/checks/check_pamac.sh; then
            source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_pamac.sh)
        else 
            . $TOP/checks/check_pamac.sh
        fi
    elif test -z "$AUR_ins" &> /dev/null; then
        printf "An AUR installer / pacman wrapper is needed. ${CYAN}yay${normal} is recommended for this\n"
        readyn -p "Install yay?" insyay
        if [[ "y" == "$insyay" ]]; then
            if ! test -f $TOP/AUR_installers/install_yay.sh; then
                source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/AUR_installers/install_yay.sh)
            else
                . $TOP/AUR_installers/install_yay.sh
            fi
            AUR_pac="yay"
            AUR_up="yay -Syu"
            AUR_ins="yay -S"
            AUR_search="yay -Ss"
            AUR_ls_ins="yay -Q"
        fi
    fi
fi
