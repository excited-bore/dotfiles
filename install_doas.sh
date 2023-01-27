

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
        sudo pacman -Su opendoas 
    elif [ -f $f ] && [ $f == /etc/debian_version ];then
        echo Package manager: ${osInfo[$f]}
        pm=${osInfo[$f]}
        sudo apt install doas
    fi 
done
sed -i "s/user/$USER/g" doas.conf
sudo cp -f doas.conf /etc/doas.conf

read -p "Add polkit rules? (rules at /etc/polkit-1/rules.d/) [Y/n]: " resp1
if [ -z $resp1 ]; then
    sudo cp -f 49-nopasswd_global.rules /etc/polkit-1/rules.d/49-nopasswd_global.rules
fi

read -p "Install doas.sh? (Applications/doas.sh) [Y/n]:" doas
if [ -z $doas ]; then 
    cp -f Applications/doas.sh ~/Applications/doas.sh
    if ! grep -q doas.sh ~/.bashrc; then
        echo "if [[ -f ~/Applications/doas.sh ]]; then" >> ~/.bashrc
        echo "  . ~/Applications/doas.sh" >> ~/.bashrc
        echo "fi" >> ~/.bashrc
    fi
    read -p "Install doas.sh globally? (/etc/profile.d/doas.sh [Y/n]:" gdoas  
    if [ -z $gdoas ]; then 
        sudo ln -s Applications/doas.sh /etc/profile.d/doas.sh
    fi
fi

echo "Enter: chown root:root -c /etc/doas.conf; chmod 0644 -c /etc/doas.conf; doas -C /etc/doas.conf && echo 'config ok' || echo 'config error' ";
su -;
sudo groupadd wheel && sudo usermod -aG wheel "$USER"
