TOP=$(git rev-parse --show-toplevel)

if ! test -f $TOP/checks/check_all.sh; then
    if hash curl &> /dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . $TOP/checks/check_all.sh
fi

if ! test -f $TOP/checks/check_AUR.sh; then
    source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_AUR.sh)
else
    . $TOP/checks/check_AUR.sh
fi

if ! test -z "$AUR_ins"; then
    eval "${AUR_ins} pam_autologin"
fi

if ! sudo grep -q "pam_autologin.so" /etc/pam.d/login; then
    sudo sed -i 's|\(#%PAM-1.0\)|\1\nauth       required        pam_autologin.so always|g' /etc/pam.d/login
fi
