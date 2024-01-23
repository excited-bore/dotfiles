if [ ! -f ~/.bash_aliases.d/rlwrap_scripts.sh ]; then
    . ../readline/rlwrap_scripts.sh
else
    . ~/.bash_aliases.d/rlwrap_scripts.sh
fi
# TRY and keep command line at bottom
#alias b="tput cup $(tput lines) 0" 

#tput cup $(stty size | awk '{print int($1/2);}') 0 && tput cuu1 && tput ed && ls

# cp recursively, verbose ()
# cpOld same but no files older are overwritten

alias cp="cp -rv"
alias cpOld="cp -ruv"
alias copy="cp"

function copy-dir-to(){
    local dest
    reade -Q "GREEN" -i "~/" -p "This will copy the entire directory to: " -e dest
    if [ ! -z "$dest" ]; then
        cp -v -t "$dest" .[!.]*;
    fi
}

function copy-rec-dir-to(){
    local dest
    reade -Q "GREEN" -i "~/" -p "This will copy the entire directory to: " -e dest
    if [ ! -z "$dest" ]; then
        cp -rv -t "$dest" .[!.]*;
    fi
}

complete -F _filedir cpAllTo

function copy-force-trash(){
    cp -f --backup=1;
}
complete -F _files cpf1Bkup


function copy-force-1backup(){
    cp -f --backup=1;
}
complete -F _files cpf1Bkup

# mv (recursively native) verbose and only ask for interaction when overwriting newer files

alias mv="mv -v"
alias mvOld="mv -nv"
alias move="mv"
function mvDirTo(){
    mv -t "$@" .[!.]* *;
} 

# rm recursively and verbose

alias rm="rm -rv"
alias remove="rm"
alias rmAll="rm -v ./*";
alias rmAllHiddn="rm -v .[!.]* *";

# With parent directories and verbose
alias mkdir="mkdir -pv"

#Always output colours for ls, grep and variants
alias ls="ls --color=always"
alias grep='grep --colour=always'
alias egrep='egrep --colour=always'
alias fgrep='fgrep --colour=always'
alias rg='rg --color=always'


# Listen hidden files and permissions
alias lsall="ls -Al"
alias q="exit"
alias c="cd"
alias x="cd .."

# (:
alias men="man man"

alias targz-create="tar -cvf"
alias targz-unpack="tar -xvf"
alias targz-list="tar -tvf"

extract-archive(){  
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


alias redirect-tty-output-to="exec 1>/dev/pts/"

alias GPU-list-drivers="inxi -G"


function link-soft(){
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


function link-hard(){
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

alias trash-list="gio trash --list"
alias trash-empty="gio trash --empty"

function trash-restore(){
    for arg in $@; do
        gio trash --restore $arg;
    done
}

function add-to-group() {
    if [[ -z $1 ]]; then
        echo "Give a group and a username (default: $USER)"
    elif [[ -z $2 ]]; then
        sudo usermod -aG $USER $1;
    else
        sudo usermod -aG $1 $2;
    fi; }

complete -F _groups add_to_group

function set-user-executable() {
    if [[ ! -f $1 ]] ; then
        echo "Give a file to set as an executable";
    else
        sudo chmod u+x $1;
    fi; }

complete -F _files mark_user_executable

alias ls_enabled_locales="locale -a"

# https://askubuntu.com/questions/76808/how-do-i-use-variables-in-a-sed-command
# https://stackoverflow.com/questions/18439528/sed-insert-line-with-spaces-to-a-specific-line    

# Set an escape character \ before each space
function escape_spaces(){
     sed 's/ /\\ /g' <<< $@; 
}

function lines-to-words(){
    # 1 Output with lines
    # 2 Return string with words
    IFS=$'\n' read -d "\034" -r -a $2 <<<"$1\034";
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
