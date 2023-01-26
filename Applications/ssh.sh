### SSH ###

# To prevent 'failed to preserve ownership' errors
function copy_sshfs(){ cp -r --no-preserve=mode "$1" "$2"; }
function move_sshfs(){ cp -r --no-preserve=mode "$1" "$2" && rmTrash "$1"; }

function copy_to_serber() { scp -r burpi@192.168.129.12:37093$1 $2; }
#function cp_from_serber() { scp -r }

function ssh_key_and_add() { 
    if [ ! -z "$1" ]; then
        (cd ~/.ssh/ && echo "$1" | ssh-keygen -t ed25519 -C "$1" && eval $(ssh-agent -s)  && ssh-add "$1" && cat "$1.pub"); 
    else
        (cd ~/.ssh/ && ssh-keygen -t ed25519 && read -p "Give up name again" $name && eval $(ssh-agent -s) && ssh-add $name && cat $name.pub); 
    fi
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
        sshfs burpi@192.168.129.12:/mnt/MyStuff/ /mnt/mount1/ -p 37093 -o follow_symlinks,reconnect,default_permissions,uid=1000,gid=1001,workaround=rename;
    fi
}

function serber_mnt1(){
    if ! [ -d /mnt/mount2 ]; then
        mkdir /mnt/mount2; 
    fi;
    if [ ! -e /mnt/mount2/.bashrc ]; then
        sshfs burpi@192.168.129.12:/home/burpi /mnt/mount2/ -p 37093 -o follow_symlinks,reconnect,default_permissions,uid=1000,gid=1001,workaround=rename;
    fi
}
