hash autojump &> /dev/null && SYSTEM_UPDATED='TRUE'

TOP=$(git rev-parse --show-toplevel 2> /dev/null)

if ! test -f $TOP/checks/check_all.sh; then
    if type curl &>/dev/null; then
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

if ! hash autojump &>/dev/null; then
    if [[ "$distro_base" == "Arch" ]]; then
        eval "$AUR_ins_y" autojump
    elif [[ $distro_base == "Debian" ]]; then
        eval "$pac_ins_y" autojump
    fi
fi
unset tojump bnd bnd_r

#if ! grep -q "autojump" ~/.bashrc; then
#    printf "[ -s /etc/profile.d/autojump.sh ] && source /etc/profile.d/autojump.sh\n" >> ~/.bashrc
#&> /dev/null
#fi
#if ! sudo grep -q "autojump" /root/.bashrc; then
#    printf "[ -s /etc/profile.d/autojump.sh ] && source /etc/profile.d/autojump.sh\n" | sudo tee -a /root/.bashrc &> /dev/null
#fi

