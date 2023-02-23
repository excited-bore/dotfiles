. ./check_distro.sh
if [ $dist == "Raspbian" ]; then
    read -p "Install 64bit kernel before install nix? [Y/n]: " newkrn
    if [[ -z $newkrn || "y" == $newkrn ]]; then
        . ./install_rpi_64bit_kernel.sh
    fi
fi

#https://christitus.com/nix-package-manager/

sudo mkdir -m 0755 /nix && chown $USER /nix
sh <(curl -L https://nixos.org/nix/install) --daemon

read -p "Install nix.sh (nix bash aliases) [Y/n}: " nix
if [[ -z $nix || "y" == $nix ]]; then
    cp -f Applications/nix.sh ~/.bash_aliases.d/nix.sh
    read -p "Install nix.sh for root? [Y/n]: " rnix
    if [[ -z $rnix || "y" == $rnix ]]; then
        sudo cp -f Applications/nix.sh /root/.bash_aliases.d/
    fi
fi

if [[ $dist == "Raspbian" && $(uname -m) == "aarch64" ]]; then
    echo "system = aarch64-linux" | sudo tee -a /etc/nix/nix.conf
fi

nix-shell -p nix-info --run nix-info
