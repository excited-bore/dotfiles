 #DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
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

if ! type rlwrap &> /dev/null; then
    reade -Q "GREEN" -i "y" -p "Install rlwrap? (Offers autocompletion for input prompts - keyboard up/down) [Y(es)/n(o)]: " "y n" answr
    if [ "$answr" == "y" ] || [ -z "$answr" ] || [ "Y" == "$answr" ]; then
        if test $machine == 'Windows' && type pacman &> /dev/null; then
            pacman -S rlwrap
        elif [[ $(uname -s) =~ 'CYGWIN' ]] && type apt-cyg &> /dev/null; then
            apt-cyg install rlwrap
        elif test $distro_base == "Debian"; then
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
