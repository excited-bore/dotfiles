read -p "Drive name: (doesn't matter):" drive
read -e -p "Mount point (path name):" mnt
read -p "Writeable: [Y/n]:" write
read -p "Public [Y/n]:" public
read -p "Create file mask (Default: 0777):" fmask
read -p "Directory mask (Default: 0777):" dmask

if [ -z write ]; then
    write="yes"
else
    write="no"
fi

if [ -z public ]; then
    public="yes"
else
    public="no"
fi

if [ -z fmask ]; then
    fmask=0777
else
    fmask=0777
fi

if [ -z dmask ]; then
    dmask=0777
else
    dmask=0777
fi

. ./check_distro.sh

if [[ $dist == "Manjaro" || $dist == "Arch" ]];then
    sudo pacman -Su samba
elif [ $dist == "Debian" ];then
    sudo apt install samba samba-common  
fi

read -p "User for login to drive? (Default $USER):" usr
read -p "Password? (Default: No password" pswd
if [ -z $usr ]; then
    $usr=$USER
fi

if [ -z $pswd ]; then
    smbpasswd -n $USER
else
    smbpasswd -w $pswd $usr
fi


printf "[$drive]
Path=$mnt
Writeable=$write
Public=$public
Create mask=$fmask
Directory mask=$dmask" | sudo tee -a /etc/samba/smb.conf


sudo systemctl restart smbd.conf
sudo systemctl status smbd.conf
