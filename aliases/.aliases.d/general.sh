## GENERAL ###

# Background task peculiarity for gnome-terminal/xfce4-terminal
# https://unix.stackexchange.com/questions/176839/closing-parent-processterminal-doesnt-close-a-specific-child-process

# &, disown and nohup difference
# https://unix.stackexchange.com/questions/3886/difference-between-nohup-disown-and

# Ultimate process seperator
# https://stackoverflow.com/questions/19955260/what-is-dev-null-in-bash/19956266#19956266

# Deep dive into SIGTTIN/SIGTTOU
# http://curiousthing.org/sigttin-sigttou-deep-dive-linux

if ! type reade &> /dev/null && [[ -f ~/.aliases.d/00-rlwrap_scripts.sh ]]; then
    . ~/.aliases.d/00-rlwrap_scripts.sh
fi

[ -z "$PAGER" ] && hash less &>/dev/null && 
    PAGER="$(whereis less | awk '{print $2}')"

[ -z "$MANPAGER" ] &&
    MANPAGER=$PAGER

if [ -n "$BASH_VERSION" ]; then
    
    man-bash(){
        help -m $@ | $MANPAGER;
    }
     
    alias list-commands-bash="compgen -c | $PAGER"
    alias list-keywords-bash="compgen -k | $PAGER"
    alias list-builtins-bash="compgen -b | $PAGER"
    alias list-aliases-bash="compgen -a | $PAGER"
    alias list-users-bash="compgen -u | $PAGER"
    alias list-functions-bash="compgen -A function | $PAGER"
    alias list-function-content-bash="declare -f"
    alias list-directory-bash="compgen -d | $PAGER"
    alias list-groups-bash="compgen -g | $PAGER"
    alias list-services-bash="compgen -s | $PAGER"
    alias list-exports-bash="compgen -e | $PAGER"
    alias list-shellvars-bash="compgen -v | $PAGER"
    alias list-file-and-dirs-bash="compgen -f | $PAGER"

elif [[ -n "$ZSH_VERSION" ]]; then
    
    man-zsh(){
        run-help $@
    }
fi

alias list-all-aliases="alias | sed 's|^alias ||g' | \$PAGER"
alias list-all-functions="declare -f | \$PAGER"
alias list-all-aliases-and-functions="(alias | sed 's|^alias ||g'; declare -f) | \$PAGER"

if [ -z $TRASHBIN_LIMIT ]; then
   TRASHBIN_LIMIT=100 
fi

if [[ $machine == 'Windows' ]] && [[ $win_bash_shell == 'Cygwin' ]]; then
    alias cd-home="cd /cygdrive/c/Users/$USER"
fi

if hash sudo &> /dev/null; then
    alias sudo='sudo '
fi

if hash wget &> /dev/null; then
    alias wget='wget --https-only '
fi

#alias wget='aria2c'

if hash curl &> /dev/null; then
   alias curl="curl --proto '=https' --tlsv1.2" 
fi

if [[ -n "$BASH_VERSION" ]]; then
    alias reload-bashrc="stty sane && source ~/.bashrc"
    alias r="stty sane && source ~/.bashrc"
elif [[ -n "$ZSH_VERSION" ]]; then
    alias reload-zshrc="source ~/.zshrc"
    alias r="source ~/.zshrc"
fi

alias my-folder="sudo chown -R $USER:$USER ./"

#source_profile=""
#if [ -z $PROFILE ]; then
#    if [ -f ~/.profile ]; then
#        #PROFILE=~/.profile 
#        #source_profile="source ~/.profile" 
#        alias r="stty sane && source ~/.profile && source ~/.bashrc"
#    fi
#    if [ -f ~/.bash_profile ]; then
#        #PROFILE=~/.bash_profile 
#        #source_profile="source ~/.bash_profile" 
#        alias r="stty sane && source ~/.bash_profile && source ~/.bashrc"
#    fi
#elif ! [ -z $PROFILE ]; then
#    alias r="stty sane && source $PROFILE && source ~/.bashrc"
#else
#fi

# TRY and keep command line at bottom
#alias b="tput cup $(tput lines) 0" 

#tput cup $(stty size | awk '{print int($1/2);}') 0 && tput cuu1 && tput ed && ls


# Another wrapper (untested)
# https://superuser.com/questions/299694/is-there-a-directory-history-for-bash

