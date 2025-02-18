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
    update-system
else
    readyn -Y "CYAN" -p "Update system?" updatesysm
    if test $updatesysm == "y"; then
        update-system                     
    fi
fi

if [ "$distro" == "Manjaro" ]; then
    pamac install pam_autologin
elif test "$distro" == "Arch" && ! test "$AUR_ins" == ""; then
    ${AUR_ins} pam_autologin
fi

if ! sudo grep -q "pam_autologin.so" /etc/pam.d/login; then 
    sudo sed -i 's|\(#%PAM-1.0\)|\1\nauth       required        pam_autologin.so always|g' /etc/pam.d/login
fi
