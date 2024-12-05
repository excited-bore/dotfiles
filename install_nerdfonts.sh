# !/bin/bash
if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
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

if ! [ -d  ~/.local/share/fonts ]; then
    mkdir ~/.local/share/fonts
fi

if ! type jq &> /dev/null; then
    if test $distro == "Manjaro" || test $distro == "Arch"; then
        eval "$pac_ins jq"
    elif test $distro_base == "Debian"; then
        eval "$pac_ins jq"
    fi
fi
fonts=$(mktemp -d)
wget -P "$fonts" https://github.com/vorillaz/devicons/archive/master.zip 
unzip $fonts/master.zip -d $fonts
ltstv=$(curl -sL "https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest" | jq -r ".tag_name")
wget -P "$fonts" https://github.com/ryanoasis/nerd-fonts/releases/download/$ltstv/Hermit.zip
unzip $fonts/Hermit.zip -d $fonts
rm -f $fonts/master.zip $fonts/Hermit.zip
mv $fonts/* ~/.local/share/fonts
sudo fc-cache -fv
