# https://github.com/sharkdp/bat

# https://www.greenwoodsoftware.com/less/
# https://github.com/walles/moor
# https://www.jedsoft.org/most/

# https://github.com/lucc/nvimpager

hash less &> /dev/null && hash bat &> /dev/null && hash moor &> /dev/null && hash most &> /dev/null && hash nvimpager &> /dev/null && SYSTEM_UPDATED='TRUE'

TOP=$(git rev-parse --show-toplevel)

if ! [[ -f $TOP/checks/check_all.sh ]]; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . $TOP/checks/check_all.sh
fi

reade -Q "GREEN" -i "moor bat most nvimpager" -p "Which to install? [Bat/moor/most/nvimpager]: " pager
if [[ $pager == "bat" ]]; then
    if ! [[ -f $TOP/cli-tools/install_bat.sh ]]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/install_bat.sh)
    else
        . $TOP/cli-tools/install_bat.sh
    fi

elif [[ $pager == "moor" ]]; then
    if ! [[ -f $TOP/cli-tools/install_moor.sh ]]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/install_moor.sh)
    else
        . $TOP/cli-tools/install_moor.sh
    fi
elif [[ $pager == "most" ]]; then
    if ! [[ -f $TOP/cli-tools/install_most.sh ]]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/install_most.sh)
    else
        . $TOP/cli-tools/install_most.sh
    fi
elif [[ $pager == "nvimpager" ]]; then
    if ! [[ -f $TOP/cli-tools/install_nvimpager.sh ]]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/install_nvimpager.sh)
    else
        . $TOP/cli-tools/install_nvimpager.sh
    fi
fi
