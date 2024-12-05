if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi

if ! test -f checks/check_envvar_aliases_completions_keybinds.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_envvar_aliases_completions_keybinds.sh)" 
else
    . ./checks/check_envvar_aliases_completions_keybinds.sh
fi

if ! test -f aliases/.bash_aliases.d/00-rlwrap_scripts.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/00-rlwrap_scripts.sh)" 
else
    . ./aliases/.bash_aliases.d/00-rlwrap_scripts.sh
fi 

if ! type update-system &> /dev/null; then
    if ! test -f aliases/.bash_aliases.d/update-system.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/update-system.sh)" 
    else
        . ./aliases/.bash_aliases.d/update-system.sh
    fi
fi

if test -z $SYSTEM_UPDATED; then
    readyn -Y "CYAN" -p "Update system?" updatesysm
    if test $updatesysm == "y"; then
        update-system                     
    fi
fi 

if ! type nix &> /dev/null; then
reade -Q 'GREEN' -i 'system' -p "Install nix systemwide or only $USER [System/user]: " 'user' glob
    if test $glob == 'system'; then
        sh <(curl -L https://nixos.org/nix/install) --daemon
    else
        sh <(curl -L https://nixos.org/nix/install) --no-daemon	
    fi
fi

if type nix &> /dev/null; then
    nixsh=$(pwd)/aliases/.bash_aliases.d/nix.sh
    if ! test -f $nixsh; then
       tmp=$(mktemp) && curl -o $tmp https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/nix.sh
       nixsh=$tmp
    fi

    function ins_nix_r(){
        sudo cp -vf $nixsh /root/.bash_aliases.d/
    }	

    function ins_nix(){
        cp -vf $nixsh ~/.bash_aliases.d/nix.sh
        yes_edit_no ins_nix_r "$nixsh" "Install nix.sh to /root? (nix bash aliases)" "yes" "GREEN"; 
    }	
    yes_edit_no ins_nix "$nixsh" "Install nix.sh to $HOME? (nix bash aliases)" "yes" "GREEN"
    unset nixsh	

    if [[ $distro == "Raspbian" && $(uname -m) == "aarch64" ]]; then
        echo "system = aarch64-linux" | sudo tee -a /etc/nix/nix.conf
    fi
    nix-shell -p nix-info --run nix-info
fi

