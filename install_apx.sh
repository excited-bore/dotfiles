. ./check_distro.sh
if [ $dist == "Raspbian" ]; then
    if go version | grep -q "go.1.2*" ; then
        . ./install_go_rpi.sh
    fi
fi
. ./install_distrobox.sh
. ./install_docker.sh

(cd /tmp;
git clone https://github.com/Vanilla-OS/apx
cd apx/
go build -o apx main.go
sudo install -Dm755 "./apx" "/usr/bin/apx"
sudo install -Dm644 "./man/apx.1" "/usr/share/man/man1/apx.1"
sudo install -Dm644 "./man/es/apx.1" "/usr/share/man/es/man1/apx.1"
sed -i "s,\(\"distroboxpath\": \"\).*,\1/home/$USER/.local/bin/distrobox,g" /etc/apx/config.json
sudo install -Dm644 "./config/config.json" "/etc/apx/config.json"
)
 
