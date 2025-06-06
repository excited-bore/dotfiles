if ! test -f checks/check_all.sh; then
    if type curl &> /dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh) 
    else 
        printf "If not downloading/git cloning the scriptfolder, you should at least install 'curl' beforehand when expecting any sort of succesfull result...\n" 
        return 1 || exit 1 
    fi
else
    . ./checks/check_all.sh
fi

DIR=$(get-script-dir) 

if ! hash cargo &> /dev/null || ! [[ $PATH =~ '/.cargo/bin' ]] || (hash rustc &> /dev/null && [[ $(rustc -V | awk '{print $2}') < 1.81.0 ]]); then
    if ! test -f $DIR/install_cargo.sh; then
        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_cargo.sh)
    else
       . $DIR/install_cargo.sh
    fi
fi

hash dust &> /dev/null && dust=$(dust -V | awk '{print $2;}')
carv=$(cargo search 'dust =' 2> /dev/null | awk 'NR==1{print $3;}' | tr '"' ' ' | sed 's/ //g')
if ! hash dust &> /dev/null || (test -n "$dust" && version-higher "$carv" "$dust"); then
    if hash dust &> /dev/null && test -n "$pac_rm"; then
        yes | eval "${pac_rm}" dust
    else
        printf "Installing cargo version for dust (latest) but unable to remove current version for dua.\n Package manager probably unkown, try uninstalling manually.\n"
    fi
    cargo install --locked du-dust 
    #if test $distro_base == 'Arch'; then
    #    eval "$pac_ins eza"
    #elif test $distro_base == 'Debian'; then
    #    eval "$pac_up" 
    #    eval "$pac_ins gpg"
    #    sudo mkdir -p /etc/apt/keyrings
    #    wget https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
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

unset ezv carv

dust --help | $PAGER 
