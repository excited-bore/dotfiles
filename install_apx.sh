. ./check_distro.sh     i
if [ $dist == "Manjaro" ]; then
    pamac install apx-git
elif [ $dist == "Arch" ]; then
    echo "Install with git-apx with AUR launcher of choice (f.ex. yay, pamac)"
elif [ $dist == "Debian" ] || [ $dist == "Raspbian" ]; then
    yes | sudo apt install docker
    if ! [ -x "$(command -v go version)" ]; then
        . ./install_go_rpi.sh
    else
        isgo=$(go version)
        if [ ! "$isgo" =~ go1.2* ]; then
            . ./install_go_rpi.sh
        fi
    fi
    . ./install_distrobox.sh
    #. ./install_docker.sh
    (cd /tmp;
    git clone https://github.com/Vanilla-OS/apx
    cd apx/
    go build -o apx main.go
    sudo install -Dm755 "./apx" "/usr/bin/apx"
    sudo install -Dm644 "./man/apx.1" "/usr/share/man/man1/apx.1"
    sudo install -Dm644 "./man/es/apx.1" "/usr/share/man/es/man1/apx.1"
    sudo install -Dm644 "./config/config.json" "/etc/apx/config.json"
    sudo sed -i "s,\(\"distroboxpath\": \"\).*,\1/home/$USER/.local/bin/distrobox\",g" /etc/apx/config.json
    )
fi

apx completion bash > ~/.bash_completion.d/complete_apx
if ! grep -q "~/.bash_completion.d/complete_apx" ~/.bashrc; then
    echo ". ~/.bash_completion.d/complete_apx" >> ~/.bashrc
fi
. ~/.bashrc
 
