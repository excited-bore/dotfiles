if [ ! -f ~/.bash_aliases.d/rlwrap_scripts.sh ]; then
    . ../aliases/rlwrap_scripts.sh
else
    . ~/.bash_aliases.d/rlwrap_scripts.sh
fi

shopt -s expand_aliases  

if [ -z $TRASHBIN_LIMIT ]; then
   TRASHBIN_LIMIT=100 
fi

# TRY and keep command line at bottom
#alias b="tput cup $(tput lines) 0" 

#tput cup $(stty size | awk '{print int($1/2);}') 0 && tput cuu1 && tput ed && ls

# cp recursively, verbose ()
# cpOld same but no files older are overwritten
alias cp="cp -rv"
alias cp-old="cp -ruv"
alias copy="cp"

function cpAllto(){
    local dest
    if [ -z "$1" ] && [ -d "$1" ]; then
        dest="$1"
    else
        reade -Q "GREEN" -i "~/" -p "This will do a recursive copy in the current directory to: " -e dest
    fi
    if [ ! -z "$dest" ]; then
        cp -rv -t "$dest" .[!.]*;
    fi
}

complete -F _filedir cpAllTo

alias cpf-bckup="cp -f -b"

#function cp-reverse(){
#    getopt -T
#    if [ "$?" != 4 ]; then
#        echo 2>&1 "Wrong version of 'getopt' detected, exiting..."
#        exit 1
#    fi
#    local dest="${@: -1:1}"
#    local sorce=()
#    local target=0
#    local args=$@
#    #VALID_ARGS=$(getopt -o abdfiHlPpRrsStTuvxZ --long \
#    #archive, \
#    #attributes-only, \
#    #backup:, \
#    #copy-contents, \
#    #debug, \
#    #force, \
#    #interactive, \
#    #link, \
#    #no-dereference, \
#    #preserve:, \
#    #no-preserve:, \
#    #parents¸ \
#    #recursive, \
#    #reflink:, \
#    #remove-destination, \
#    #sparse:, \
#    #strip-trailing-slashes, \
#    #symbolic-link, \
#    #suffix:, \
#    #target-directory:, \
#    #no-target-directory, \
#    #update:, \
#    #verbose, \
#    #one-file-system, \
#    #context:, \
#    #help, \
#    #version -- "$@")
#    #
#    #eval set -- "$VALID_ARGS"
#    
#    while : ; do
#        case "$1" in
#            --backup | --preserve | --no-preserve | --sparse | -S | --suffix | -u | --update | --context)         
#                if [ "$2" ] && ([ "$2" == "none" ] || [ "$2" == "off" ] || [ $2 == "numbered" ] || [ $2 == "t" ] || [ $2 == "existing" ] || [ $2 == "simple" ] || [ $2 == "never" ]); then 
#                    shift 2
#                else
#                    shift
#                fi
#               ;;
#             --target-directory | -!(-*)t)  
#                target=1
#                if test -d "$2"; then
#                    dest="$2" 
#                    shift 2 
#                fi
#                ;;
#            -* | --*)  
#                shift 
#                ;;
#            --) 
#                shift
#                break
#                ;;
#            *) 
#                break
#                ;;
#        esac
#    done
#
#    for arg in $@; do
#        echo $arg
#        for arg1 in ${args} ; do
#            if [[ "$arg" == "$arg1" ]] ; then
#                args=("${args[@]/$arg}")
#            fi
#        done
#        if [[ "$arg" != "$dest" ]]; then
#            sorce+=("$arg")
#        fi
#    done 
#    
#    if test -d "$dest"; then
#        target=1
#    fi
#    if test "$target" == 1 ; then
#        for s in "${sorce[@]}"; do
#            if test -a "$dest/$(basename $s)"; then 
#                echo ${args[@]}
#                cp "${args[@]}" "$(dirname $dest)/$(basename $s)" "$s" 
#            else
#                echo "Files that were previously the destination have not been found"
#            fi 
#        done
#    else
#        if [[ "${#sorce[@]}" == 1 ]]; then
#            cp  ${args[@]} "$dest" "${sorce[0]}" 
#        fi  
#    fi
#}


function cp-trash(){
    local dest="${@: -1:1}"
    local sorce=()
    local target=0
    local suff="~"
    local i=0
    local bcp=0
    local frc=0
    for arg in $@ ; do
        i=$((i+1))
        case "$arg" in
            -b | --backup)  bcp=1 ;;
            -S | --suffix)
                suff=dest="${@: $i+1:1}";;
            -t | --target-directory)  
                target=1
                dest="${@: $i+1:1}" ;;
        esac
    done
    
    if [ $bcp == 1 ]; then
        cp "$@"
    else
        cp -b "$@"
    fi
    
    if [ -d "$dest" ]; then
        target=1
    fi
    
    if [ $target == 1 ] ; then
        for s in "${sorce[@]}"; do
            if [ -a "$dest/$s$suff" ]; then 
                trash "$dest/$(basename $s$suff)" 
                echo "Backup for $dest/$(basename $s$suff)  put in trash."
            fi 
        done
    else
        if test -a "$dest$suff"; then
            trash "$dest$suff"
            echo "Backup(s) put in trash. Use 'gio trash --list' to list / 'gio trash --restore' to restore"
        fi  
    fi
}

