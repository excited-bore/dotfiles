# !/bin/bash
if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi
if ! test -f aliases/.bash_aliases.d/00-rlwrap_scripts.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/00-rlwrap_scripts.sh)" 
else
    . ./aliases/.bash_aliases.d/00-rlwrap_scripts.sh
fi

if ! type update-system &> /dev/null; then
    if ! test -f aliases/.bash_aliases.d/update-system.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/update-system.sh)" 
    else
        . ./aliases/.bash_aliases.d/update-system.sh
    fi
fi

if test -z $SYSTEM_UPDATED; then
    reade -Q "CYAN" -i "n" -p "Update system? [Y/n]: " "y n" updatesysm
    if test $updatesysm == "y"; then
        update-system                     
    fi
fi

if ! type bat &> /dev/null; then 
    if test $distro == "Arch" || test $distro == "Manjaro";then
        sudo pacman -S bat
    elif [ $distro_base == "Debian" ]; then
        sudo apt install bat
        if [ -x "$(command -v batcat)" ]; then
            mkdir -p ~/.local/bin
            ln -s /usr/bin/batcat ~/.local/bin/bat
        fi
    fi
fi 

if ! type batdiff &> /dev/null; then 
    reade -Q "GREEN" -i "y" -p "Install bat-extras (includes batdiff/batgrep/batman/bat-modules/batpipe/batwatch) [Y/n]: " "y n" bat
    if test "$bat" == "y"; then
        if test "$distro" == "Arch" || test "$distro" == "Manjaro";then
            sudo pacman -S bat-extras
        elif [ $distro_base == "Debian" ]; then
            #yes | sudo apt install golang
            #go install mvdan.cc/sh/v3/cmd/shfmt@latest
            git clone https://github.com/eth-p/bat-extras $TMPDIR/bat-extras
            chown -R $USER $TMPDIR/bat-extras
            (cd $TMPDIR/bat-extras && sudo ./build.sh --install --prefix=PATH)
        fi 
    fi
fi

unset bat 
