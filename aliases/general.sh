. ~/.bash_aliases.d/bash.sh
# TRY and keep command line at bottom
#alias b="tput cup $(tput lines) 0" 

#tput cup $(stty size | awk '{print int($1/2);}') 0 && tput cuu1 && tput ed && ls
# Cp / rm recursively
alias cp="cp -rv"
alias copy="cp"

alias cpAllHidden="cp -t $1 .[!.]*"

# Ask for Interaction when overwriting newer files
alias mv="mv -nv"
alias move="mv"
function mvAll(){
    mv -t "$1" .[!.]* *;
} 
function mvAllHidden(){
    mv -t "$1" .[!.]* *;
} 
alias rm="rm -rv"
alias remove="rm"
alias rmAll="rm ./*";
alias rmAllHiddn="rm .[!.]* *";

# With parent directories and verbose
alias mkdir="mkdir -pv"

#Always output colours for ls, grep and variants
alias ls="ls --color=always"
alias grep='grep --colour=always'
alias egrep='egrep --colour=always'
alias fgrep='fgrep --colour=always'
# Listen hidden files and permissions
alias lsall="ls -Al"
alias less="less -X"
# Cant source .inputrc in any way though
alias q="exit"
#alias w="clear ;b; ls -Al"
alias c="cd -"
alias x="cd .."

alias men="man man"

alias untar_gz="tar -xvf"
alias tar_gz_list="tar -tvf"

extract(){  
    if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted with extract" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

complete -F _files extract


alias redirect_tty_output_to_="exec 1>/dev/pts/"

alias GPU_list_drivers="inxi -G"


function link_soft(){
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

complete -F _files link_soft


function link_hard(){
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

complete -F _files link_hard


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

complete -F _files trash

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
        sudo usermod -aG $USER $1;
    else
        sudo usermod -aG $1 $2;
    fi; }

complete -F _groups add_to_group

function mark_user_executable() {
    if [[ ! -f $1 ]] ; then
        echo "Give a file to set as an executable";
    else
        sudo chmod u+x $1;
    fi; }

complete -F _files mark_user_executable

alias list_enabled_locales="locale -a"

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

complete -F _files file_insert_after_line

function file_put_quotations_around(){
    if [ -f "$1" ]; then
        var1=$(sed 's/ /\\ /g' <<< $2);
       sed -i "s/${var1}/\"&\"/" "$1";
    else
        echo "Give up a filename.\n Give all arguments that use spaces a \" \"";
    fi
}

complete -F _files file_put_quotations_around
