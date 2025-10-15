if ! test -f checks/check_all.sh; then
    if hash curl &> /dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ./checks/check_all.sh
fi


if ! test -f checks/check_envvar_aliases_completions_keybinds.sh; then
     source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_envvar_aliases_completions_keybinds.sh) 
else
    . ./checks/check_envvar_aliases_completions_keybinds.sh
fi


if ! hash nix &> /dev/null; then
    reade -Q 'GREEN' -i 'system user' -p "Install nix systemwide or only $USER [System/user]: " glob
    if [[ $glob == 'system' ]]; then
        sh <(wget-curl https://nixos.org/nix/install) --daemon
    else
        sh <(wget-curl https://nixos.org/nix/install) --no-daemon	
    fi
fi

if hash nix &> /dev/null; then
    local nixsh=$(pwd)/aliases/.aliases.d/nix.sh
    if ! test -f $nixsh; then
       tmp=$(mktemp) && wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.aliases.d/nix.sh > $tmp
       nixsh=$tmp
    fi

    function ins_nix_r(){
        sudo cp $nixsh /root/.aliases.d/
    }	

    function ins_nix(){
        cp $nixsh ~/.aliases.d/nix.sh
        yes-edit-no -f ins_nix_r -g "$nixsh" -p "Install nix.sh to /root? (nix bash aliases)" 
    }	
    yes-edit-no -f ins_nix -g "$nixsh" -p "Install nix.sh to $HOME? (nix bash aliases)"

    if [[ $distro == "Raspbian" && $(uname -m) == "aarch64" ]]; then
        echo "system = aarch64-linux" | sudo tee -a /etc/nix/nix.conf
    fi
    nix-shell -p nix-info --run nix-info
fi

