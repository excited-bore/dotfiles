if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi
if ! test -f checks/check_rlwrap.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_rlwrap.sh)" 
else
    . ./checks/check_rlwrap.sh
fi 

if ! type neofetch &> /dev/null && ! type fastfetch &> /dev/null && ! type screenFetch &> /dev/null; then
    reade -Q "GREEN" -i "y" -p "Install neofetch/fastfetch/screenFetch? [Y/n]:" "y n" sym2
    if test "$sym2" == "y"; then
        
        reade -Q "GREEN" -i "neofetch" -p "Which fetch? [Neofetch/fastfetch/screenFetch]:" "neofetch fastfetch screenFetch" sym2
        if test "$sym2" == "neofetch"; then
            if test $distro_base == "Debian"; then
               sudo apt install neofetch
            elif test $distro == "Arch" || test $distro == "Manjaro"; then
               sudo pacman -S neofetch
            fi
        elif test "$sym2" == "fastfetch"; then 
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
                tmpdir=$(mktemp -d -t fast-XXXXXXXXXX)
                wget -P $tmpdir https://github.com/fastfetch-cli/fastfetch/releases/download/$ltstv/fastfetch-$os-$fetch_arch.deb
            elif test $distro == "Arch" || test $distro == "Manjaro"; then
               sudo pacman -S fastfetch
            fi
        elif  test "$sym2" == "screenFetch"; then      
            if test $distro_base == "Debian"; then
               sudo apt install screenfetch
            elif test $distro == "Arch" || test $distro == "Manjaro"; then
               sudo pacman -S screenFetch
            fi
        fi
    fi
fi
