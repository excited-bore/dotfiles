#!/bin/bash

#DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
# https://unix.stackexchange.com/questions/278631/bash-script-auto-complete-for-user-input-based-on-array-data

if ! test -f rlwrap-scripts/reade; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/rlwrap-scripts/reade)" &> /dev/null 
else
    . ./rlwrap-scripts/reade &> /dev/null
fi

if ! test -f rlwrap-scripts/readyn; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/rlwrap-scripts/readyn)" &> /dev/null 
else
    . ./rlwrap-scripts/readyn &> /dev/null
fi

lsblk --all --exclude 7 -o NAME,SIZE,FSTYPE,MOUNTPOINT,LABEL,UUID

printf "\n${bold}Currently in /etc/fstab: ${normal}\n"

cat /etc/fstab | tail +7

printf "\n$(sudo blkid | grep -v 'loop' | perl -pe "s| LABEL=\"(.*?)\"| LABEL=\"${GREEN}\1\"${normal}|g" | tac)\n\n"

readecomp=($(sudo blkid | awk 'BEGIN { FS = ":" };{print $1;}' | grep -v 'loop' | tac))
drives="${readecomp[@]}"

reade -Q "GREEN" -i "/dev/ $drives" -p "Choose drive to mount: " drive
reade -Q "GREEN" -i "/mnt" -p "Mount point? (will make if not exists): " -e mnt

if [ ! -d $mnt ]; then
    sudo mkdir -p $mnt
    echo "Created $mnt"
fi

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
    readyn -p "Set permissions for $mnt to $USER:$USER using 'sudo chown -R'?: " chown_stff
    if test "$chown_stff" == "y"; then
        sudo chown -R $USER:$USER $mnt
    fi
fi

readyn -Y 'YELLOW' -p "Will write '$uuid $mnt $type_fs $attr' to /etc/fstab. Ok?" ok
if [ -z $ok ] || [ $ok == "y" ]; then
   echo "$uuid $mnt $type_fs $attr" | sudo tee -a /etc/fstab 
fi

printf "\n${bold}Currently in /etc/fstab: ${normal}\n"
cat /etc/fstab | tail +7

#unset readecomp drives drive mnt uuid type_fs attr chown_stff ok
