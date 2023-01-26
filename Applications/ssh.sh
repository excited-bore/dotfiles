### SSH ###

# To prevent 'failed to preserve ownership' errors
function copy_sshfs(){ cp -r --no-preserve=mode "$1" "$2"; }
function move_sshfs(){ cp -r --no-preserve=mode "$1" "$2" && rmTrash "$1"; }

function copy_to_serber() { scp -r burpi@192.168.129.12:37093$1 $2; }
#function cp_from_serber() { scp -r }

function git_ssh_key_and_add_to_agent() { 
    if [ ! -f ~/.ssh/config ]; then
        touch ~/.ssh/config;
        echo "Host github.com" > ~/.ssh/config;
    elif ! grep -q github.com ~/.ssh/config; then 
        echo "Host github.com" > ~/.ssh/config;
    fi
    (cd ~/.ssh/ && read -p "Give up name: " name && echo ~/.ssh/$name | ssh-keygen -t ed25519 && echo "  IdentityFile ~/.ssh/$name" >> ~/.ssh/config &&
    echo "  User git" >> ~/.ssh/config &&
    ssh-add -vH ~/.ssh/known_hosts ~/.ssh/"$name" &&
    eval $(ssh-agent -s) && cat $name.pub); 
}

#Server access
alias serber="ssh -i ~/.ssh/id_burpi pi@192.168.129.17"
alias serber_unmnt="fusermount3 -u /mnt/mount1/"
alias serber_unmnt1="fusermount3 -u /mnt/mount2/"

function serber_mnt() {
    if [ ! -d /mnt/mount1 ]; then
        mkdir /mnt/mount1; 
    fi;
    if [ ! -e ~/Files/Files ]; then
        sshfs burpi@192.168.129.12:/mnt/MyStuff/ /mnt/mount1/ -o IdentityFile=/home/burp/.ssh/id_burpi,follow_symlinks,reconnect,default_permissions,uid=1000,gid=1001,workaround=rename;
    fi
}

function serber_mnt1(){
    if ! [ -d /mnt/mount2 ]; then
        mkdir /mnt/mount2; 
    fi;
    if [ ! -e /mnt/mount2/.bashrc ]; then
        sshfs burpi@192.168.129.12:/home/burpi /mnt/mount2/ -o IdentityFile=/home/burp/.ssh/id_burpi,follow_symlinks,reconnect,default_permissions,uid=1000,gid=1001,workaround=rename;
    fi
}
