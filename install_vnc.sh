declare -A osInfo;
osInfo[/etc/redhat-release]=yum
osInfo[/etc/arch-release]=pacman
osInfo[/etc/gentoo-release]=emerge
osInfo[/etc/SuSE-release]=zypp
osInfo[/etc/debian_version]=apt
osInfo[/etc/alpine-release]=apk

pm=/
for f in ${!osInfo[@]}
do
    if [ -f $f ] && [ $f == /etc/arch-release ];then
        echo Package manager: ${osInfo[$f]}
        pm=${osInfo[$f]}
        sudo pacman -Su remmina
    elif [ -f $f ] && [ $f == /etc/debian_version ];then
        echo Package manager: ${osInfo[$f]}
        pm=${osInfo[$f]}
        sudo apt update && sudo apt install realvnc-vnc-server realvnc-vnc-viewer
    fi 
done
if ! sudo grep -q VncAuth /root/.vnc/config.d/vncserver-x11; then
    echo "Execute: echo \"Authentication=VncAuth\" >> /root/.vnc/config.d/vncserver-x11"
    sudo -i
fi
sudo vncpasswd -service
sudo systemctl restart vncserver-x11-serviced.service
