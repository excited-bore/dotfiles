# DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. ./install_go.sh
. ./checks/check_distro.sh     
. ./install_docker.sh
if [ $distro == "Manjaro" ]; then
    yes | pamac install apx
elif [ $distro == "Arch" ]; then
    echo "Install with apx with AUR launcher of choice (f.ex. yay, pamac)"
    return 0
elif [ $distro == "Debian" ] || [ $distro_base == "Debian" ]; then
    git clone https://github.com/Vanilla-OS/apx /tmp/apx
    go build /tmp/apx
    sudo install -Dm755 "/tmp/apx/apx" "/usr/bin/apx"
    sudo install -Dm644 "/tmp/apx/man/apx.1" "/usr/share/man/man1/apx.1"
    #sudo install -Dm644 "./man/es/apx.1" "/usr/share/man/es/man1/apx.1"
    sudo install -Dm644 "/tmp/apx/config/config.json" "/etc/apx/config.json"
    sudo sed -i "s,\(\"distroboxpath\": \"\).*,\1/home/$USER/.local/bin/distrobox\",g" /etc/apx/config.json
    . ./install_distrobox.sh
    sudo mkdir /usr/lib/apx
    sudo mv ~/.local/bin/distrobox* /usr/lib/apx
fi

apx completion bash > ~/.bash_completion.d/complete_apx
if ! grep -q "~/.bash_completion.d/complete_apx" ~/.bashrc; then
    echo ". ~/.bash_completion.d/complete_apx" >> ~/.bashrc
fi

source ~/.bashrc
 
