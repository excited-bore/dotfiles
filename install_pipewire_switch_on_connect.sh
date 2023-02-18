#!/bin/bash
#https://bbs.archlinux.org/viewtopic.php?id=271850
. ./check_distro.sh

if [ $dist == "Manjaro" ]; then
    sudo pacman -Su pipewire pipewire-pulse manjaro-pipewire
elif [ $dist == "Arch" ]; then
    sudo pacman -Su pipewire pipewire-pulse
elif [ $dist == "Debian" ]; then
    sudo apt install pipewire
fi 

mkdir -p ~/.config/pipewire/pipewire-pulse.conf.d/
mkdir -p /etc/pipewire/pipewire-pulse.conf.d/
mkdir -p ~/.config/systemd/user/

conf=~/.config/pipewire/pipewire-pulse.conf.d/switch-on-connect.conf

if [ ! -e $conf ] || ! grep -q "# override for pipewire-pulse.conf ile" $conf; then
    echo "# override for pipewire-pulse.conf file" >> $conf
    echo "pulse.cmd = [" >> $conf
    echo "  { cmd = \"load-module\" args = \"module-always-sink\" flags = [ ] }" >> $conf
    echo "  { cmd = \"load-module\" args = \"module-switch-on-connect\" }" >> $conf
    echo "]" >> $conf
fi
sudo mv -f $conf /etc/pipewire/pipewire-pulse.conf.d

serv="pipewire-load-switch-on-connect"
servF="$serv.service"
myuser="$USER"
servFile=/etc/systemd/user/$serv.service;
touch $servF
echo "[Unit]" >> $servF;
echo "Description=$serv service." >> $servF;

echo "[Service]" >> $servF;
echo "ExecStart=sudo -u $myuser env XDG_RUNTIME_DIR=/run/user/$(id -u $myuser) /usr/bin/pactl load-module module-switch-on-connect" >> $servF;

echo "[Install]" >> $servF;
echo "WantedBy=default.target" >> $servF;

sudo mv -f $servF $servFile
systemctl --user enable --now $servFile

printf "Added pipewire conf at: \n~/.config/pipewire/pipewire-pulse.conf.d\n /etc/pipewire/pipewire.conf.d/\n $servFile\n"

