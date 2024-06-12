# !/bin/bash
if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi 

if ! type update_system &> /dev/null; then
    if ! test -f update_system.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/update_system.sh)" 
    else
        . ./update_system.sh
    fi
fi

if test -z $SYSTEM_UPDATED; then
    reade -Q "CYAN" -i "n" -p "Update system? [Y/n]: " "y" updatesysm
    if test $updatesysm == "y"; then
        update_system                     
    fi
fi

if ! [ -d  ~/.local/share/fonts ]; then
    mkdir ~/.local/share/fonts
fi

if ! type jq &> /dev/null; then
    if test $distro == "Manjaro" || test $distro == "Arch"; then
        sudo pacman -S jq
    elif test $distro_base == "Debian"; then
        sudo apt install jq
    fi
fi
fonts=$(mktemp -d)
wget -P "$fonts" https://github.com/vorillaz/devicons/archive/master.zip 
ltstv=$(curl -sL "https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest" | jq -r ".tag_name")
wget -P "$fonts" https://github.com/ryanoasis/nerd-fonts/releases/$ltstv/Hermit.zip
unzip $fonts/master.zip $fonts/Hermit.zip
rm -f $fonts/master.zip $fonts/Hermit.zip
mv $fonts/* ~/.local/share/fonts
sudo fc-cache -fv
