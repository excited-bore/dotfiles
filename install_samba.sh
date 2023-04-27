 DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. $DIR/check_distro.sh

if [[ $dist == "Manjaro" || $dist == "Arch" ]];then
    sudo pacman -Su samba
elif [[ $dist == "Debian" || $dist == "Raspbian" ]];then
    sudo apt install samba samba-common  
fi

read -p "Drive name: (doesn't matter):" drive
read -e -p "Mount point (path name):" mnt
read -p "Writeable: [Y/n]:" write
read -p "Public [Y/n]:" public
read -p "Create file mask (Default: 0777):" fmask
read -p "Directory mask (Default: 0777):" dmask

if [[ -z $write || "y" == $write ]]; then
    write="yes"
else
    write="no"
fi

if [[ -z $public || "y" == $public ]]; then
    public="yes"
else
    public="no"
fi

if [ -z $fmask ]; then
    fmask=0777
else
    fmask=0777
fi

if [ -z $dmask ]; then
    dmask=0777
else
    dmask=0777
fi


printf "\n[$drive]
    Path=$mnt
    Writeable=$write
    Public=$public
    Create mask=$fmask
    Directory mask=$dmask" | sudo tee -a /etc/samba/smb.conf

echo ""

read -p "User for login to drive? (Default $USER): " usr
read -p "No password? (You will have to set it otherwise) [Y/n]: " nopswd
if [ -z $usr ]; then
    usr=$USER
fi

sudo smbpasswd -a $usr
#if [[ -z $nopswd || "y" == $nopswd ]]; then
#    sudo smbpasswd -n $usr
#    printf "\n  null passwords=yes" | sudo tee -a /etc/samba/smb.conf
#    printf "Set no password for $usr"
#else    
#    sudo smbpasswd -a -n $usr
#fi

sudo systemctl restart smbd.service
sudo systemctl status smbd.service
