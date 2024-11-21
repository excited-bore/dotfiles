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

if ! type eza &> /dev/null; then
    if test $distro_base == 'Arch'; then
        eval "$pac_ins eza"
    elif test $distro_base == 'Debian'; then
        eval "$pac_up" 
        eval "$pac_ins gpg"
        sudo mkdir -p /etc/apt/keyrings
        wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
        echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
        sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list 
        eval "$pac_up" 
        eval "$pac_ins eza"
    elif test $distro == 'Fedora'; then
        sudo dnf install eza 
    elif test $distro == 'Gentoo'; then
        emerge --ask sys-apps/eza
    elif test $distro == 'openSuse'; then
        zypper ar https://download.opensuse.org/tumbleweed/repo/oss/ factory-oss
        zypper in eza
    elif test $machine == 'Mac' && type brew &> /dev/null; then
        brew install eza 
    elif test $machine == 'Windows'; then
        winget install eza
    elif type nix-env &> /dev/null; then
        nix-env -i eza
    elif test $distro_base == "Nix"; then
        nix profile install nixpkgs#eza
    else 
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
        cargo install eza 
    fi
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
