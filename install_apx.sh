. ./check_distro.sh
if [ $dist == "Raspbian" ]; then
    . ./install_go_rpi.sh
fi
. ./install_distrobox.sh
. ./install_docker.sh

(cd /tmp;
git clone https://github.com/Vanilla-OS/apx
cd apx/
go build -o apx main.go
)

