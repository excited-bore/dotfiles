. ./check_distro.sh
if [ ! -d ~/.bash_completion.d ]; then
    mkdir ~/.bash_completion.d
fi

if [[ $dist == "Raspbian" || $dist == "Debian" ]]; then
    sudo apt install python3 python3-pip
    pip3 install argcomplete
elif [[ $dist == "Manjaro" || $dist == "Arch" ]]; then
    sudo pacman -Su python python-pip
    pip3 install argcomplete
fi


source ~/.bashrc
activate-global-python-argcomplete --dest=/home/$USER/.bash_completion.d
if ! grep -q "python-argcomplete" ~/.bashrc; then
    echo ". ~/.bash_completion.d/python-argcomplete" >> ~/.bashrc
fi
source ~/.bashrc

read -p "Install python completion system wide? (/root/.bashrc) [Y/n]:" arg
if [ -z $arg ] || [ "y" == $arg ]; then 
    if ! sudo test -d /root/.bash_completion.d; then
        sudo mkdir /root/.bash_completion.d
    fi
    sudo -H pip3 install argcomplete
    sudo activate-global-python-argcomplete --dest=/root/.bash_completion.d
    if ! sudo grep -q "python-argcomplete" /root/.bashrc; then
        printf "\n. /root/.bash_completion.d/python-argcomplete" | sudo tee -a /root/.bashrc
    fi
fi
