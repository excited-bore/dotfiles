#!/bin/bash

if ! test -f checks/check_all.sh; then
    if type curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        printf "If not downloading/git cloning the scriptfolder, you should at least install 'curl' beforehand when expecting any sort of succesfull result...\n"
        return 1 || exit 1
    fi
else
    . ./checks/check_all.sh
fi

if ! test -f checks/check_completions_dir.sh; then
     source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_completions_dir.sh) 
else
    . ./checks/check_completions_dir.sh
fi

if ! test -f checks/check_AUR.sh; then
     source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_AUR.sh)
else
    . ./checks/check_AUR.sh
fi

if ! test -f install_go.sh; then
     source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_go.sh)
else
    . ./install_go.sh
fi

if ! test -f install_docker.sh; then
     source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_docker.sh)
else
    . ./install_docker.sh
fi

if [[ $distro_base == "Arch" ]]; then
    #TODO integrate different AUR launchers
    eval "$AUR_ins apx" 
    #echo "Install with apx with AUR launcher of choice (f.ex. yay, pamac)"
    #return 0
elif [[ $distro_base == "Debian" ]]; then
    git clone https://github.com/Vanilla-OS/apx $TMPDIR/apx
    go build $TMPDIR/apx
    sudo install -Dm755 "$TMPDIR/apx/apx" "/usr/bin/apx"
    sudo install -Dm644 "$TMPDIR/apx/man/apx.1" "/usr/share/man/man1/apx.1"
    #sudo install -Dm644 "./man/es/apx.1" "/usr/share/man/es/man1/apx.1"
    sudo install -Dm644 "$TMPDIR/apx/config/config.json" "/etc/apx/config.json"
    sudo sed -i "s,\(\"distroboxpath\": \"\).*,\1/home/$USER/.local/bin/distrobox\",g" /etc/apx/config.json
    if ! test -f install_distrobox.sh; then
        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_distrobox.sh) 
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

test -n $BASH_VERSION && source ~/.bashrc
test -n $ZSH_VERSION && source ~/.zshrc

