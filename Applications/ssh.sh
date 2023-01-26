### SSH ###

# To prevent 'failed to preserve ownership' errors
function cp_sshfs(){ cp -r --no-preserve=mode "$1" "$2"; }
function mv_sshfs(){ cp -r --no-preserve=mode "$1" "$2" && rmTrash "$1"; }


#Server access
alias serber="ssh burpi@192.168.129.12 -p 37093"
alias serberUmnt="fusermount3 -u /mnt/mount1/"
alias serberUmnt1="fusermount3 -u /mnt/mount2/"

function serberMnt() {
    if [ ! -d /mnt/mount1 ]; then
        mkdir /mnt/mount1; 
    fi;
    if [ ! -e ~/Files/Files ]; then
        sshfs burpi@192.168.129.12:/mnt/MyStuff/ /mnt/mount1/ -p 37093 -o follow_symlinks,reconnect,default_permissions,uid=1000,gid=1001,workaround=rename;
    fi
}

function serberMnt1(){
    if ! [ -d /mnt/mount2 ]; then
        mkdir /mnt/mount2; 
    fi;
    if [ ! -e /mnt/mount2/.bashrc ]; then
        sshfs burpi@192.168.129.12:/home/burpi /mnt/mount2/ -p 37093 -o follow_symlinks,reconnect,default_permissions,uid=1000,gid=1001,workaround=rename;
    fi
}
