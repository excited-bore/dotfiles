### SSH ###

# To prevent 'failed to preserve ownership' errors
copy_sshfs(){ cp -r --no-preserve=mode "$1" "$2"; }
move_sshfs(){ cp -r --no-preserve=mode "$1" "$2" && rmTrash "$1"; }

copy_to_serber() { scp -r funnyman@192.168.129.17$1 $2; }
#function cp_from_serber() { scp -r }

ssh_file="~/.ssh/id_ed25519"

#Server access
alias serber="ssh -i $ssh_file funnyman@192.168.129.17"
alias kserber="kitty +kitten ssh -i $ssh_file funnyman@192.168.129.17"
alias serber_unmnt="fusermount3 -u /mnt/mount1/"
alias serber_unmnt1="fusermount3 -u /mnt/mount2/"

ssh_key_and_add_to_agent_by_host() {
    if [ ! -f ~/.ssh/config ]; then
        touch ~/.ssh/config;
    fi
    read -p "Give up a hostname: " host
    read -p "Give up filename: (nothing for standard id, else it's sensible to got for ~/.ssh/name)" name
    read -p "Give up remote username: " uname  
    echo "$name" | ssh-keygen -t ed25519
    ssh-add -vH ~/.ssh/known_hosts "$name" 
    eval $(ssh-agent -s) 
    echo "Host $host" >> ~/.ssh/config;
    echo "  IdentityFile $name" >> ~/.ssh/config
    echo "  User $uname" >> ~/.ssh/config 
    cat $name.pub; 
}

serber_mnt() {
    if [ ! -d /mnt/mount1 ]; then
        mkdir /mnt/mount1; 
    fi;
    if [ ! -e ~/Files/Files ]; then
        sshfs funnyman@192.168.129.17:/mnt/MyStuff/ /mnt/mount1/ -o IdentityFile=$ssh_file,follow_symlinks,reconnect,default_permissions,uid=1000,gid=1001,workaround=rename;
    fi
}

serber_mnt1(){
    if ! [ -d /mnt/mount2 ]; then
        mkdir /mnt/mount2; 
    fi;
    if [ ! -e /mnt/mount2/.bashrc ]; then
        sshfs burpi@192.168.129.17:/media/ /mnt/mount2/ -o IdentityFile=$ssh_file,follow_symlinks,reconnect,default_permissions,uid=1000,gid=1001,workaround=rename;
    fi
}                 
