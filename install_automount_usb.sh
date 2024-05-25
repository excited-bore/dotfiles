#! /bin/bash
#DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
# https://unix.stackexchange.com/questions/278631/bash-script-auto-complete-for-user-input-based-on-array-data
. ./aliases/rlwrap_scripts.sh

sudo blkid
readecomp=($(sudo blkid | awk 'BEGIN { FS = ":" };{print $1;}'))
drives="${readecomp[@]}"

reade -Q "GREEN" -i "/dev/" -p "Choose drive to mount: " "$drives" drive
reade -Q "GREEN" -i "/mnt" -p "Mount point? (will make if not exists): " -e mnt
if [ ! -d $mnt ]; then
    sudo mkdir -p $mnt
    echo "Created $mnt"
fi
sudo chown -R $USER $mnt

uuid=$(sudo blkid | grep $drive | perl -pe 's|.*?UUID="(.*?)".*|UUID=\1|')
type_fs=$(sudo blkid | grep $drive | perl -pe 's|.*?TYPE="(.*?)".*|\1|')

if [[ $type_fs == "vfat" || $type_fs == "ntfs" ]]; then
    attr="nosuid,nodev,nofail,auto,x-gvfs-show,umask=000 0 0"
elif [[ $type_fs == "exfat" || $type_fs == "ext4" ]]; then
    attr="nosuid,nodev,nofail,auto,x-gvfs-show 0 0"
else
    echo "Unrecognized filetype"
    exit 1
fi

if test "$type_fs" == "ext4"; then
    reade -Q "GREEN" -i "y" -p "Set permissions for $mnt to $USER:$USER using 'sudo chown -R'?: " chown_stff
    if test "$chown_stff" == "y"; then
        sudo chown -R $USER:$USER $mnt
    fi
fi


read -p "Will write \"$uuid $mnt $type_fs $attr\" to /etc/fstab. Ok? [Y/n]: " ok
if [ -z $ok ] || [ $ok == "y" ]; then
   echo "$uuid $mnt $type_fs $attr" | sudo tee -a /etc/fstab 
fi
