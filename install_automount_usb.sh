#! /bin/bash
# https://unix.stackexchange.com/questions/278631/bash-script-auto-complete-for-user-input-based-on-array-data
readecomp=($(sudo blkid | awk 'BEGIN { FS = ":" };{print $1;}'))
drive=$(rlwrap -S 'Choose drive to mount: ' -f <(echo "${readecomp[@]}") -o cat)
read -e -p "Mount point? (will make if not exists): " mnt

if [ ! -d $mnt ]; then
    mkdir -p $mnt
    echo "Created $mnt"
fi

uuid=$(sudo blkid | grep $drive | perl -pe 's|.*?UUID="(.*?)".*|UUID=\1|')
type_fs=$(sudo blkid | grep $drive | perl -pe 's|.*?TYPE="(.*?)".*|\1|')

if [[ $type_fs == "vfat" || $type_fs == "ntfs" ]]; then
    attr="defaults,auto,users,rw,nofail,umask=000 0 0"
elif [[ $type_fs == "exfat" || $type_fs == "ext4" ]]; then
    attr="defaults,auto,users,rw,nofail 0 0"
else
    echo "Unrecognized filetype"
    exit 1
fi

read -p "Will write \"$uuid $mnt $type_fs $attr\" to /etc/fstab. Ok? [Y/n]: " ok
if [ -z $ok ] || [ $ok == "y" ]; then
   echo "$uuid $mnt $type_fs $attr" | sudo tee -a /etc/fstab 
fi
