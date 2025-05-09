#/bin/bash

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

if ! test -f checks/check_envvar_aliases_completions_keybinds.sh; then
     source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_envvar_aliases_completions_keybinds.sh) 
else
    . ./checks/check_envvar_aliases_completions_keybinds.sh
fi


if ! type nix &> /dev/null; then
    reade -Q 'GREEN' -i 'system user' -p "Install nix systemwide or only $USER [System/user]: " glob
    if [[ $glob == 'system' ]]; then
        sh <(curl -L https://nixos.org/nix/install) --daemon
    else
        sh <(curl -L https://nixos.org/nix/install) --no-daemon	
    fi
fi

if type nix &> /dev/null; then
    local nixsh=$(pwd)/aliases/.bash_aliases.d/nix.sh
    if ! test -f $nixsh; then
       tmp=$(mktemp) && curl -o $tmp https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/nix.sh
       nixsh=$tmp
    fi

    function ins_nix_r(){
        sudo cp -vf $nixsh /root/.bash_aliases.d/
    }	

    function ins_nix(){
        cp -vf $nixsh ~/.bash_aliases.d/nix.sh
        yes-edit-no -f ins_nix_r -g "$nixsh" -p "Install nix.sh to /root? (nix bash aliases)" 
    }	
    yes-edit-no -f ins_nix -g "$nixsh" -p "Install nix.sh to $HOME? (nix bash aliases)"

    if [[ $distro == "Raspbian" && $(uname -m) == "aarch64" ]]; then
        echo "system = aarch64-linux" | sudo tee -a /etc/nix/nix.conf
    fi
    nix-shell -p nix-info --run nix-info
fi

