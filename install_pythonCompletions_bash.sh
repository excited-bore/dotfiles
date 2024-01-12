. ./checks/check_distro.sh
. ./readline/rlwrap_scripts.sh

if [ ! -d ~/.bash_completion.d ]; then
    mkdir ~/.bash_completion.d
fi

if [ -x "$(command -v argcomplete)" ]; then
    if [[ $distro == "Debian" || $distro_base == "Debian" ]]; then
        yes | sudo apt install python3 python3-pipx
        pipx install argcomplete
    elif [[ $distro == "Arch" || $distro_base == "Arch" ]]; then
        yes | sudo pacman -Su python python-pipx
        pipx install argcomplete
    fi
fi

activate-global-python-argcomplete --dest=/home/$USER/.bash_completion.d 
if ! grep -q "python-argcomplete" ~/.bashrc; then
    echo ". ~/.bash_completion.d/_python-argcomplete" >> ~/.bashrc
fi

reade -Q "YELLOW" -i "y" -p "Install python completion system wide? (/root/.bashrc) [Y/n]:" "y n" arg
if [ "y" == "$arg" ]; then 
    if ! sudo test -d /root/.bash_completion.d; then
        sudo mkdir /root/.bash_completion.d
    fi
    sudo activate-global-python-argcomplete --dest=/root/.bash_completion.d
    if ! sudo grep -q "python-argcomplete" /root/.bashrc; then
        printf "\n. ~/.bash_completion.d/_python-argcomplete" | sudo tee -a /root/.bashrc
    fi
fi
