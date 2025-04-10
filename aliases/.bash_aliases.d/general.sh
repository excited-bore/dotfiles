### GENERAL ###
if ! type reade &> /dev/null && test -f ~/.bash_aliases.d/00-rlwrap_scripts.sh; then
    . ~/.bash_aliases.d/00-rlwrap_scripts.sh
fi

alias list-all-aliases="alias | awk '{\$1=\"\"; print}' | \$PAGER"
alias list-all-functions="declare -f | \$PAGER"
alias list-all-aliases-and-fucntions="(alias | awk '{\$1=\"\"; print}'; declare -f) | \$PAGER"


if [ -z $TRASHBIN_LIMIT ]; then
   TRASHBIN_LIMIT=100 
fi

if [[ $machine == 'Windows' ]] && [[ $win_bash_shell == 'Cygwin' ]]; then
    alias cd-home-="cd /cygdrive/c/Users/$USER"
fi

if type sudo &> /dev/null; then
    alias sudo='sudo '
fi

if type wget &> /dev/null; then
    alias wget='wget --https-only '
fi

if type curl &> /dev/null; then
   alias curl="curl --proto '=https' --tlsv1.2" 
fi

alias my-folder="sudo chown -R $USER:$USER ./"

#source_profile=""
#if test -z $PROFILE; then
#    if test -f ~/.profile; then
#        #PROFILE=~/.profile 
#        #source_profile="source ~/.profile" 
#        alias r="stty sane && source ~/.profile && source ~/.bashrc"
#    fi
#    if test -f ~/.bash_profile; then
#        #PROFILE=~/.bash_profile 
#        #source_profile="source ~/.bash_profile" 
#        alias r="stty sane && source ~/.bash_profile && source ~/.bashrc"
#    fi
#elif ! test -z $PROFILE; then
#    alias r="stty sane && source $PROFILE && source ~/.bashrc"
#else
    alias r="stty sane && source ~/.bashrc"
#fi

#if test -z $PAGER; then
#    PAGER=less
#fi
#alias pager=" | $PAGER"


# TRY and keep command line at bottom
#alias b="tput cup $(tput lines) 0" 

#tput cup $(stty size | awk '{print int($1/2);}') 0 && tput cuu1 && tput ed && ls


# Another wrapper (untested)
# https://superuser.com/questions/299694/is-there-a-directory-history-for-bash

alias disable-glob="set -f"

# Cd wrapper
function cd-w() {
    ! test -d $@ && builtin cd -- $@ && return 0 
    local push=1
    local j=0
    if test "$1" == "--"; then
        shift;
    fi 
    for i in $(dirs -l 2>/dev/null); do
        if test -e "$i"; then
            if [[ -z "${@}" && "$i" == "$home" ]] || test "$(realpath ${@: -1:1})" == "$i"; then
                push=0
                pushd -n +$j &>/dev/null
            fi
            j=$(($j+1));
        fi
    done
    if [ $push == 1 ]; then
        pushd "$(pwd)" &>/dev/null;  
    fi
    builtin cd -- "$@"; 
    #export DIRS="$(dirs -l)" 
    #if test "$TERM" == 'xterm-kitty' && test -f ~/.config/kitty/env.conf; then
    #    sed -i "s|env DIRS.*|env DIRS=""$DIRS""|g" ~/.config/kitty/env.conf
    #fi
}

complete -F _cd cd-w
if type _fzf_dir_completion &> /dev/null; then
    complete -F _fzf_dir_completion cd
fi

alias cd='cd-w'

# cp recursively, verbose ()
# cpOld same but no files older are overwritten
alias cp-old="cp -ruv"
alias copy="cp"

# scp - copy over ssh 
alias scp="scp -r "


