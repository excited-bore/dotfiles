[[ $0 != $BASH_SOURCE ]] && 
    SCRIPT_DIR="$( dirname "${BASH_SOURCE[0]}" )" || 
    SCRIPT_DIR="$( cd "$( dirname "$-1" )" && pwd )" 

if ! test -f $SCRIPT_DIR/../checks/check_all.sh; then
    if hash curl &> /dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh) 
    else 
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh) 
    fi
else
    . $SCRIPT_DIR/../checks/check_all.sh
fi

# Extra repositories check
if [[ $(grep 'extra' -A2 /etc/pacman.conf) =~ "#Include" ]]; then
    readyn -p "Include 'extra' repositories for pacman?" ansr
    if [[ "$ansr" == 'y' ]]; then
        sudo sed -i '/^\[extra\]$/,/^$/ { s|#Siglevel =|Siglevel =| }' /etc/pacman.conf
        sudo sed -i '/^\[extra\]$/,/^$/ { s|#Include =|Include =| }' /etc/pacman.conf
        sudo pacman -Syy 
    fi
fi

unset ansr 


if ! hash yay &> /dev/null; then
    #if ! hash git &> /dev/null || ! hash makepkg &> /dev/null || ! hash fakeroot &> /dev/null; then
    #    eval "${pac_ins} --needed base-devel git fakeroot"
    #fi
    #git clone https://aur.archlinux.org/yay.git $TMPDIR/yay
    #(cd $TMPDIR/yay
    #makepkg -fsri)
    #yay --version && echo "${GREEN}Yay installed!${normal}"
    sudo pacman --noconfirm -S yay 
fi
