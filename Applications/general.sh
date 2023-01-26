# TRY and keep command line at bottom
alias b="tput cup $(tput lines) 0" 

b && ls 

# Cp / rm recursively
alias cp="cp -riv"
alias copy="cp"
# Ask for Interaction when overwriting newer files
alias mv="mv -iv"
alias move="mv"
function mvAll(){
    mv ./* "$1";
}
alias rm="rm -r -v"
alias remove="rm"
# With parent directories and verbose
alias mkdir="mkdir -pv"
# Listen hidden files and permissions
alias lsall="ls -Al"
alias less="less -X"
# Cant source .inputrc in any way though
alias r=". ~/.bashrc"
alias q="exit"
alias w="cd -"
alias w="clear ;b; ls -a"
alias x="cd .."
alias men="man man"
alias bashBinds="bind -p | less"
alias sttyBinds="stty -a"
alias GPU_list_drivers="inxi -G"


function link_dynamic(){
    if ([[ "$1" = /* ]] || [ -d "$1" ] || [ -f "$1" ]) && ([[ $(readlink -f "$2") ]] || [[ $(readlink -d "$2") ]]); then
        if [[ "$1" = /* ]]; then  
            ln -s "$1" "$2";
        else     
            ln -s "$(pwd)/$1" "$2";
        fi;
    else
        echo "Give a file and a name pls";
    fi
}

function link_static(){
    if ([[ "$0" = /* ]] || [ -d "$1" ] || [ -f "$1" ]) && ([[ $(readlink -f "$2") ]] || [[ $(readlink -d "$2") ]]); then
        if [[ "$1" = /* ]]; then  
            ln "$1" "$2";
        else     
            ln "$(pwd)/$1" "$2";
        fi;
    else
        echo "Give a file and a name pls";
    fi
}


function trash(){
    for arg in $@ ; do
        if [ -f "$arg" ] || [ -d "$arg" ]; then
            gio trash $arg;
        elif [ -L "$arg" ]; then
            rm $arg;
        else
            echo "Trash one or more files / directories. Nothing passed as argument";
        fi
    done
}

alias trash_list="gio trash --list"
alias trash_empty="gio trash --empty"

function trash_restore(){
    for arg in $@; do
        gio trash --restore $arg;
    done
}

function add_to_group() {
    if [[ -z $1 ]]; then
        echo "Give a group and a username (default: $USER)"
    elif [[ -z $2 ]]; then
        sudo usermod -aG $1 $USER;
    else
        sudo usermod -aG $1 $2;
    fi; }

function mark_user_executable() {
    if [[ ! -f $1 ]] ; then
        echo "Give a file to set as an executable";
    else
        sudo chmod u+x $1;
    fi; }

# https://askubuntu.com/questions/76808/how-do-i-use-variables-in-a-sed-command
# https://stackoverflow.com/questions/18439528/sed-insert-line-with-spaces-to-a-specific-line    

# Use ""
function return_no_spaces(){
     sed 's/ /\\ /g' <<< $@; 
}

function file_insert_after_line(){
    if [ -f "$1" ]; then
        var1=$(sed 's/ /\\ /g' <<< $2);
        var2=$(sed 's/ /\\ /g' <<< $3);
       sed -i "/${var1}*/a ${var2}" "$1";
    else
        echo "Give up a filename.\n Give all arguments that use spaces a \" \"";
    fi
}

function file_put_quotations_around(){
    if [ -f "$1" ]; then
        var1=$(sed 's/ /\\ /g' <<< $2);
       sed -i "s/${var1}/\"&\"/" "$1";
    else
        echo "Give up a filename.\n Give all arguments that use spaces a \" \"";
    fi
}
