# DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi

if ! test -f checks/check_envvar.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi

if ! test -f checks/check_completions_dir.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_completions_dir.sh)" 
else
    . ./checks/check_completions_dir.sh
fi

if ! type update-system &> /dev/null; then
    if ! test -f aliases/.bash_aliases.d/update-system.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/update-system.sh)" 
    else
        . ./aliases/.bash_aliases.d/update-system.sh
    fi
    update-system
else
    readyn -Y "CYAN" -p "Update system?" updatesysm
    if test $updatesysm == "y"; then
        update-system                     
    fi
fi  

if ! test -f install_go.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_go.sh)" 
else
    ./install_go.sh
fi
if ! test -f install_docker.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_docker.sh)" 
else
    ./install_docker.sh
fi

if [ $distro == "Manjaro" ]; then
    pamac install apx
elif test $distro_base == "Arch"; then
    #TODO integrate different AUR launchers
    eval "$AUR_ins apx" 
    #echo "Install with apx with AUR launcher of choice (f.ex. yay, pamac)"
    #return 0
elif test $distro_base == "Debian"; then
    git clone https://github.com/Vanilla-OS/apx $TMPDIR/apx
    go build $TMPDIR/apx
    sudo install -Dm755 "$TMPDIR/apx/apx" "/usr/bin/apx"
    sudo install -Dm644 "$TMPDIR/apx/man/apx.1" "/usr/share/man/man1/apx.1"
    #sudo install -Dm644 "./man/es/apx.1" "/usr/share/man/es/man1/apx.1"
    sudo install -Dm644 "$TMPDIR/apx/config/config.json" "/etc/apx/config.json"
    sudo sed -i "s,\(\"distroboxpath\": \"\).*,\1/home/$USER/.local/bin/distrobox\",g" /etc/apx/config.json
    if ! test -f install_distrobox.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_distrobox.sh)" 
     else
        . ./install_distrobox.sh
    fi
    sudo mkdir /usr/lib/apx
    sudo mv ~/.local/bin/distrobox* /usr/lib/apx
fi

if type systemctl &> /dev/null && systemctl status docker | grep -q dead; then
    systemctl start docker.service
fi

apx completion bash > ~/.bash_completion.d/complete-apx
#if ! grep -q "~/.bash_completion.d/complete_apx" ~/.bashrc; then
#    echo ". ~/.bash_completion.d/complete_apx" >> ~/.bashrc
#fi

source ~/.bashrc
