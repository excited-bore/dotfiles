if [ ! -d ~/.bash_completion.d ]; then
    mkdir ~/.bash_completion.d
fi

pip3 install argcomplete
. ~/.bashrc
activate-global-python-argcomplete --dest=$HOME/.bash_completion.d

if ! grep -q "python-argcomplete" ~/.bashrc; then
    echo ". $HOME/.bash_completion.d/python-argcomplete" >> ~/.bashrc
fi
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
