. ./install_go.sh
. ./check_distro.sh     
if [ $dist == "Manjaro" ]; then
    yes | pamac install apx-git
    sudo usermod -aG docker $USER
elif [ $dist == "Arch" ]; then
    echo "Install with git-apx with AUR launcher of choice (f.ex. yay, pamac)"
elif [ $dist == "Debian" ] || [ $dist == "Raspbian" ]; then
    . ./install_docker.sh
    . ./install_distrobox.sh
    git clone https://github.com/Vanilla-OS/apx /tmp/apx
    cd /tmp/apx/
    go build 
    sudo install -Dm755 "./apx" "/usr/bin/apx"
    sudo install -Dm644 "./man/apx.1" "/usr/share/man/man1/apx.1"
    sudo install -Dm644 "./man/es/apx.1" "/usr/share/man/es/man1/apx.1"
    sudo install -Dm644 "./config/config.json" "/etc/apx/config.json"
    sudo sed -i "s,\(\"distroboxpath\": \"\).*,\1/home/$USER/.local/bin/distrobox\",g" /etc/apx/config.json
    sudo mkdir /usr/lib/apx
    curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/install | sh -s -- --prefix ~/.local
    sudo mv ~/.local/bin/distrobox* /usr/lib/apx
    cd -
fi

apx completion bash > ~/.bash_completion.d/complete_apx
if ! grep -q "~/.bash_completion.d/complete_apx" ~/.bashrc; then
    echo ". ~/.bash_completion.d/complete_apx" >> ~/.bashrc
fi

source ~/.bashrc
 
