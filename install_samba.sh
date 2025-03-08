if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi

if ! type update-system &> /dev/null; then
    if ! test -f aliases/.bash_aliases.d/update-system.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/update-system.sh)" 
    else
        . ./aliases/.bash_aliases.d/update-system.sh
    fi
fi

if test -z $SYSTEM_UPDATED; then
    readyn -Y "CYAN" -p "Update system?" updatesysm
    if test $updatesysm == "y"; then
        update-system                     
    fi
fi
if ! type reade &> /dev/null; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/00-rlwrap_scripts.sh)" 
else
    . ./aliases/.bash_aliases.d/00-rlwrap_scripts.sh
fi

if ! command -v samba &> /dev/null; then
    if test "$distro" == "Arch" || test "$distro" == "Manjaro"; then
        eval "$pac_ins samba"
    elif [ $distro_base == "Debian" ];then
        eval "$pac_ins samba samba-common  "
    fi
fi

sudo usermod -aG sambashare $USER

wordcomp=""
for i in $(seq 1 7); do
    for j in $(seq 1 7); do
        for k in $(seq 1 7); do  
            wordcomp="$wordcomp 0$i$j$k"
        done
    done
done

reade -Q "GREEN" -p "Drive name: (doesn't matter): "  drive
if ! test "$drive"; then
    printf "${red}Drive name can't be empty\n${normal}"
    #exit 1
elif sudo grep -q "$drive" /etc/samba/smb.conf; then
    printf "${red}Drive name already taken\n${normal}"
    #exit 1
fi
reade -Q "GREEN" -i "/mnt" -p "Mount point (path name): " -e mnt
readyn -p "Browseable: " browse
readyn -p "Writeable: " write
readyn -p "Public" public
reade -Q "GREEN" -i "0777 $wordcomp" -p "Create file mask (Default: 0777): " fmask
reade -Q "GREEN" -i "0777 $wordcomp" -p "Directory mask (Default: 0777): " dmask

if [[ -z $write || "y" == $write ]]; then
    write="yes"
else
    write="no"
fi

if [[ -z $browse || "y" == $browse ]]; then
    browse="yes"
else
    browse="no"
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
    Browseable=$browse
    Writeable=$write
    Public=$public
    Create mask=$fmask
    Directory mask=$dmask" | sudo tee -a /etc/samba/smb.conf &> /dev/null

readyn -Y "YELLOW"  -p "Edit /etc/samba/smb.conf" edit
if test "$edit" == "y"; then
    sudo $EDITOR /etc/samba/smb.conf
fi

reade -Q "GREEN" -i "$USER $(users)" -p "User $USER for login to drive?: " usr
readyn -p "No password? (You will have to set it otherwise)" nopswd
if ! test "$usr" ; then
    usr=$USER
fi

if test "$nopswd" == "y"; then
    if ! sudo grep -q 'null passwords' /etc/samba/smb.conf; then
        sudo sed -i 's|\(####### Authentication #######\)|\1\n\nnull passwords = yes|g' /etc/samba/smb.conf
    fi
    sudo smbpasswd -na $usr
else
    sudo smbpasswd -a $usr
fi
sudo systemctl restart smbd.service
sudo systemctl status smbd.service

sudo systemctl restart nmbd.service
sudo systemctl status nmbd.service