alias disable-glob="set -f"

# cp recursively, verbose ()
# cp-skip-existing same but no files older are overwritten
alias cp-skip-existing="cp -ruv"
alias copy="cp"

# scp - copy over ssh 
alias scp="scp -r"

function cp-all-to(){
    local dest
    if [ -z "$1" ] && [ -d "$1" ]; then
        dest="$1"
    else
        reade -Q "GREEN" -i "~/" -p "This will do a recursive copy in the current directory to: " -e dest
    fi
    if ! [ -z "$dest" ]; then
        cp -rv -t "$dest" .[!.]*;
    fi
}

alias cpf-bckup="cp -f -b"

function cp-trash(){
    
    # Make zsh have 0-indexed arrays
    [[ -n "$ZSH_VERSION" ]] &&
        setopt KSH_ARRAYS       
    
    local target suff bcp args="$@" othrargs="" i=0 descn descn1 trashed
   
    if [ -z "$CPTRASH_CMD" ]; then
        CPTRASH_CMD='command cp'
    fi 
    
    if [ -z "$CPTRASH_PAGER" ]; then
        CPTRASH_PAGER='less -R --use-color --LINE-NUMBERS --quit-if-one-screen -Q --no-vbell'
    fi 
    
    if [ -z "$CPTRASH_DIFF" ]; then
        if [ -n "$DIFFPROG" ]; then
            CPTRASH_DIFF="$DIFFPROG" 
        else 
            CPTRASH_DIFF='diff --color=always' 
        fi 
    fi

    for arg in "$@"; do
        i=$(($i+1)) 
        case "$arg" in
            -a | --archive | --attributes-only | --copy-contents | -d | --debug | -f | --force | -i | --interactive | -H | -l | --link | -L | --dereference | -n | --no-clobber | -P | --no-dererence | -p | --preserve | --preserve=* | --no-preserve=* | --parents | -R | -r | --recursive | --reflink | --reflink=* | --remove-destination | --sparse=* | --strip-trailing-slashes | -s | --symbolic-link | -T | --no-target-directory | --update | --update=* | -u | -v | --verbose | --keep-directory-symlink | -x | --one-file-system | -Z | --context | --context=* | --help | --version) 
               othrargs="$othrargs $arg"; shift ;; 
            -g | --progress-bar) 
                if eval "$CPTRASH_CMD --help 2>&1 | grep -q -- $arg"; then
                    othrargs="$othrargs $arg"; shift ;
                else 
                    eval "$CPTRASH_CMD $arg"
                    return 1
                fi ;; 
           -b | --backup | --backup=*) 
                if [[ "$arg" =~ "--backup=" ]]; then
                    bcp="${arg#--backup=}" ;
                else
                    bcp="simple" ;
                fi; 
                othrargs="$othrargs $arg"; shift ;;
            -t) target="${@:$(($i+1)):1}"; shift 2 ;;
            --target-directory=*) target="${arg#--target-directory=}"; shift ;;
            -S) suff="${@:$(($i+1)):1}"; 
               othrargs="$othrargs $arg $suff"; shift 2 ;; 
            --suffix=*) suff="${arg#--suffix=}"; 
               othrargs="$othrargs $arg"; shift ;;
            -* | --*) echo "cp-trash: unrecognized option '"$arg"'"; return 1 ;; 
            --) break ;; 
        esac
    done
   
    if [ -n "$target" ] && ! [ -d "$target" ]; then
        printf "cp: target directory '"$target"': Not a directory\n"
        return 1
    fi
 
    local sorce=("$@")
   
    if [ -z "$target" ]; then
        target="${sorce[-1]}" 
        if [[ -n "$BASH_VERSION" ]]; then
            unset "sorce[${#sorce[@]}-1]"
        elif [[ -n "$ZSH_VERSION" ]]; then 
            # https://stackoverflow.com/questions/3435355/remove-entry-from-array 
            sorce=(${(@)sorce:#sorce[-1]}) 
        fi
    fi
  
    if [ -n "$sorce" ]; then
        local s 
        for s in "${sorce[@]}"; do
            if ! [ -e "$s" ]; then
                echo "cp-trash: file/directory '${YELLOW}"$s"${normal}' doesn't exist. Exiting.."
                return 1
            fi
            
            local trgt 
            if [ -f $target ]; then
                trgt=$target 
            elif [ -d $target ]; then
                if [[ "${target: -1}" == "/" ]]; then
                    trgt="$target$(basename $s)" 
                else
                    trgt="$target/$(basename $s)" 
                fi
            fi
           
            if [ -e "$trgt" ]; then 
                
                local opts="overwrite diff trash"
                local prmpt="[Overwrite/diff/trash]" 
                if ! ([[ "$othrargs" =~ '-b' ]] || [[ "$othrargs" =~ '--backup' ]]); then
                    opts="overwrite diff backup trash"
                    prmpt="[Overwrite/diff/backup/trash]" 
                fi
                echo "About to overwrite ${CYAN}'$trgt'${normal}" 
                reade -Q 'YELLOW' -i "$opts" -p "What to do? $prmpt: " descn
                if [[ "$descn" == 'overwrite' ]]; then
                    if ([[ "$othrargs" =~ "-f" ]] || [[ "$othrargs" =~ '--force' ]]); then
                        eval "$CPTRASH_CMD $othrargs -- '$s' '$target'"
                    else
                        eval "$CPTRASH_CMD -f $othrargs -- '$s' '$target'"
                    fi
                elif [[ "$descn" == 'backup' ]]; then 
                    eval "$CPTRASH_CMD -b $othrargs -- '$s' '$target'"
                elif [[ "$descn" == 'diff' ]]; then 
                    eval "${CPTRASH_DIFF} $s $trgt" 
                    opts="overwrite trash"
                    prmpt="[Overwrite/trash]" 
                    if ! ([[ "$othrargs" =~ '-b' ]] || [[ "$othrargs" =~ '--backup' ]]); then
                        opts="overwrite backup trash"
                        prmpt="[Overwrite/backup/trash]" 
                    fi
                    echo "About to overwrite ${CYAN}'$trgt'${normal}" 
                    reade -Q 'YELLOW' -i "$opts" -p "What to do? $prmpt: " descn1
                    if [[ "$descn1" == 'overwrite' ]]; then
                        if ([[ "$othrargs" =~ "-f" ]] || [[ "$othrargs" =~ '--force' ]]); then
                            eval "$CPTRASH_CMD $othrargs -- '$s' '$target'"
                        else
                            eval "$CPTRASH_CMD -f $othrargs -- '$s' '$target'"
                        fi 
                    elif [[ "$descn1" == 'backup' ]]; then 
                        eval "$CPTRASH_CMD -b $othrargs -- '$s' '$target'"
                    elif [[ "$descn1" == 'trash' ]]; then
                        gio trash "$trgt" 
                        echo "${CYAN}$trgt${normal} trashed before copying"
                        eval "$CPTRASH_CMD $othrargs -- '$s' '$target'"
                        trashed=1 
                    fi
                elif [[ "$descn" == 'trash' ]]; then
                    gio trash "$trgt" 
                    echo "${CYAN}$trgt${normal} trashed before copying"
                    eval "$CPTRASH_CMD $othrargs -- '$s' '$target'"
                    trashed=1 
                fi
            else
                eval "$CPTRASH_CMD $othrargs -- '$s' '$target'"
            fi  
        done
    else
        eval "$CPTRASH_CMD $args"
        return 1
    fi
    if [[ -n $trashed ]]; then
        echo "${GREEN}Backup(s) put in trash. Use ${CYAN}'gio trash --list'${GREEN} to list / ${CYAN}'gio trash --restore'${GREEN} to restore${normal}" 
    fi
}

# Cp recursively and verbose
alias cp="cp-trash -g  --recursive --verbose --force --dereference"
alias cp-lookup-symlinks="cp --dereference --driver parblock"

# mv (recursively native) verbose and only ask for interaction when overwriting newer files

alias mv="mv -g  --force --verbose"
alias mv-skip-existing="mv -nv"
alias move="mv"
alias switch-destination="mv --exchange"
alias mv-exchange="mv --exchange"

function mv-dir-to(){
    local dest
    reade -Q "GREEN" -i "~/" -p "This will copy the entire directory to: " -e dest
    if ! [ -z "$dest" ]; then
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
    
    if [[ -d "$dest" ]]; then
        target=1
    fi
    
    if [ $target == 1 ] ; then
        for s in "${sorce[@]}"; do
            if [[ -a "$dest/$s$suff" ]]; then 
                trash "$dest/$(basename $s$suff)" 
                echo "Backup $dest/$(basename $s$suff) put in trash."
            fi 
        done
    elif [[ -f "$dest$suff" ]]; then
        trash "$dest$suff"  
        echo "Backup(s) put in trash. Use 'gio trash --list' to list / 'gio trash --restore' to restore"
    fi
} 

alias mv="mv -g  --force --verbose"

# Rm 

alias rm="rm-prompt"

shred_iterates=3
alias rm-shred="shred -vzn $shred_iterates -u"

alias remove="rm"
alias rm-all-folder="rm -rv ./*";
alias rm-all-hidden="rm -rv .[!.]* *";


# Ls and Eza

#Always output colours for ls, grep and variants
hash eza &> /dev/null && alias ls="eza --header --color=always --icons=always"

# List directories first
alias ls-dirtop="ls --group-directories-first"

# Listen hidden files and permissions
alias ls-all="ls -Ahl"
alias llnh="ls-all"

# Listen only files, including that are hidden 
alias ls-files="ls -Ahp | grep -v /"

# Listen only directories, including that are hidden
alias ls-dirs="ls -Ahp | grep \".*/$\""

if hash eza &> /dev/null; then

    alias eza="eza --color=always --header --icons=always --smart-group" 
    alias eza-dirtop="eza --group-directories-first"
    alias eza-all="eza -A --long --git --smart-group --octal-permissions --header"
    alias eza-dirs="eza -A --only-dirs" 
    alias eza-files="eza -A --only-files"
    alias eza-git="eza --long --git-repos --header --git" 

hash eza &> /dev/null && alias ls="eza --header --color=always --icons=always"
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

alias egrep='grep --colour=always --extended-regexp'
alias fgrep='grep --colour=always --fixed-strings'
alias grep='grep --colour=always'

alias grep-no-color='grep --color=never'
alias grep-no-case-sensitivwe='grep --ignore-case'

alias rg='rg --color=always'

# Refresh output command every 0.1s

alias refresh="watch -n0 --color"
alias refresh-diff="watch -n0 -d --color"

if hash viddy &> /dev/null; then
    alias refresh="viddy --interval 0.1 --disable_auto_save --shell-options '--login' -- " 
    alias refresh-diff="viddy -D --interval 0.1 --disable_auto_save --shell-options '--login' -- "
fi

#alias cat="bat"

# Redirects to /dev/null 
alias no-output-except-error="> /dev/null"
alias error-null="2> /dev/null"
alias no-error-output="2> /dev/null"
alias all-null="&> /dev/null"
alias no-output="&> /dev/null"

# Show open ports
#alias openports='netstat -nape --inet'

# Wifi enable/disable
if hash nmcli &> /dev/null; then
    alias wifi-enable='nmcli radio wifi on'
    alias wifi-disable='nmcli radio wifi off'
fi

alias q='exit'
#alias q='! [ -z jobs ] && kill -2 "$(jobs -p)" && reade -Q "GREEN" -i "y" -p "Jobs are still running in the background. Send interrupt signal (kill)?: " "n" kill_ && [ "$kill_" == "y" ] && kill "$(jobs -p)" && exit || kill -18 "$(jobs -p)" || exit'
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
    if [[ $# == 1 ]] && [[ -e $1 ]]; then 
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
  if [ -f "$1" ] ; then
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


# whereis    
if hash whereis &> /dev/null; then
     function edit-whereis(){
        if [[ -z $EDITOR ]] && hash nano &> /dev/null; then
            EDITOR=nano 
        fi
        if [[ -z $EDITOR ]] && hash vim &> /dev/null; then
            EDITOR=vim
        fi
        if [[ -z $EDITOR ]] && hash nvim &> /dev/null; then
            EDITOR=nvim 
        fi
        $EDITOR $(whereis $1 | awk '{print $2;}')
     } 
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
    local mktemp_f=$(mktemp) 
    for user in $(cut -f1 -d: /etc/passwd); do 
        echo "$(tput setaf 10)User: $(tput bold)$user"; 
        printf "$(tput setaf 12)Crontab: $(tput bold)"; 
        sudo crontab -u "$user" -l; 
        echo; 
    done &> "$mktemp_f"; 
    cat $mktemp_f | $PAGER; 
    builtin rm $mktemp_f &> /dev/null; 
}
alias crontab-list-all-user-jobs="cron-list-all-user-jobs"
alias list-all-cronjobs-user="cron-list-all-user-jobs"

alias crontab-edit="VISUAL=$CRONEDITOR crontab -e"
alias cron-edit="VISUAL=$CRONEDITOR crontab -e"

alias crontab-add-example-edit="(crontab -l; echo '#* * * * * $USER command') | awk '!x[$0]++' | crontab -; env VISUAL=$CRONEDITOR crontab -e"
alias cron-add-example-edit-="crontab-edit-new"


function crontab-new(){
    #reade -Q 'GREEN' -i 'n' -p "Use ${MAGENTA}https://crontab.guru${GREEN} to get period? (site with explanation around crontabs) [N/y]: " 'y' guru
    #if [[ $guru == 'y' ]]; then
    #    xdg-open https://crontab.guru/     
    #fi
    reade -Q 'GREEN' -i 'custom @yearly @annually @monthly @weekly @daily @hourly @reboot' -p 'When? [Custom/@yearly/@annually/@monthly/@weekly/@daily/@hourly/@reboot]: ' when
    if [[ "$when" == 'custom' ]]; then
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
    users=$(getent passwd | awk -F':' '{print $1}') 
    reade -Q 'GREEN' -i "$USER $users" -p 'User: ' user
    reade -Q 'GREEN' -i "command file" -p 'Script file or command? [Command/file]: ' cmd_file
    if [[ $cmd_file == 'file' ]]; then
        reade -Q 'GREEN' -p 'File to script: ' -e file
        reade -Q 'GREEN' -i 'bash python php zsh dash fish' -p 'Language: ' cmd
        cmd="$cmd $file" 
    else
        reade -Q 'GREEN' -i "''" -p 'Command: ' cmd
    fi
    if [[ 'root' == $user ]] || [[ $user == 'system' ]]; then
        if [[ $format == '@daily' ]]; then
            if ! [ -f /etc/cron.daily/schedule ]; then
                sudo touch /etc/cron.daily/schedule
            fi
            sudo echo "$format root $cmd" >> /etc/cron.daily/schedule
            sudo chmod 600 /etc/cron.daily/schedule 
        elif [[ $format == '@hourly' ]]; then 
            if ! [ -f /etc/cron.hourly/schedule ]; then
                sudo touch /etc/cron.hourly/schedule
            fi
            sudo echo "$format root $cmd" >> /etc/cron.hourly/schedule
            sudo chmod 600 /etc/cron.hourly/schedule 
        elif [[ $format == '@monthly' ]]; then 
            if ! [ -f /etc/cron.monthly/schedule ]; then
                sudo touch /etc/cron.monthly/schedule
            fi
            sudo echo "$format root $cmd" >> /etc/cron.monthly/schedule
            sudo chmod 600 /etc/cron.monthly/schedule 
        elif [[ $format == '@weekly' ]]; then 
            if ! [ -f /etc/cron.weekly/schedule ]; then
                sudo touch /etc/cron.weekly/schedule
            fi
            sudo echo "$format root $cmd" >> /etc/cron.weekly/schedule
            sudo chmod 600 /etc/cron.weekly/schedule 
        else
            if ! [ -f /etc/cron.d/schedule ]; then
                sudo touch /etc/cron.d/schedule
            fi
            sudo echo "$format root $cmd" >> /etc/cron.d/schedule
            sudo chmod 600 /etc/cron.d/schedule 
        fi
    else
        (crontab -l; echo "$format $USER $cmd") | awk '!x[$0]++' | crontab -; 
        VISUAL=$CRONEDITOR crontab -e 
    fi
    unset cmd cmd_file file user days month week minutes hour guru users
}

alias cron-new='crontab-new'

function ln-soft(){
    if ([ -d "$1" ] || [ -f "$1" ]); then 
        if [ -n "$2" ] && ([[ $(readlink -f "$2") ]] || [[ $(readlink -d "$2") ]]); then
            if [[ "$1" == /* ]]; then  
                ln -s "$1" "$2";
            else     
                ln -s "$(pwd)/$1" "$2";
            fi;
        else
            if [[ "$1" == /* ]]; then  
                ln -s "$1" $(basename "$1")
            else     
                ln -s "$(pwd)/$1" $(basename "$1")
            fi;
        fi
        return 0
    else
        echo "Give up a file or folder please";
        return 1
    fi
}

alias link-soft="ln-soft"
alias softlink="ln-soft"
alias symlink="ln-soft"

function ln-hard(){
    if ([[ "$0" = /* ]] || [ -d "$1" ] || [ -f "$1" ]); then
        if [ -n "$2" ] && ([[ $(readlink -f "$2") ]] || [[ $(readlink -d "$2") ]]); then
            if [[ "$1" == /* ]]; then  
                ln "$1" "$2";
            else     
                ln "$(pwd)/$1" "$2";
            fi
        else
            if [[ "$1" == /* ]]; then  
                ln "$1" $(basename "$1")
            else     
                ln "$(pwd)/$1" $(basename "$1")
            fi; 
        fi
        return 0
    else
        echo "Give up a file or folder please";
        return 1
    fi
}

alias hardlink="ln-hard"

alias trash-list="gio trash --list"
alias trash-empty="gio trash --empty"

function trash(){
    for arg in "$@" ; do
        if [ -f "$arg" ] || [ -d "$arg" ]; then
            gio trash "$arg";
            if [ $(gio trash --list | wc -l) -gt "$TRASHBIN_LIMIT" ]; then
                local ansr
                echo "${red1}Trashbin has more then $TRASHBIN_LIMIT items${normal}"
                readyn -Y 'YELLOW' -p "Empty? ('trash-restore' to restore)"  ansr
                if [[ $ansr == "y" ]]; then
                    trash-empty
                fi
            fi
        elif [ -L "$arg" ]; then
            command rm $arg;
        else
            echo "Trash one or more files / directories. Nothing passed as argument";
        fi
    done
}

function trash-restore(){
    for arg in "$@"; do
        gio trash --restore "$arg";
    done
}

function add-to-group() {
    if [ -z $1 ]; then
        echo "Give a user and the group (user can be empty - default: $USER)"
    elif [ -z $2 ]; then
        sudo usermod -aG $USER $1;
    else
        sudo usermod -aG $1 $2;
    fi 
}


# https://stackoverflow.com/questions/22381983/how-to-check-file-owner-in-linux
# I still do == cause used to ¯\_(ツ)_/¯
#

function set-executable-user() {
    if [ -n "$@" ]; then
        for i in "$@"; do 
            if [[ "$(stat -c '%U' "$i")" == 'root' ]] || ! [[ "$(stat -c '%U' "$i")" == "$USER" ]]; then
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
    if [ -n "$@" ]; then
        for i in "$@"; do 
            if [[ "$(stat -c '%U' "$i")" == 'root' ]] || ! [[ "$(stat -c '%U' "$i")" == "$USER" ]]; then
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
    if [ -n "$@" ]; then
        for i in "$@"; do 
            if [[ "$(stat -c '%U' "$i")" == 'root' ]] || ! [[ "$(stat -c '%U' "$i")" == "$USER" ]]; then
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
    if [ -n "$@" ]; then
        for i in "$@"; do 
            if [[ "$(stat -c '%U' "$i")" == 'root' ]] || ! [[ "$(stat -c '%U' "$i")" == "$USER" ]]; then
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
    if [ -n "$@" ]; then
        for i in "$@"; do 
            if [[ "$(stat -c '%U' "$i")" == 'root' ]] || ! [[ "$(stat -c '%U' "$i")" == "$USER" ]]; then
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
    if [ -n "$@" ]; then
        for i in "$@"; do 
            if [[ "$(stat -c '%U' "$i")" == 'root' ]] || ! [[ "$(stat -c '%U' "$i")" == "$USER" ]]; then
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
    if [ -n "$@" ]; then
        for i in "$@"; do 
            if [[ "$(stat -c '%U' "$i")" == 'root' ]] || ! [[ "$(stat -c '%U' "$i")" == "$USER" ]]; then
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
    local i 
    if [ -n "$@" ]; then
        for i in "$@"; do 
            if [[ "$(stat -c '%U' "$i")" == 'root' ]] || ! [[ "$(stat -c '%U' "$i")" == "$USER" ]]; then
                sudo chmod -x $i;
            else
                chmod -x $i    
            fi 
            llnh $i 
        done
    fi
}

alias remove-executable-user="unset-executable-user"
alias remove-executable-group="unset-executable-group"
alias remove-executable-other="unset-executable-other"
alias remove-executable-all="unset-executable-all"

# FIND 

hash fd &> /dev/null && alias fd='fd --color=always --hidden'

tree=''
hash tree &> /dev/null && 
   tree=' | tree '


if type fd &> /dev/null; then
    alias find-files-dir="fd --search-path . --type file" 
    alias find-files-system="fd --search-path / --type file" 
    alias find-symlinks-dir="fd --search-path . --type symlink $tree | $PAGER"
    alias find-symlinks-system="fd --search-path / --type symlink $tree | $PAGER"
else
    alias find-files-dir="find . -type f" 
    alias find-files-system="find / -type f" 
    alias find-symlinks-dir="find . -type l -exec ls --color -d {} \ $tree | $PAGER"
    alias find-symlinks-system="find / -type l -exec ls --color -d {} \ $tree | $PAGER"
fi
unset tree

alias locales-list-enabled="locale -a"

# https://askubuntu.com/questions/76808/how-do-i-use-variables-in-a-sed-command
# https://stackoverflow.com/questions/18439528/sed-insert-line-with-spaces-to-a-specific-line    

# Escape pathnames to files and dirs properly before putting them on the prompt
# !! This does not work only as function but does when bound to a key (or turned into a widget and then bound to a key for ZSH). I didn't realize this when writing this !!
function print-path-to-prompt(){
    local lines="n"
    while getopts ':l' flag; do
        case "${flag}" in
            l)  lines="y"
                shift 
                ;;
        esac
    done 
    OPTIND=1;
    local p 
    if [ -z "$@" ]; then
        p="$(pwd)" 
    else
        p="$@"
    fi
    local fls=$(echo "$p" | sed 's| |\\ |g; s|\[|\\\[|g; s|\]|\\\]|g; s|(|\\(|g; s|)|\\)|g; s|{|\\{|g; s|}|\\}|g')
    if [[ $lines == 'n' ]]; then
        fls="$(echo $fls | tr "\n" ' ')"
    fi
    if [ -n "$BASH_VERSION" ]; then
        READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$fls${READLINE_LINE:$READLINE_POINT}"
        READLINE_POINT=$(( READLINE_POINT + ${#fls} ))
    elif [ -n "$ZSH_VERSION" ]; then 
        BUFFER="${BUFFER:0:$CURSOR}$fls${BUFFER:$CURSOR}"
        CURSOR=$(( $CURSOR + ${#fls} ))
    fi 
}

# bind -x '"\C-b": print-path-to-prompt'

# Set an escape character \ before each space
function escape_spaces(){
     sed 's/ /\\ /g' <<< $@; 
}

function lines-to-words(){
    # 1 Output with lines
    # 2 Return string with words
    IFS=$'\n' read -d "\034" -r -a $2 <<<"$1\034";
}


function file-insert-after-line(){
    if [ -f "$1" ]; then
       var1=$(sed 's/ /\\ /g' <<< $2);
       var2=$(sed 's/ /\\ /g' <<< $3);
       sed -i "/${var1}*/a ${var2}" "$1";
    else
        echo "Give up a filename.\n Give all arguments that use spaces a \" \"";
    fi
}

function file-put-quotations-around(){
    if [ -f "$1" ]; then
        var1=$(sed 's/ /\\ /g' <<< $2);
       sed -i "s/${var1}/\"&\"/" "$1";
    else
        echo "Give up a filename.\n Give all arguments that use spaces a \" \"";
    fi
}

alias shutdown-now='shutdown now'

function list-iommu-groups(){
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
alias free-kilob='command free --kilo'
alias free-megab='command free --mega'
alias free-gigab='command free --giga'

# Du

alias du="du -hs | awk '{print \$1}'"

if hash ncdu &> /dev/null; then
   alias ncdu='ncdu --color dark' 
   alias du-tui='ncdu' 
fi

if hash ncdu &> /dev/null && ! hash dua &> /dev/null; then
   alias dua-interactive='ncdu' 
fi

if hash dua &> /dev/null; then
   alias dua-interactive='dua interactive' 
   alias du-tui='dua interactive' 
   alias dua-aggregate='dua aggregate' 
fi

if ! hash ncdu &> /dev/null && hash dua &> /dev/null; then
   alias ncdu='dua interactive' 
fi

alias du="dua"
alias du="dua interactive"

alias folder-size="du"
alias dir-size="du"
alias dirsize="du"

# Df
alias df='df -h -T --total'

alias df='duf'
alias lfs='dysk'

alias regenerate-initrams="sudo mkinitcpio"
alias regenerate-initrams-all-kernels="sudo mkinitcpio -P"

alias list-drivers-modules-in-use="lspci -nnk"
alias motherboard-info="sudo dmidecode -t 1 && sudo dmidecode -t 2"
alias mobo-info="motherboard-info"
alias bios-info="sudo dmidecode -t 0"
alias motherboard-info-full="sudo dmidecode -t 1 && sudo dmidecode -t 2 && sudo dmidecode -t 0 | $PAGER"

# Dual boot stuff

function boot-into(){
    local bootnt 
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
}

alias reboot-into="boot-into"
alias next-boot="boot-into"

function change-username-and-homefolder(){
    ! shopt -q login_shell && 
        printf "${RED}Not login shell\nLogout, press 'Ctrl+Alt+F1/F2/...F6' to drop to a login shell and login as root or a user other then the one you want to change.\n${YELLOW}(Make sure the root account is enabled with 'sudo passwd su' - you can disable it afterwards with 'sudo passwd -l su')${normal}\n" && 
        return 1
    
    local usrname usrname_nw 
    local frst="$(echo $(users | word2line | uniq | grep -v root ) | awk '{print $1}')" 
    local words="$(echo $words | sed "s/\<$frst\> //g")" 
    reade -Q 'CYAN' -i "$frst $words" -p "Old username (Empty = $frst): " usrname 
    [ -z "$usrname" ] && 
        usrname="$frst" 
    [[ "$USER" == "$usrname" ]] && 
        printf "${RED}Can't change username for $usrname while logged as said\nLogout, press 'Ctrl+Alt+F1/F2/...F6' to drop to a login shell (if not already in one) and login as root or a user other then the one you want to change.\n${YELLOW}(Make sure the root account is enabled with 'sudo passwd su' - you can disable it afterwards with 'sudo passwd -l su')${normal}\n" && 
        return 1 
    
    reade -Q 'MAGENTA' -p 'New username: ' usrname_nw 
    if [ -n "$usrname_nw" ]; then
        if [ -n "$(ps -U $usrname 2> /dev/null)" ]; then
            printf "There are still processes running under user $usrname!\nKilling all processes for user..."  
            sleep 5
            sudo pkill -U $(id -u "$usrname") 
            printf "Done!\n" 
        fi
        
        sudo usermod -l "$usrname_nw" -d /home/"$usrname_nw" -m "$usrname" &&  
        sudo groupmod -n "$usrname_nw" "$usrname" &&  
        sudo [ -f /etc/lightdm/lightdm.conf ] && sudo grep -q "autologin-user=$usrname" /etc/lightdm/lightdm.conf && 
            sudo sed -i "s/^autologin-user=$usrname/autologin-user=$usrname_nw/g" /etc/lightdm/lightdm.conf &&
            [ -f /home/$usrname_nw/.config/starship.toml ] && grep -q "/home/$usrname" /home/$usrname_nw/.config/starship.toml && 
                sed -i "s|/home/$usrname|/home/$usrname_nw|g" /home/$usrname_nw/.config/starship.toml   
                printf "${GREEN}Changed username and homedirectory to $usrname_nw!${normal}\n" && 
                return 0 || 
                return 1; 
    else
        printf "${YELLOW}Please give up a new username to change to.${normal}\n"
        return 1 
    fi
}

function change-device-name-to(){
    local name oldname=$(hostname) 
    reade -Q 'CYAN' -p "New device name (hostname): " name
    [ -z "$name" ] && 
        printf "Name cant be empty.\n" && 
        return 1
    
    sudo hostnamectl set-hostname "$name" 
    
    sudo sed -i "s/$oldname/$name/g" /etc/hosts &&
    sudo sed -i "s/$oldname/$name/g" /etc/hostname && 
    printf "${GREEN}Changed device name (hostname) to $name!${normal}\n" &&
    return 0 || 
    return 1;
}
