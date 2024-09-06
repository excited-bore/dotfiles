if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi

if ! type update-system &> /dev/null; then
    if ! test -f aliases/.bash_aliases.d/update-system.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/update-system.sh)" 
    else
        . ./aliases/.bash_aliases.d/update-system.sh
    fi
fi

if test -z $SYSTEM_UPDATED; then
    reade -Q "CYAN" -i "n" -p "Update system? [Y/n]: " "y" updatesysm
    if test $updatesysm == "y"; then
        update-system                     
    fi
fi

if ! test -f checks/check_rlwrap.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_rlwrap.sh)" 
else
    . ./checks/check_rlwrap.sh
fi 

if ! type neofetch &> /dev/null && ! type fastfetch &> /dev/null && ! type screenFetch &> /dev/null; then
    #reade -Q "GREEN" -i "y" -p "Install neofetch/fastfetch/screenFetch? [Y/n]: " "n" sym2
    #if test "$sym2" == "y"; then
        
        reade -Q "CYAN" -i "fast" -p "Which one? [Fast/neo/screen]: " "neo screen" sym2
        if test "$sym2" == "neo"; then
            if test $distro_base == "Debian"; then
               sudo apt install neofetch
            elif test $distro_base == "Arch"; then
               sudo pacman -S neofetch
            fi
            
            if ! test -f ~/.config/neofetch/config.conf; then

                if test -f neofetch/.config/neofetch/config.conf; then
                    file=neofetch/.config/neofetch/config.conf
                else
                    dir1="$(mktemp -d -t tmux-XXXXXXXXXX)"
                    curl -s -o $dir1/config.conf https://raw.githubusercontent.com/excited-bore/dotfiles/main/neofetch/.config/neofetch/config.conf
                    file=$dir1/config.conf
                fi
                 
                function neofetch_conf() {
                    mkdir -p ~/.config/neofetch 
                    cp -fbv $file ~/.config/neofetch/ 
                }
                yes_edit_no neofetch_conf "$file" "Install neofetch config.conf at $HOME/.config/neofetch/?" "yes" "GREEN"; 
            fi
        elif test "$sym2" == "fast"; then 
            if test $distro_base == "Debian"; then
                if ! type jq &> /dev/null; then
                    sudo apt install jq
                fi
                if [[ $arch =~ "arm" ]]; then 
                   fetch_arch="armv7l"
                elif [[ $arch =~ "x86_64" ]]; then
                   fetch_arch="aarch64"
                elif [[ $arch =~ "amd64" ]]; then
                   fetch_arch="amd64"
                fi
                os="linux"
                ltstv=$(curl -sL https://api.github.com/repos/fastfetch-cli/fastfetch/releases/latest | jq -r ".tag_name")
                tmp=$(mktemp -d)
                wget -P $tmp https://github.com/fastfetch-cli/fastfetch/releases/download/$ltstv/fastfetch-$os-$fetch_arch.deb
                sudo dpkg -i $tmp/fastfetch-$os-$fetch_arch.deb 
            elif test $distro_base == "Arch"; then
               sudo pacman -S fastfetch
            fi
        elif test "$sym2" == "screen"; then      
            if test $distro_base == "Debian"; then
               sudo apt install screenfetch
            elif test $distro_base == "Arch"; then
               sudo pacman -S screenFetch
            fi
        fi
    #fi
fi
