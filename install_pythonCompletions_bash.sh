 # DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. ./check_distro.sh
. ./readline/reade.sh

if [ ! -d ~/.bash_completion.d ]; then
    mkdir ~/.bash_completion.d
fi

if [[ $dist == "Raspbian" || $dist == "Debian" ]]; then
    sudo apt install python3 python3-pip
    python3 -m pip install argcomplete
elif [[ $dist == "Manjaro" || $dist == "Arch" ]]; then
    sudo pacman -Su python python-pip
    pip3 install argcomplete
fi

activate-global-python-argcomplete --dest=/home/$USER/.bash_completion.d
if ! grep -q "python-argcomplete" ~/.bashrc; then
    echo ". ~/.bash_completion.d/python-argcomplete" >> ~/.bashrc
fi
source ~/.bashrc

reade -Q "YELLOW" -P "y" -p "Install python completion system wide? (/root/.bashrc) [Y/n]:" "y n" arg
    sleep 5
if [ "y" == "$arg" ]; then 
    if ! sudo test -d /root/.bash_completion.d; then
        sudo mkdir /root/.bash_completion.d
    fi
    sudo -H pip3 install argcomplete
    sudo activate-global-python-argcomplete --dest=/root/.bash_completion.d
    if ! sudo grep -q "python-argcomplete" /root/.bashrc; then
        printf "\n. /root/.bash_completion.d/python-argcomplete" | sudo tee -a /root/.bashrc
    fi
fi
