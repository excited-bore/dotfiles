### SSH ###                           
. ./rlwrap_scripts.sh

ssh_file="~/.ssh/id_ecdsa"
user="funnyman"
ip="192.168.129.17"

# To prevent 'failed to preserve ownership' errors
copy_sshfs(){ cp -r --no-preserve=mode "$1" "$2"; }
move_sshfs(){ cp -r --no-preserve=mode "$1" "$2" && rmTrash "$1"; }

copy_to_serber() { scp -r $user@$ip:$1 $2; }
#function cp_from_serber() { scp -r }


#Server access
alias serber="ssh -i $ssh_file $user@$ip"
alias serber_unmnt="fusermount3 -u /mnt/mount1/"
alias serber_unmnt1="fusermount3 -u /mnt/mount2/"

ssh_key_and_add_to_agent_by_host() {
    if [ ! -f ~/.ssh/config ]; then
        touch ~/.ssh/config;
    fi
    read -p "Give up filename: (nothing for id_keytype, sensible to leave as such in certain situations): " name
    reade -p "Give up keytype (dsa | ecdsa | ecdsa-sk | ed25519 (Default) | ed25519-sk | rsa): " "dsa ecdsa ecdsa-sk ed25519 ed25519-sk rsa" keytype
    read -p "Give up a hostname : " host
    read -p "Give up remote username: " uname  
    if [ -z $keytype ]; then
        keytype=ed25519
    fi
    if [ -z $name ]; then
        name="id_$keytype"   
    fi
    ssh-keygen -t $keytype -f ~/.ssh/$name
    ssh-add -vH ~/.ssh/known_hosts ~/.ssh/$name 
    eval $(ssh-agent -s) 
    echo "Host $host" >> ~/.ssh/config;
    echo "  IdentityFile ~/.ssh/$name" >> ~/.ssh/config
    echo "  User $uname" >> ~/.ssh/config
    echo "Public key: "
    cat ~/.ssh/$name.pub; 
}

serber_mnt() {
    if [ ! -d /mnt/mount1 ]; then
        mkdir /mnt/mount1; 
    fi;
    if [ ! -e ~/Files/Files ]; then
        sshfs $user@$ip:/mnt/MyStuff/ /mnt/mount1/ -o IdentityFile=$ssh_file,follow_symlinks,reconnect,default_permissions,uid=1000,gid=1001,workaround=rename;
    fi
}

serber_mnt1(){
    if ! [ -d /mnt/mount2 ]; then
        mkdir /mnt/mount2; 
    fi;
    if [ ! -e /mnt/mount2/.bashrc ]; then
        sshfs $user@$ip:/media/ /mnt/mount2/ -o IdentityFile=$ssh_file,follow_symlinks,reconnect,default_permissions,uid=1000,gid=1001,workaround=rename;
    fi
}                                    
