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

if ! type cargo &> /dev/null; then
    if ! test -f install_cargo.sh; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_cargo.sh)"
    else
       ./install_cargo.sh
    fi
fi

type eza &> /dev/null && ezv=$(eza -v | awk 'NR==2{print $1;}' | tr 'v' ' ')
carv=$(cargo search 'eza = # A modern replacement for ls' | awk 'NR==1{print $3;}' | tr '"' ' ')

if ! type eza &> /dev/null || version-higher $carv $ezv; then
    if type eza &> /dev/null && ! test -z "$pac_rm"; then
        yes | ${pac_rm} eza   
    else
        printf "Installing cargo version for eza (latest) but unable to remove current version for eza.\n Package manager probably unkown, try uninstalling manually.\n"
    fi
    cargo install --locked eza  
    #if test $distro_base == 'Arch'; then
    #    eval "$pac_ins eza"
    #elif test $distro_base == 'Debian'; then
    #    eval "$pac_up" 
    #    eval "$pac_ins gpg"
    #    sudo mkdir -p /etc/apt/keyrings
    #    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
    #    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
    #    sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list 
    #    eval "$pac_up" 
    #    eval "$pac_ins eza"
    #elif test $distro == 'Fedora'; then
    #    sudo dnf install eza 
    #elif test $distro == 'Gentoo'; then
    #    emerge --ask sys-apps/eza
    #elif test $distro == 'openSuse'; then
    #    zypper ar https://download.opensuse.org/tumbleweed/repo/oss/ factory-oss
    #    zypper in eza
    #elif test $machine == 'Mac' && type brew &> /dev/null; then
    #    brew install eza 
    #elif test $machine == 'Windows'; then
    #    winget install eza
    #elif type nix-env &> /dev/null; then
    #    nix-env -i eza
    #elif test $distro_base == "Nix"; then
    #    nix profile install nixpkgs#eza
    #else 
    #    cargo install eza 
    #fi
fi

if ! test -f ~/.bash_completion.d/eza; then
   reade -Q 'GREEN' -i 'y' -p 'Install bash completions for eza? [Y/n]: ' 'n' bash_cm  
   if test $bash_cm == 'y'; then
        if ! test -f checks/check_completions_dir.sh; then
             eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_completions_dir.sh)" 
        else
            . ./checks/check_completions_dir.sh
        fi
        wget -P ~/.bash_completion.d/ https://raw.githubusercontent.com/eza-community/eza/refs/heads/main/completions/bash/eza
   fi
fi
unset bash_cm