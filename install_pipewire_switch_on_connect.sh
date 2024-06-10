#!/bin/bash
#https://bbs.archlinux.org/viewtopic.php?id=271850
if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi

if ! type update_system &> /dev/null; then
    if ! test -f update_system.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/update_system.sh)" 
    else
        . ./update_system.sh
    fi
    update_system
else
    reade -Q "CYAN" -i "n" -p "Update system? [Y/n]: " "y n" updatesysm
    if test $updatesysm == "y"; then
        update_system                     
    fi
fi

if [ "$distro" == "Manjaro" ]; then
    sudo pacman -S pipewire pipewire-pulse manjaro-pipewire
elif [ "$distro" == "Arch" ]; then
    sudo pacman -S pipewire pipewire-pulse
elif [ "$distro_base" == "Debian" ]; then
    sudo apt install pipewire
fi 

mkdir -p ~/.config/pipewire/pipewire-pulse.conf.d/
mkdir -p /etc/pipewire/pipewire-pulse.conf.d/
mkdir -p ~/.config/systemd/user/

conf=~/.config/pipewire/pipewire-pulse.conf.d/switch-on-connect.conf

if [ ! -e $conf ] || ! grep -q "# override for pipewire-pulse.conf file" $conf; then
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

if ! sudo grep -q "load-module module-switch-on-connect" /etc/pulse/default.pa; then
    sudo sed -i "s,\(load-module module-switch-on-port-available\),\1\nload-module module-switch-on-connect,g" /etc/pulse/default.pa
fi

# pactl list for full list
read -p "Unlist Dualshock 4 from audio sources? [Y/n]: " ds4
if [ -z $ds4 ] || [ "y" == $ds4 ] || [ "Y" == $ds4 ]; then
    pactl set-card-profile alsa_card.usb-Sony_Interactive_Entertainment_Wireless_Controller-00 off
fi

printf "Added pipewire conf at: \n~/.config/pipewire/pipewire-pulse.conf.d\n /etc/pipewire/pipewire.conf.d/\n $servFile\n /etc/pulse/default.pa\n"

