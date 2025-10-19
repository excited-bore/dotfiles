# https://github.com/icetee/pv

hash pv &> /dev/null && SYSTEM_UPDATED='TRUE'

TOP=$(git rev-parse --show-toplevel)

if ! test -f $TOP/checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . $TOP/checks/check_all.sh
fi

if ! hash pv &> /dev/null; then
    if [[ "$distro_base" == "Arch" ]]; then
        sudo pacman -S --noconfirm pv
    elif [[ $distro_base == "Debian" ]]; then
        sudo apt install -y pv                                                              
    fi
fi
