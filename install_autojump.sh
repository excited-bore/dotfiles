#!/usr/bin/env bash

if ! test -f checks/check_all.sh; then
    if type curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        printf "If not downloading/git cloning the scriptfolder, you should at least install 'curl' beforehand when expecting any sort of succesfull result...\n"
        return 1 || exit 1
    fi
else
    . ./checks/check_all.sh
fi

get-script-dir SCRIPT_DIR

if ! type autojump &>/dev/null; then
    if [[ "$distro_base" == "Arch" ]]; then
        if test -z "$AUR_ins"; then
            readyn -p 'No AUR helper found. Install yay?' ins_yay
            if [[ "$ins_yay" == 'y' ]]; then
                if ! test -f AUR_insers/install_yay.sh; then
                    eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/AUR_insers/install_yay.sh)"
                else
                    . ./AUR_insers/install_yay.sh
                fi
            fi
            unset ins_yay
            yay -S autojump
        else
            eval "${AUR_ins}" autojump
        fi
    elif [[ $distro_base == "Debian" ]]; then
        eval "${pac_ins}" autojump
    fi
fi

#if ! grep -q "autojump" ~/.bashrc; then
#    printf "[ -s /etc/profile.d/autojump.sh ] && source /etc/profile.d/autojump.sh\n" >> ~/.bashrc
#&> /dev/null
#fi
#if ! sudo grep -q "autojump" /root/.bashrc; then
#    printf "[ -s /etc/profile.d/autojump.sh ] && source /etc/profile.d/autojump.sh\n" | sudo tee -a /root/.bashrc &> /dev/null
#fi

unset tojump bnd bnd_r
