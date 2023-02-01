read -p "Drive name: (doesn't matter)" drive

read -p "Mount point (path name): " mnt
read -p "Writeable: [Y/n]" write
read -p "Public [Y/n]" public
read -p "Create file mask: (Default: 0777)" fmask
read -p "Directory mask: (Default: 0777)" dmask

if [ -z write ]; then
    write="yes"
else
    write="no"
fi

if [ -z public ]; then
    write='yes'
else
    write='no'
fi

echo "[$drive]" >> /etc/samba/smb.conf
echo "path=$mnt" >> /etc/samba/smb.conf
echo "writeable=$write" >> /etc/samba/smb.conf
echo "public=$public" >> /etc/samba/smb.conf
echo "create mask=$fmask" >> /etc/samba/smb.conf
echo "directory mas=$dmask" >> /etc/samba/smb.conf
