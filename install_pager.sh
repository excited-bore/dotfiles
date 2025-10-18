if ! [[ -f checks/check_all.sh ]]; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . checks/check_all.sh
fi

SCRIPT_DIR=$(get-script-dir)


reade -Q "GREEN" -i "moor bat most nvimpager" -p "Which to install? [Bat/moor/most/nvimpager]: " pager
if [[ $pager == "bat" ]]; then
    if ! [[ -f cli-tools/install_bat.sh ]]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/install_bat.sh)
    else
        . cli-tools/install_bat.sh
    fi

elif [[ $pager == "moor" ]]; then
    if ! [[ -f cli-tools/install_moor.sh ]]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/install_moor.sh)
    else
        . cli-tools/install_moor.sh
    fi
elif [[ $pager == "most" ]]; then
    if ! [[ -f cli-tools/install_most.sh ]]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/install_most.sh)
    else
        . cli-tools/install_most.sh
    fi
elif [[ $pager == "nvimpager" ]]; then
    if ! [[ -f cli-tools/install_nvimpager.sh ]]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/install_nvimpager.sh)
    else
        . cli-tools/install_nvimpager.sh
    fi
fi
