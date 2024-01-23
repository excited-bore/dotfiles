### SSH ###                           
. ~/.bash_aliases.d/rlwrap_scripts.sh

ssh_file="~/.ssh/id_rsa"
user="burp"
ip="192.168.0.140"

# To prevent 'failed to preserve ownership' errors
copy_sshfs(){ cp -r --no-preserve=mode "$1" "$2"; }
move_sshfs(){ cp -r --no-preserve=mode "$1" "$2" && rmTrash "$1"; }

copy_to_serber() { scp -r $user@$ip:$1 $2; }
#function cp_from_serber() { scp -r }

# SSH in Kitty only really w
#[ "$TERM" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh -R 50000:${KITTY_LISTEN_ON#*:}"
[ "$TERM" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh"


# For Xclip, we need X11 to function properly  
# Even if X11 fowarding is setup, x11 still needs a display
# So we need to set the DISPLAY to the host's (you) by passing your IP to DISPLAY before connecting
addr=$(nmcli device show | grep IP4.ADDR | awk 'NR==1{print $2}'| sed 's|\(.*\)/.*|\1|')

# -t forces allocation for a pseudo-terminal
# -X enables X11 forwarding
# -i is for a public/private keyfile
# We set DISPLAY and start a login shell instead of just connecting
# This *should* also forward GUI for GUI apps

#Server access
alias serber="ssh -t -Y -i $ssh_file $user@$ip 'export DISPLAY=$addr:0.0; bash -l'"
alias serber_unmnt="fusermount3 -u /mnt/mount1/"
alias serber_unmnt1="fusermount3 -u /mnt/mount2/"

ssh_key_and_add_to_agent_by_host() {
    if [ ! -f ~/.ssh/config ]; then
        touch ~/.ssh/config;
    fi
    local opts name kyname host keytype uname sx11
    echo "${green}FYI: Some services (f.ex. default setting openssh, github) only check for id_keyname type keys (f.ex. id_ed25519)"
    reade -Q "GREEN" -i "id_ed25519" -p "Give up filename \(Recommended: id_ed25519, id_ecdsa-sk, id_ed25519-sk, id_dsa, id_ecdsa or id_rsa\): " "id_dsa id_ecdsa id_ecdsa-sk id_ed25519 id_ed25519-sk id_rsa" name
    if [[ "$name" == "id_"* ]]; then
        reade -Q "green" -i "y" -p "Given name starts with \"id_\". Use name for keytype?:" "y n" kyname
        if [ "y" == "$kyname" ]; then
            keytype=$(echo $name | sed 's|id_||g') 
        fi
    fi
    reade -Q "GREEN" -i "id_ed25519" -p "Give up keytype \(dsa \| ecdsa \| ecdsa-sk \| ed25519 (Default) \| ed25519-sk \| rsa\): " "dsa ecdsa ecdsa-sk ed25519 ed25519-sk rsa" keytype
    read -p "Give up remote machine (hostname) : " host
    if [ -z $host ]; then
        host=$(hostname) 
    fi
    read -p "Give up remote username: " uname
    if [ -z $uname ]; then
        echo "Remote username can't be empty";
        return 0
    fi
    read -p "Forward X11? Needed for xclip [Y/n]:" sx11
    if [ -z "$sx11" ] || [ "$sx11" == "y" ]; then
        opts="ForwardX11 yes\n  ForwardX11Trusted yes\n"
    fi
    if [ -z $keytype ]; then
        keytype=ed25519
    fi
    if [ -z $name ]; then
        name="id_$keytype"   
    fi
    cat $name
    ssh-keygen -t $keytype -f ~/.ssh/$name
    ssh-add -vH ~/.ssh/known_hosts ~/.ssh/$name 
    eval $(ssh-agent -s) 
    echo "Host $host" >> ~/.ssh/config;
    echo "  IdentityFile ~/.ssh/$name" >> ~/.ssh/config
    echo "  User $uname" >> ~/.ssh/config
    printf $opts >> ~/.ssh/config
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
