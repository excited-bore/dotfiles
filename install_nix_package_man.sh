#https://christitus.com/nix-package-manager/
sh <(curl -L https://nixos.org/nix/install) --daemon

read -p "Install nix.sh (nix bash aliases) [Y/n}: " nix
if [[ -z $nix || "y" == $nix ]]; then
    cp -f Applications/nix.sh ~/.bash_aliases.d/nix.sh
    read -p "Install nix.sh for root? [Y/n]: " rnix
    if [[ -z $rnix || "y" == $rnix ]]; then
        sudo cp -f Applications/nix.sh /root/.bash_aliases.d/
    fi
fi

nix-shell -p nix-info --run nix-info
