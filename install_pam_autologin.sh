if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi

if [ "$distro" == "Manjaro" ]; then
    pamac install pam_autologin
elif test "$distro" == "Arch" && ! test "$AUR_install" == ""; then
    eval "$AUR_install" pam_autologin
fi

if ! sudo grep -q "pam_autologin.so" /etc/pam.d/login; then 
    sudo sed -i 's|\(#%PAM-1.0\)|\1\nauth       required        pam_autologin.so always|g' /etc/pam.d/login
fi
