[[ $0 != $BASH_SOURCE ]] && 
    SCRIPT_DIR="$( dirname "${BASH_SOURCE[0]}" )" || 
    SCRIPT_DIR="$( cd "$( dirname "$-1" )" && pwd )" 

if ! test -f $SCRIPT_DIR/../checks/check_all.sh; then
    if hash curl &> /dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh) 
    else 
        continue 
    fi
else
    . $SCRIPT_DIR/../checks/check_all.sh
fi

if ! hash pamac &> /dev/null; then
    if test -z "$(pacman -Ssq pamac-cli)"; then 
        if ! hash git &> /dev/null || ! hash makepkg &> /dev/null || ! hash fakeroot &> /dev/null; then
            eval "${pac_ins} --needed base-devel git fakeroot"
        fi
        git clone https://aur.archlinux.org/pamac-cli.git $TMPDIR/pamac
        (cd $TMPDIR/pamac
        makepkg -fsri)
        pamac --version && echo "${GREEN}Pamac installed!${normal}"
    else 
        sudo pacman -S pamac-cli --noconfirm
    fi
fi

if ! test -f /etc/pamac.conf || ! grep -q '^EnableAUR' /etc/pamac.conf; then
    if ! test -f /etc/pamac.conf; then
        printf "${GREEN}Adding /etc/pamac.conf to enable the AUR for pamac\n${normal}"
        sudo touch /etc/pamac.conf
        printf '## Allow Pamac to search and install packages from AUR:\nEnableAUR\n' | sudo tee -a /etc/pamac.conf
    else
        printf "${GREEN}Adding 'EnableAUR' to /etc/pamac.conf to enable the AUR for pamac\n${normal}"
        if grep -q 'EnableAUR' /etc/pamac.conf; then
            sudo sed -i 's/#EnableAUR/EnableAUR/g' /etc/pamac.conf
        else 
            printf '## Allow Pamac to search and install packages from AUR:\nEnableAUR\n' | sudo tee -a /etc/pamac.conf
        fi
    fi
fi
