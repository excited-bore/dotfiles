 #DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
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

if ! test -x "$(command -v rlwrap)"; then
    reade -Q "GREEN" -i "y" -p "Install rlwrap? (Offers autocompletion for input prompts - keyboard up/down) [Y(es)/n(o)]: " "y n" answr
    if [ "$answr" == "y" ] || [ -z "$answr" ] || [ "Y" == "$answr" ]; then
        if test $distro_base == "Debian"; then
            sudo apt install rlwrap;
        elif test $distro == "Arch" || test $distro == "Manjaro"; then
            sudo pacman -S rlwrap;
        else
            if test -x $(command -v git) && test -x $(command -v make); then
                (cd $TMPDIR
                git clone https://github.com/hanslub42/rlwrap
                cd rlwrap
                ./configure
                make
                if [ -x $(command -v sudo) ]; then
                    sudo make install
                else
                    make install
                fi)
            fi
        fi
    fi
    unset answr
fi
