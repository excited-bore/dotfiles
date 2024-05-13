 #DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi

if [ ! -x "$(command -v rlwrap)" ]; then
    read -p "Install rlwrap (better autocompletion, used a lot throughout scripts) [Y/n]:" answr
    if [ "$answr" == "y" ] || [ -z "$answr" ] || [ "Y" == "$answr" ]; then
        if [ ! -x $(command -v git) ]; then
            if [[ $distro == "Debian" || $distro_base == "Debian" ]]; then
                yes | sudo apt install git;
            elif [[ $distro == "Arch" || $distro_base == "Arch" ]]; then
                yes | sudo pacman -Su git;
            fi
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
