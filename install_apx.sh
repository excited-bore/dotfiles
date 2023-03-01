. ./check_distro.sh
if [ $dist == "Raspbian" ]; then
    if go version | ! grep -q "go.1.2*" ; then
        . ./install_go_rpi.sh
    fi
fi
. ./install_distrobox.sh
. ./install_docker.sh

(cd /tmp;
git clone https://github.com/Vanilla-OS/apx
cd apx/
go build -o apx main.go
)
 