function cp-all-to(){
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

complete -F _files cp-all-to

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
    
    if [[ $bcp == 1 ]]; then
        cp "$@"
    else
        cp -b "$@"
    fi
    
    if [ -d "$dest" ]; then
        target=1
    fi
    
    if [[ $target == 1 ]] ; then
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

# Cp recursively and verbose
alias cp="cp --recursive --verbose  --dereference"
alias cp-retrace-symlinks="cp --dereference --driver parblock"

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


alias mv="mv-trash -v"


# Rm 

alias rm="rm-prompt"

shred_iterates=3

alias rm-shred="shred -vzn $shred_iterates -u"

alias remove="rm"

alias rm-all-folder="rm -rv ./*";

alias rm-all-hidden="rm -rv .[!.]* *";



# Ls and Eza

#Always output colours for ls, grep and variants
type eza &> /dev/null && alias ls="eza --header --color=always --icons=always"

# List directories first
alias ls-dirtop="ls --group-directories-first"

# Listen hidden files and permissions
alias ls-all="ls -Ahl"
alias llnh="ls-all"

# Listen only files, including that are hidden 
alias ls-files="ls -Ahp | grep -v /"

# Listen only directories, including that are hidden
alias ls-dirs="ls -Ahp | grep \".*/$\""

if type eza &> /dev/null; then

    alias eza="eza --color=always --header --icons=always --smart-group" 
    alias eza-dirtop="eza --group-directories-first"
    alias eza-all="eza -A --long --git --smart-group --octal-permissions --header"
    alias eza-dirs="eza -A --only-dirs" 
    alias eza-files="eza -A --only-files"
    alias eza-git="eza --long --git-repos --header --git" 

type eza &> /dev/null && alias ls="eza --header --color=always --icons=always"
    alias ls-all="eza-all"
    alias llnh="eza -A --long --color=always --icons=always --smart-group --octal-permissions"
    alias ls-dirtop="eza-dirtop"
    alias ls-dirs="eza-dirs"
    alias ls-files="eza-files"
    alias ls-git="eza-git"

fi

alias ll="ls-all"


function ls-all-pager(){ ls-all "$@" | $PAGER; }
alias ll-pager="ls-all-pager"
alias llp="ls-all-pager"
alias lp="ls-all-pager"


# With parent directories and verbose
alias mkdir="mkdir -pv"


alias grep='grep --colour=always'
alias egrep='grep -e'
alias fgrep='fgrep --colour=always'
alias rg='rg --color=always'

alias grep-no-color='grep --color=never'
alias grep-no-case-sensitivwe='grep -i'


# Refresh output command every 0.1s
alias refresh="watch -n0 --color bash -ic"
alias refresh-diff="watch -n0 -d --color bash -ic"
complete -F _commands refresh refresh-diff

type viddy &> /dev/null && alias refresh="viddy --interval 0.1 --disable_auto_save --shell-options '--login' -- " && alias refresh-diff="viddy -D --interval 0.1 --disable_auto_save --shell-options '--login' -- " && complete -F _commands viddy

#alias cat="bat"

# Redirects to /dev/null 
alias output-null="> /dev/null"
alias error-null="2> /dev/null"
alias no-error="2> /dev/null"
alias all-null="&> /dev/null"
alias no-output="&> /dev/null"

# Show open ports
#alias openports='netstat -nape --inet'

# Wifi enable/disable
if type nmcli &> /dev/null; then
    alias wifi-enable='nmcli radio wifi on'
    alias wifi-disable='nmcli radio wifi off'
fi

alias q='exit'
#alias q='! test -z jobs && kill -2 "$(jobs -p)" && reade -Q "GREEN" -i "y" -p "Jobs are still running in the background. Send interrupt signal (kill)?: " "n" kill_ && test "$kill_" == "y" && kill "$(jobs -p)" && exit || kill -18 "$(jobs -p)" || exit'
alias d="dirs"
alias c="cd"
alias x="cd .."

# (:
alias men="man man"

# :(
# No alias starting with = 
# alias =>="|"

# Different kind of script oneliners
alias word2line="tr ' ' '\n'"
alias line2word="tr '\n' ' '"
alias tab2space="tr -s ' '"
alias only1space="tr -s ' '"
alias upper2lower="tr '[:upper:]' '[:lower:]'"
alias upper1stletter="\${var^}"
alias lower2upper="tr '[:lower:]' '[:upper:]'"
alias remove-whitespace='| xargs'
alias file-no-filetype="${i%.*}"
alias remove-empty-lines="sed '/^[[:space:]]*$/d'"
alias get-first-stringwords="frst=\"\$(echo \$words | awk '{print \$1}')\" && words=\"\$(echo \$words | sed \"s/\<\$frst\> //g\")\""

# Helps pipeing column output to a pager
alias column="column -c \$(tput cols)"


alias tar-create="tar -cvf"
alias tar-unpack="tar -xvf"
alias tar-list="tar -tvf"

# Alias's for archives
function zip(){
    if [[ $# == 1 ]] && test -e $1; then 
        zip -r $(basename $1).zip $1 
    else
        zip $@
    fi
}
alias mktar='tar -cvf'
alias mkbz2='tar -cvjf'
alias mkgz='tar -cvzf'
alias untar='tar -xvf'
alias untargz='tar -xvf'
alias unbz2='tar -xvjf'
alias ungz='tar -xvzf'
alias un7z="7z x"

extract-archive(){  
    if [ -f" $1" ] ; then
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

# whereis    
if type whereis &> /dev/null; then
     function edit-whereis(){
        if test -z $EDITOR && type nano &> /dev/null; then
            EDITOR=nano 
        fi
        if test -z $EDITOR && type vim &> /dev/null; then
            EDITOR=vim
        fi
        if test -z $EDITOR && type nvim &> /dev/null; then
            EDITOR=nvim 
        fi
        $EDITOR $(whereis $1 | awk '{print $2;}')
     } 
    
     complete -F _commands edit-whereis  
fi

alias start-cups="sudo cupsctl WebInterface=y; xdg-open 'http://localhost:631'"
alias start-printer="start-printer"

alias ip-adress="wget -qO - https://api.ipify.org; echo"

alias list-kill-signals="kill -l"
alias kill-signals="kill -l"

# eur and us format date
alias date-us='date "+%Y-%m-%d %A %T %Z"'
alias date-eu='date "+%d-%m-%Y %A %T %Z"'

alias redirect-tty-output-to="exec 1>/dev/pts/"

alias GPU-drivers="inxi -G"
alias list-GPU-drivers="inxi -G"


# Thank you Andrea 
# https://www.youtube.com/watch?v=Y_KfQIaOZkE
alias weather="inxi -w"
alias weather-full="curl wttr.in | $PAGER"

# crontab

alias cron-list='crontab -l'
alias crontab-list='crontab -l'


function cron-list-all-user-jobs(){
    mktemp_f=$(mktemp) && for user in $(cut -f1 -d: /etc/passwd); do echo "$(tput setaf 10)User: $(tput bold)$user"; printf "$(tput setaf 12)Crontab: $(tput bold)"; sudo crontab -u "$user" -l; echo; done &> "$mktemp_f"; cat $mktemp_f | $PAGER; builtin rm $mktemp_f &> /dev/null; unset mktemp_f
}
alias crontab-list-all-user-jobs="cron-list-all-user-jobs"
alias list-all-cronjobs-user="cron-list-all-user-jobs"

alias crontab-edit="env VISUAL=$CRONEDITOR crontab -e"
alias cron-edit="env VISUAL=$CRONEDITOR crontab -e"

alias crontab-add-example-edit="(crontab -l; echo '#* * * * * $USER command') | awk '!x[$0]++' | crontab -; env VISUAL=$CRONEDITOR crontab -e"
alias cron-add-example-edit-="crontab-edit-new"


function crontab-new(){
    #reade -Q 'GREEN' -i 'n' -p "Use ${MAGENTA}https://crontab.guru${GREEN} to get period? (site with explanation around crontabs) [N/y]: " 'y' guru
    #if test $guru == 'y'; then
    #    xdg-open https://crontab.guru/     
    #fi
    reade -Q 'GREEN' -i 'custom @yearly @annually @monthly @weekly @daily @hourly @reboot' -p 'When? [Custom/@yearly/@annually/@monthly/@weekly/@daily/@hourly/@reboot]: ' when
    if test "$when" == 'custom'; then
        printf "\t * means any value/not applicable\n\t , for multiple values\n\t - for a range in values\n\t / for step values (f.ex */2 every 2nd of)\n\tFor weekdays mon/tue/wed/thur/fri/sat/sun are alternatives to numeric values\n" 
        reade -Q 'GREEN' -i '* 0 5 10 15 25 30 35 40 45 50 55 0,5,10,15,25,30,35,40,45,5,55' -p 'Minutes? (0-59): ' min
        reade -Q 'GREEN' -i '* 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23' -p 'Hours? (0-23): ' hour
        reade -Q 'GREEN' -i '* 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31' -p 'Days?: (1-31): ' days
        reade -Q 'GREEN' -i '* 0 1 2 3 4 5 6 7 8 9 10 11 12' -p 'Month? (1-12): ' month
        reade -Q 'GREEN' -i '* sun 0 mon 1 tue 2 wed 3 thur 4 fri 5 sat 6 sun 1-2 1-3 1-4 1-5 1-6 1-7 2-3 2-4 2-5 2-6 2-7 3-4 3-5 3-6 3-7 4-5 4-6 4-7 5-6 5-7 6-7' -p 'Day of week? (0-6 (7 non-standard),mon/tue/wed/thur/fri/sat/sun): ' week
        format="$min $hour $days $month $week" 
    else
        format=$when 
    fi
    users=$(compgen -u) 
    reade -Q 'GREEN' -i "$USER" -p 'User: ' "$users" user
    reade -Q 'GREEN' -i "command file" -p 'Script file or command? [Command/file]: ' cmd_file
    if test $cmd_file == 'file'; then
        reade -Q 'GREEN' -p 'File to script: ' -e file
        reade -Q 'GREEN' -i 'bash python php zsh dash fish' -p 'Language: ' cmd
        cmd="$cmd $file" 
    else
        reade -Q 'GREEN' -i "''" -p 'Command: ' cmd
    fi
    if test 'root' == $user || test $user == 'system'; then
        if test $format == '@daily'; then
            if ! test -f /etc/cron.daily/schedule; then
                sudo touch /etc/cron.daily/schedule
            fi
            sudo echo "$format root $cmd" >> /etc/cron.daily/schedule
            sudo chmod 600 /etc/cron.daily/schedule 
        elif test $format == '@hourly'; then 
            if ! test -f /etc/cron.hourly/schedule; then
                sudo touch /etc/cron.hourly/schedule
            fi
            sudo echo "$format root $cmd" >> /etc/cron.hourly/schedule
            sudo chmod 600 /etc/cron.hourly/schedule 
        elif test $format == '@monthly'; then 
            if ! test -f /etc/cron.monthly/schedule; then
                sudo touch /etc/cron.monthly/schedule
            fi
            sudo echo "$format root $cmd" >> /etc/cron.monthly/schedule
            sudo chmod 600 /etc/cron.monthly/schedule 
        elif test $format == '@weekly'; then 
            if ! test -f /etc/cron.weekly/schedule; then
                sudo touch /etc/cron.weekly/schedule
            fi
            sudo echo "$format root $cmd" >> /etc/cron.weekly/schedule
            sudo chmod 600 /etc/cron.weekly/schedule 
        else
            if ! test -f /etc/cron.d/schedule; then
                sudo touch /etc/cron.d/schedule
            fi
            sudo echo "$format root $cmd" >> /etc/cron.d/schedule
            sudo chmod 600 /etc/cron.d/schedule 
        fi
    else
        (crontab -l; echo "$format $USER $cmd") | awk '!x[$0]++' | crontab -; env VISUAL=$CRONEDITOR crontab -e 

    fi
    unset cmd cmd_file file user days month week minutes hour guru users
}

alias cron-new='crontab-new'

function ln-soft(){
    if ([ -d "$1" ] || [ -f "$1" ]) && ([[ $(readlink -f "$2") ]] || [[ $(readlink -d "$2") ]]); then
        if [ -e "$(pwd)/$1" ]; then  
            ln -s "$(pwd)/$1" "$2";
        else     
            ln -s "$1" "$2";
        fi;
    else
        echo "Give a file and a name pls";
    fi
}

#complete -F _filedir ln-soft


function ln-hard(){
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

#complete -F _filedir ln-hard

function trash(){
    for arg in $@ ; do
        if [ -f "$arg" ] || [ -d "$arg" ]; then
            gio trash $arg;
            if [ $(gio trash --list | wc -l) -gt "$TRASHBIN_LIMIT" ]; then
                local ansr
                echo "${red1}Trashbin has more then $TRASHBIN_LIMIT items"
                reade -Q "YELLOW" -i "y" -p "Empty? ('trash-restore' to restore) [Y/n]: " "n"  ansr
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

#complete -F _filedir trash

alias trash-list="gio trash --list"
alias trash-empty="gio trash --empty"

function trash-restore(){
    for arg in "$@"; do
        gio trash --restore "$arg";
    done
}

declare -f _trash-restore

complete -F _trash trash-list
complete -F _trash trash-restore

function add-to-group() {
    if [ -z $1 ]; then
        echo "Give a user and the group (user can be empty - default: $USER)"
    elif [ -z $2 ]; then
        sudo usermod -aG $USER $1;
    else
        sudo usermod -aG $1 $2;
    fi 
}

complete -F _groups add_to_group

# https://stackoverflow.com/questions/22381983/how-to-check-file-owner-in-linux
# I still do == cause used to ¯\_(ツ)_/¯
#

function set-executable-user() {
    if ! test -z "$@"; then
        for i in "$@"; do 
            if test "$(stat -c '%U' "$i")" == 'root' || ! test "$(stat -c '%U' "$i")" == "$USER"; then
                sudo chmod u+x $i;
            else 
                chmod u+x $i;    
            fi 
            llnh $i 
        done
        unset i 
    fi
}

function set-executable-group() {
    if ! test -z "$@"; then
        for i in "$@"; do 
            if test "$(stat -c '%U' "$i")" == 'root' || ! test "$(stat -c '%U' "$i")" == "$USER"; then
                sudo chmod g+x $i;
            else 
                chmod g+x $i;    
            fi 
            llnh $i 
        done
        unset i 
    fi
}

function set-executable-other() {
    if ! test -z "$@"; then
        for i in "$@"; do 
            if test "$(stat -c '%U' "$i")" == 'root' || ! test "$(stat -c '%U' "$i")" == "$USER"; then
                sudo chmod o+x $i;
            else 
                chmod o+x $i;    
            fi 
            llnh $i 
        done
        unset i 
    fi
}


function set-executable-all() {
    if ! test -z "$@"; then
        for i in "$@"; do 
            if test "$(stat -c '%U' "$i")" == 'root' || ! test "$(stat -c '%U' "$i")" == "$USER"; then
                sudo chmod +x $i;
            else 
                chmod +x $i;    
            fi 
            llnh $i 
        done
        unset i 
    fi
}


function unset-executable-user() {
    if ! test -z "$@"; then
        for i in "$@"; do 
            if test "$(stat -c '%U' "$i")" == 'root' || ! test "$(stat -c '%U' "$i")" == "$USER"; then
                sudo chmod u-x $i;
            else
                chmod u-x $i    
            fi 
            llnh $i 
        done
        unset i 
    fi
}

function unset-executable-group() {
    if ! test -z "$@"; then
        for i in "$@"; do 
            if test "$(stat -c '%U' "$i")" == 'root' || ! test "$(stat -c '%U' "$i")" == "$USER"; then
                sudo chmod g-x $i;
            else
                chmod g-x $i    
            fi 
            llnh $i 
        done
        unset i 
    fi
}

function unset-executable-other() {
    if ! test -z "$@"; then
        for i in "$@"; do 
            if test "$(stat -c '%U' "$i")" == 'root' || ! test "$(stat -c '%U' "$i")" == "$USER"; then
                sudo chmod o-x $i;
            else
                chmod o-x $i    
            fi 
            llnh $i 
        done
        unset i 
    fi
}



function unset-executable-all() {
    if ! test -z "$@"; then
        for i in "$@"; do 
            if test "$(stat -c '%U' "$i")" == 'root' || ! test "$(stat -c '%U' "$i")" == "$USER"; then
                sudo chmod -x $i;
            else
                chmod -x $i    
            fi 
            llnh $i 
        done
        unset i 
    fi
}

# FIND 

type fd &> /dev/null && alias fd='fd --color=always --hidden'

tree=''
type tree &> /dev/null && tree=' | tree '

if type fd &> /dev/null; then
    alias find-files-dir="fd --search-path . --type file" 
    alias find-files-system="fd --search-path / --type file" 
    alias find-symlinks-dir="fd --search-path . --type symlink $tree | $PAGER"
    alias find-symlinks-system="fd --search-path / --type symlink $tree | $PAGER"
else
    alias find-files-dir="find . -type f" 
    alias find-files-system="find / -type f" 
    alias find-symlinks-dir="find . -type l -exec ls --color -d {} \; $tree | $PAGER"
    alias find-symlinks-system="find / -type l -exec ls --color -d {} \; $tree | $PAGER"
fi

alias locales-list-enabled="locale -a"

# https://askubuntu.com/questions/76808/how-do-i-use-variables-in-a-sed-command
# https://stackoverflow.com/questions/18439528/sed-insert-line-with-spaces-to-a-specific-line    

# Escape pathnames to files and dirs properly before putting them on the prompt
function print-path-to-prompt(){
    lines="n"
    while getopts ':l' flag; do
        case "${flag}" in
            l)  lines="y"
                shift 
                ;;
        esac
    done && OPTIND=1;
    fls=$(echo "$@" | sed 's| |\\ |g' | sed 's|\[|\\\[|g' | sed 's|\]|\\\]|g' | sed 's|(|\\(|g' | sed 's|)|\\)|g' | sed 's|{|\\{|g' | sed 's|}|\\}|g')
    if test $lines == 'n'; then
        fls="$(echo $fls | tr "\n" ' ')"
    fi
    READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$fls${READLINE_LINE:$READLINE_POINT}"
    READLINE_POINT=$(( READLINE_POINT + ${#fls} ))
    unset lines fls 
}

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

function file-put-quotations-around(){
    if [ -f "$1" ]; then
        var1=$(sed 's/ /\\ /g' <<< $2);
       sed -i "s/${var1}/\"&\"/" "$1";
    else
        echo "Give up a filename.\n Give all arguments that use spaces a \" \"";
    fi
}

complete -F _files file_put_quotations_around

alias shutdown-now='shutdown now'

function iommu-groups(){
    shopt -s nullglob
    for g in $(find /sys/kernel/iommu_groups/* -maxdepth 0 -type d | sort -V); do
        echo "IOMMU Group ${g##*/}:"
        for d in $g/devices/*; do
            echo -e "\t$(lspci -nns ${d##*/})"
        done;
    done;
}

# disk free and free
alias free='free -h'
alias free-kilo='command free --kilo'
alias free-mega='command free --mega'
alias free-giga='command free --giga'
alias df='df -h -T --total'
alias du="du -hs | awk '{print \$1}'"
alias folder-size="du"
alias dir-size="du"
alias dirsize="du"


alias regenerate-initrams-all-kernels="sudo mkinitcpio -P"
hdrs="$(echo $(uname -r) | cut -d. -f-2)"
curr="linux${hdrs//'.'}"
alias regenerate-initrams-current-kernel="sudo mkinitcpi -p $curr"
unset hdrs curr

alias list-drivers-modules-in-use="lspci -nnk"
alias motherboard-info="sudo dmidecode -t 1 && sudo dmidecode -t 2"
alias mobo-info="motherboard"
alias bios-info="sudo dmidecode -t 0"
alias motherboard-info-full="sudo dmidecode -t 1 && sudo dmidecode -t 2 && sudo dmidecode -t 0 | $PAGER"

# Dual boot stuff

function boot-into(){
    local opts="$(efibootmgr | grep --color=never Boot00 | awk '{print $1;}' | sed 's/Boot//g' | cut -d* -f-1)" 
    local frst="$(echo $opts | awk '{print $1}')" 
    local opts="$(echo $opts | sed "s/\<$frst\> //g")"  
    efibootmgr
    reade -Q 'GREEN' -i "$frst $opts" -p "What to boot into? (Empty: $frst): " bootnt
    if [[ $bootnt =~ 000[[:digit:]] ]]; then
        sudo efibootmgr --bootnext "$bootnt" 
        efibootmgr 
        printf "\n${CYAN}Will reboot in 5 seconds if not interrupted\n${normal}" 
        sleep 5 && reboot 
    fi
    unset bootnt 
}

alias next-boot="boot-into"

function change-username-and-homefolder(){
    ! shopt -q login_shell && printf "${RED}Not login shell\nLogout, press 'Ctrl+Alt+F1/F2/...F6' to drop to a login shell and login as root or a user other then the one you want to change.\n${YELLOW}(Make sure the root account is enabled with 'sudo passwd su' - you can disable it afterwards with 'sudo passwd -l su')${normal}\n" && return 1
    local frst="$(echo $(users | word2line | uniq | grep -v root ) | awk '{print $1}')" 
    local words="$(echo $words | sed "s/\<$frst\> //g")" 
    reade -Q 'CYAN' -i "$frst $words" -p "Old username (Empty = $frst): " usrname 
    test -z "$usrname" && usrname="$frst" 
    test "$USER" == "$usrname" && printf "${RED}Can't change username for $usrname while logged as said\nLogout, press 'Ctrl+Alt+F1/F2/...F6' to drop to a login shell (if not already in one) and login as root or a user other then the one you want to change.\n${YELLOW}(Make sure the root account is enabled with 'sudo passwd su' - you can disable it afterwards with 'sudo passwd -l su')${normal}\n" && return 1 
    reade -Q 'MAGENTA' -p 'New username: ' usrname_nw 
    if ! test -z "$usrname_nw"; then
        if ! test -z "$(ps -U $usrname 2> /dev/null)"; then
            printf "There are still processes running under user $usrname!\nKilling all processes for user..."  
            sleep 5
            sudo pkill -U $(id -u "$usrname") 
            printf "Done!\n" 
        fi
        sudo usermod -l "$usrname_nw" -d /home/"$usrname_nw" -m "$usrname" &&  
        sudo groupmod -n "$usrname_nw" "$usrname" &&  
        sudo test -f /etc/lightdm/lightdm.conf && sudo grep -q "autologin-user=$usrname" /etc/lightdm/lightdm.conf && sudo sed -i "s/^autologin-user=$usrname/autologin-user=$usrname_nw/g" /etc/lightdm/lightdm.conf &&
        test -f /home/$usrname_nw/.config/starship.toml && grep -q "/home/$usrname" /home/$usrname_nw/.config/starship.toml && sed -i "s|/home/$usrname|/home/$usrname_nw|g" /home/$usrname_nw/.config/starship.toml   
        printf "${GREEN}Changed username and homedirectory to $usrname_nw!${normal}\n" && 
        unset usrname usrname_nw && 
        return 0 || return 1; 
    else
        printf "${YELLOW}Please give up a new username to change to.${normal}\n"
        return 1 
    fi
}

function change-device-name-to(){
    local oldname=$(hostname) 
    reade -Q 'CYAN' -p "New device name (hostname): " name
    test -z "$name" && printf "Name cant be empty.\n" && return 1
    sudo hostnamectl set-hostname "$name" 
    sudo sed -i "s/$oldname/$name/g" /etc/hosts &&
    sudo sed -i "s/$oldname/$name/g" /etc/hostname && 
    unset name &&
    printf "${GREEN}Changed device name (hostname) to $name!${normal}\n" &&
    return 0 || return 1;
}


