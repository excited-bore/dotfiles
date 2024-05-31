# !/bin/bash
if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi
if ! test -f aliases/rlwrap_scripts.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/rlwrap_scripts.sh)" 
else
    . ./aliases/rlwrap_scripts.sh
fi


if [ "$(which bat)" == "" ]; then 
    if [ $distro_base == "Arch" ];then
        yes | sudo pacman -Su bat
    elif [ $distro_base == "Debian" ]; then
        yes | sudo apt update
        yes | sudo apt install bat
        if [ -x "$(command -v batcat)" ]; then
            mkdir -p ~/.local/bin
            ln -s /usr/bin/batcat ~/.local/bin/bat
        fi
    fi
fi 

if [ "$(which batdiff)" == "" ]; then 
    reade -Q "GREEN" -i "y" -p "Install bat-extras (includes batdiff/batgrep/batman/bat-modules/batpipe/batwatch) [Y/n]: " "y n" bat
    if test "$bat" == "y"; then
        if [ $distro_base == "Arch" ];then
            yes | sudo pacman -Su bat-extras
        elif [ $distro_base == "Debian" ]; then
            #yes | sudo apt install golang
            #go install mvdan.cc/sh/v3/cmd/shfmt@latest
            (cd $TMPDIR
            git clone https://github.com/eth-p/bat-extras
            chown -R $USER bat-extras
            cd bat-extras
            sudo ./build.sh --install --prefix=PATH)
        fi 
    fi
fi

unset bat 