##alias cp="cp-trash -rv"

# mv (recursively native) verbose and only ask for interaction when overwriting newer files

alias mv="mv -v"
alias mvOld="mv -nv"
alias move="mv"
function mv-dir-to(){
    local dest
    reade -Q "GREEN" -i "~/" -p "This will copy the entire directory to: " -e dest
    if [ ! -z "$dest" ]; then
        mv -t "$dest" .[!.]* *;
    fi
} 


function mv-trash(){
    local dest="${@: -1:1}"
    local sorce=()
    local target=0
    local suff="~"
    local i=0
    local bcp=0
    local frc=0
    for arg in $@ ; do
        i=$((i+1))
        case "$arg" in
            -b | --backup)  bcp=1 ;;
            -f | --force) frc=1   ;;
            -t | --target-directory)  
                target=1
                dest="${@: $i+1:1}" ;;
        esac
    done
    
    if [ $bcp == 1 ]; then
        mv "$@"
    else
        if [ $frc == 1 ]; then
            mv -b "$@"
        else
            mv -f -b "$@"
        fi
    fi
    
    if test -d "$dest"; then
        target=1
    fi
    
    if [ $target == 1 ] ; then
        for s in "${sorce[@]}"; do
            if test -a "$dest/$s$suff"; then 
                trash "$dest/$(basename $s$suff)" 
            echo "Backup $dest/$(basename $s$suff) put in trash."
            fi 
        done
    elif test -f "$dest$suff"; then
        trash "$dest$suff"  
        echo "Backup(s) put in trash. Use 'gio trash --list' to list / 'gio trash --restore' to restore"
    fi
} 


##alias mv="mv-trash -v"

# rm recursively and verbose

alias rm="rm -rv"
shred_iterates=3
alias rm-shred="shred -vzn $shred_iterates -u"
#alias remove="rm"
alias rm-all-folder="rm -rv ./*";
alias rm-all-hidden="rm -rv .[!.]* *";

#alias rm="gio trash"

# With parent directories and verbose
alias mkdir="mkdir -pv"

#Always output colours for ls, grep and variants
alias ls="ls --color=always"
alias grep='grep --colour=always'
alias egrep='egrep --colour=always'
alias fgrep='fgrep --colour=always'
alias rg='rg --color=always'

#alias cat="bat"

# Listen hidden files and permissions
alias ll="ls -ahl"
alias ls-all="ls -Ahl"
alias q="exit"
alias d="dirs"
alias c="cd"
alias x="cd .."

# (:
alias men="man man"

# Pipe column output to a pager
alias column="column -c $(tput cols)"

alias targz-create="tar -cvf"
alias targz-unpack="tar -xvf"
alias targz-list="tar -tvf"

extract-archive(){  
    if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
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

function cron-list-all-user-jobs(){
mktemp_f=$(mktemp) && for user in $(cut -f1 -d: /etc/passwd); do echo "$(tput setaf 10)User: $(tput bold)$user"; printf "$(tput setaf 12)Crontab: $(tput bold)"; sudo crontab -u "$user" -l; echo; done &> "$mktemp_f"; cat $mktemp_f | $PAGER; rm $mktemp_f &> /dev/null; unset mktemp_f
}
alias crontab-list-all-user-jobs="cron-list-all-user-jobs"

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
            if [ $(gio trash --list | wc -l) -gt "$TRASHBIN_LIMIT" ]; then
                local ansr
                echo "${red1}Trashbin has more then $TRASHBIN_LIMIT items"
                reade -Q "YELLOW" -i "y" -p "Empty? ('trash-restore' to restore) [Y/n]: " "y n"  ansr
                if [ $ansr == "y" ]; then
                    trash-empty
                fi
            fi
        elif [ -L "$arg" ]; then
            rm $arg;
        else
            echo "Trash one or more files / directories. Nothing passed as argument";
        fi
    done
}

complete -F _filedir trash

alias trash-list="gio trash --list"
alias trash-empty="gio trash --empty"

_trash(){
    #WORD_ORIG=$COMP_WORDBREAKS
    #COMP_WORDBREAKS=${COMP_WORDBREAKS/:/}
    _get_comp_words_by_ref -n : cur
    COMPREPLY=($(compgen -W "$(gio trash --list | awk '{print $1;}' | sed 's|trash:///|trash\\\:///|g' )" -- "$cur") )
    __ltrim_colon_completions "$cur"
    #COMP_WORDBREAKS=$WORD_ORIG
    return 0
}

function trash-restore(){
    for arg in "$@"; do
        gio trash --restore "$arg";
    done
}

declare -f _trash-restore

complete -F _trash trash-list
complete -F _trash trash-restore

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

function iommu-groups(){
    shopt -s nullglob
    for g in $(find /sys/kernel/iommu_groups/* -maxdepth 0 -type d | sort -V); do
        echo "IOMMU Group ${g##*/}:"
        for d in $g/devices/*; do
            echo -e "\t$(lspci -nns ${d##*/})"
        done;
    done;
}

alias regenerate-initrams-all-kernels="sudo mkinitcpio -P"
alias list-drivers-modules-in-use="lspci -nnk"
