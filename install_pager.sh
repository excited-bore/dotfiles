#/bin/bash

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

SCRIPT_DIR=$(pwd)


reade -Q "GREEN" -i "bat moar most nvimpager" -p "Which to install? [Bat/moar/most/nvimpager]: " pager
if [[ $pager == "bat" ]]; then
    if ! test -f install_bat.sh; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_bat.sh)"
    else
        . ./install_bat.sh
    fi

elif [[ $pager == "moar" ]]; then
    if ! test -f install_moar.sh; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_moar.sh)"
    else
        . ./install_moar.sh
    fi
elif [[ $pager == "most" ]]; then
    if ! test -f install_most.sh; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_most.sh)"
    else
        . ./install_most.sh
    fi
elif [[ $pager == "nvimpager" ]]; then
    if ! test -f install_nvimpager.sh; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_nvimpager.sh)"
    else
        . ./install_nvimpager.sh
    fi
fi
