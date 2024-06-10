if ! test -f checks/check_system.sh.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi 

if ! type update_system &> /dev/null; then
    if ! test -f update_system.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/update_system.sh)" 
    else
        . ./update_system.sh
    fi
fi

if test -z $SYSTEM_UPDATED; then
    reade -Q "CYAN" -i "n" -p "Update system? [Y/n]: " "y" updatesysm
    if test $updatesysm == "y"; then
        update_system                     
    fi
fi
#if [ $dist == "Raspbian" ]; then
#    read -p "Install 64bit kernel before install nix? [Y/n]: " newkrn
#    if [[ -z $newkrn || "y" == $newkrn ]]; then
#        . ./install_rpi_64bit_kernel.sh
#    fi
#fi

#https://christitus.com/nix-package-manager/

sudo mkdir -m 0755 /nix && chown $USER /nix
sh <(curl -L https://nixos.org/nix/install) --daemon

read -p "Install nix.sh (nix bash aliases) [Y/n}: " nix
if [[ -z $nix || "y" == $nix ]]; then
    if [ ! -d ~/.bash_aliases.d ]; then
        mkdir ~/.bash_aliases.d/
    fi
     if ! grep -q "~/.bash_aliases.d" ~/.bashrc; then

        echo "if [[ -d ~/.bash_aliases.d/ ]]; then" >> ~/.bashrc
        echo "  for alias in ~/.bash_aliases.d/*.sh; do" >> ~/.bashrc
        echo "      . \"\$alias\" " >> ~/.bashrc
        echo "  done" >> ~/.bashrc
        echo "fi" >> ~/.bashrc
    fi
    cp -f Applications/nix.sh ~/.bash_aliases.d/nix.sh
    read -p "Install nix.sh for root? [Y/n]: " rnix
    if [[ -z $rnix || "y" == $rnix ]]; then
        if ! sudo test -d /root/.bash_aliases.d; then
            sudo mkdir /root/.bash_aliases.d/
        fi
        if ! sudo grep -q "/root/.bash_aliases.d" /root/.bashrc; then

            printf "\nif [[ -d /root/.bash_aliases.d/ ]]; then\n  for alias in /root/.bash_aliases.d/*.sh; do\n      . \"\$alias\" \n  done\nfi" | sudo tee -a /root/.bashrc > /dev/null
        fi
        sudo cp -f Applications/nix.sh /root/.bash_aliases.d/
    fi
fi

if [[ $distro == "Raspbian" && $(uname -m) == "aarch64" ]]; then
    echo "system = aarch64-linux" | sudo tee -a /etc/nix/nix.conf
fi

nix-shell -p nix-info --run nix-info
