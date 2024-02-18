. ./checks/check_distro.sh

if [ "$distro" == "Manjaro" ]; then
    pamac install pam_autologin
fi

if ! sudo grep -q "pam_autologin.so" /etc/pam.d/login; then 
    sudo sed -i 's|\(#%PAM-1.0\)|\1\nauth       required        pam_autologin.so always|g' /etc/pam.d/login
fi
