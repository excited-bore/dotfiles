
export EMAIL="stan96@duck.com"
export GITNAME="excited-bore"

export INPUTRC='~/.inputrc'
export RANGER_LOAD_DEFAULT_RC="~/rc.conf"
export EDITOR="nvim"
export VISUAL="nvim"
export PTRACE_ELEVATED_PRIVILIGE="1"

export TMPDIR=/tmp
export PYTHONPATH='/usr/bin/python:/usr/bin/python3:/usr/bin/python3.10'
export PATH=$PATH:/usr/local/go/bin:/usr/bin/go:/usr/lib/go:/usr/share/go:/snap/bin:/var/lib/snapd/snap/bin:~/.emacs.d/bin/

# $XDG_DATA_HOME defines the base directory relative to which user-specific data files should be stored. If $XDG_DATA_HOME is either not set or empty, a default equal to $HOME/.local/share should be used. 
export XDG_DATA_HOME=$HOME/.local/share
# $XDG_DATA_DIRS defines the preference-ordered set of base directories to search for data files in addition to the $XDG_DATA_HOME base directory. The directories in $XDG_DATA_DIRS should be seperated with a colon ':'. 
# If $XDG_DATA_DIRS is either not set or empty, a value equal to /usr/local/share/:/usr/share/ should be used. 
export XDG_DATA_DIRS=/usr/local/share/:/usr/share  
# $XDG_CONFIG_HOME defines the base directory relative to which user-specific configuration files should be stored. If $XDG_CONFIG_HOME is either not set or empty, a default equal to $HOME/.config should be used.
export XDG_CONFIG_HOME=$HOME/.config
#  $XDG_CONFIG_DIRS defines the preference-ordered set of base directories to search for configuration files in addition to the $XDG_CONFIG_HOME base directory. The directories in $XDG_CONFIG_DIRS should be seperated with a colon ':'.
#If $XDG_CONFIG_DIRS is either not set or empty, a value equal to /etc/xdg should be used. 
export XDG_CONFIG_DIRS=/etc/xdg 
# $XDG_STATE_HOME defines the base directory relative to which user-specific state files should be stored. If $XDG_STATE_HOME is either not set or empty, a default equal to $HOME/.local/state should be used. 
export XDG_STATE_HOME=$HOME/.local/state
# $XDG_CACHE_HOME defines the base directory relative to which user-specific non-essential data files should be stored. If $XDG_CACHE_HOME is either not set or empty, a default equal to $HOME/.cache should be used. 
export XDG_CACHE_HOME=$HOME/.cache
# $XDG_RUNTIME_DIR defines the base directory relative to which user-specific non-essential runtime files and other file objects (such as sockets, named pipes, ...) should be stored. The directory MUST be owned by the user, and he MUST be the only one having read and write access to it. Its Unix access mode MUST be 0700. 
export XDG_RUNTIME_DIR=/run/user/1000

# Either one of (in order of decreasing importance) emerg, alert, crit, err, warning, notice, info, debug, or an integer in the range 0…7
# This can be overridden with --log-level=.
export SYSTEMD_LOG_LEVEL="warning"
# A boolean. If true, messages written to the tty will be colored according to priority.
# This can be overridden with --log-color=.
export SYSTEMD_LOG_COLOR="true"
# A boolean. If true, console log messages will be prefixed with a timestamp.
# This can be overridden with --log-time=.
export SYSTEMD_LOG_TIME="true"
# A boolean. If true, messages will be prefixed with a filename and line number in the source code where the message originates.
# This can be overridden with --log-location=.
export SYSTEMD_LOG_LOCATION="true"
# A boolean. If true, messages will be prefixed with the current numerical thread ID (TID).
export SYSTEMD_LOG_TID="true"
# The destination for log messages. One of console (log to the attached tty), console-prefixed (log to the attached tty but with prefixes encoding the log level and "facility", see syslog(3), kmsg (log to the kernel circular log buffer), journal (log to the journal), journal-or-kmsg (log to the journal if available, and to kmsg otherwise), auto (determine the appropriate log target automatically, the default), null (disable log output).
# This can be overridden with --log-target=
export SYSTEMD_LOG_TARGET="auto"


function ptrace_toggle() {
    echo "Has ptrace currently elevated priviliges: $PTRACE_ELEVATED_PRIVILIGE";
    echo "Change? y/n: ";
    if [[ ! $(read) = "y" ]];then
        return;
    fi
    if [ $PTRACE_ELEVATED_PRIVILIGE == 1 ]; then
        export PTRACE_ELEVATED_PRIVILIGE="0";
    else
        export PTRACE_ELEVATED_PRIVILIGE="1";
    fi
    doas echo $PTRACE_ELEVATED_PRIVILIGE > /proc/sys/kernel/yama/ptrace_scope;   
}
# python virtual env
#python3 -m venv python3
#source venv/bin/activate

# Jump to bottom of screen
# https://stackoverflow.com/questions/49733211/bash-jump-to-bottom-of-terminal

# For Tabcompletion 
complete -cf doas

# Doas gives less overhead. True example of less > more
alias sudo="doas -n"
function doasedit() { doas $EDITOR $1; }
alias sudoedit='doasedit'

# Check doas.conf works or not
alias check_conf_doas="doas doas -C /etc/doas.conf && echo 'config ok' || echo 'config error'"

alias edit_doas="doasedit /etc/doas.conf && check_conf_doas"

# Or, alternatively
# Preserve env
#alias sudo="sudo -E"

# TRY and keep command line at bottom
alias b="tput cup $(tput lines) 0" 
# Cp / rm recursively
alias cp="cp -riv"
alias mv="mv -iv"
alias rm="rm -riv"
alias rmTrash="trash"
# With parent directories and verbose
alias mkdir="mkdir -pv"
# Listen hidden files and permissions
alias lsAll="ls -al"
alias less="less -X"
alias r=". ~/.bashrc " # && . ~/.inputrc"
alias q="exit"
alias w="cd -"
alias w="clear ;b; ls -a"
alias x="cd .."
alias men="man man"
alias bashBinds="bind -p | less"
alias sttyBinds="stty -a"

# Bash bind bindings
# \e : escape
# \M : Meta (alt)
# \t : tab
# \C : Ctrl
# nop => no operation
# 'bind -l' for all options
#
# You can also run 'read'
# That way you can read the characters escape sequences
# The ^[ indicates an escape character in your shell, so this means that your f.ex. Home key has an escape code of [1~ and you End key has an escape code of [4~. Since these escape codes are not listed in the default Readline configuration, you will need to add them: \e[1~ or \e[4~
# Ctrl-c to quit

bind -x '"\C-l":"clear && b && ls"'
#bind -x '"\C-q": quoted-insert"'
#bind -x '"\C-o":"cd - \n"' 
b && ls 

## stty settings
# see with 'stty -a'
# unbinds ctrl-c and bind the function to ctrl-x
stty intr '^x'
stty start 'undef' 
stty stop 'undef' 
#stty 'eol' 'home'


# Ask for Interaction when overwriting newer files
function lnSoft(){
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

if [ ! -e ~/lib_systemd ]; then
    lnSoft /lib/systemd/system/ ~/lib_systemd
fi

if [ ! -e ~/etc_systemd ]; then
    lnSoft /etc/systemd/system/ ~/etc_systemd
fi

if [ ! -e ~/.vimrc ]; then
    lnSoft .config/nvim/init.vim ~/.vimrc
fi


function lnHard(){
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

# No screen clear after use
# https://superuser.com/questions/106637/less-command-clearing-screen-upon-exit-how-to-switch-it-off

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

alias trashList="gio trash --list"
alias trashEmpty="gio trash --empty"

function trashRestore(){
    for arg in $@; do
        gio trash --restore $arg;
    done
}

function add_to_group() {
    if [[ -z $1 ]]; then
        echo "Give a group and a username (default: $USER)"
    elif [[ -z $2 ]]; then
        sudo usermod -aG $1 $USER
    else
        sudo usermod -aG $1 $2
    fi; }

function mark_user_executable() {
    if [[ ! -f $1 ]] ; then
        echo "Give a file to set as an executable"
    else
        sudo chmod u+x $1
    fi; }

function create_systemd_daemon(){
    read -p "Give up a '*.service' name: " inpt;
    if [ -z "$inpt" ]; then
        echo "Give up a viable filename please";
        return;
    else
        serv=/etc/systemd/system/"$inpt.service";
        echo "File will be at '$serv'";
        sleep 2;
        if [ -e ~/systemd_example.service ]; then
            doas cp ~/systemd_example.service $serv;
        else
            doas touch $serv;
            doas echo "[Unit]" >> $serv;
            doas echo "Description=Example systemd service." >> $serv;

            doas echo "[Service]" >> $serv;
            doas echo "Type=simple" >> $serv;
            doas echo "ExecStart=/bin/bash /usr/bin/test_service.sh" >> $serv;

            doas echo "[Install]" >> $serv;
            doas echo "WantedBy=multi-user.target" >> $serv;
        fi
    fi
    doas chmod 644 $serv;
    doasedit $serv;
    systemctl_start $serv;
}   

alias systemctl_list_unit_services="doas systemctl list-units --type=service"
alias systemctl_list_unit_sockets="doas systemctl list-units --type=socket"
alias systemctl_list_unit_files="doas systemctl list-unit-files"
alias systemctl_start="doas systemctl start"
alias systemctl_restart="doas systemctl restart"
alias systemctl_stop="doas systemctl stop"
alias systemctl_enable="doas systemctl enable"
alias systemctl_enable_now="doas systemctl enable --now"
alias systemctl_disable="doas systemctl disable"
alias systemctl_disable_now="doas systmctl disable --now"
alias systemctl_status_daemon="doas systemctl status"
alias systemctl_bios="doas systemctl reboot --firmware-setup"
alias systemctl_bluetooth_startup="doas systemctl start bluetooth.service && blueman-manager"
alias systemctl_bluetooth_down="doas systemctl stop bluetooth.service"
alias systemctl_devolo_startup="doas systemctl start devolonetsvc.service && bash /opt/devolo/dlancockpit/bin/dlancockpit-run.sh"
alias systemctl_devolo_down="doas systemctl stop devolonetsvc.service"

alias journalctl_boot="doas journalctl -xb"
alias journalctl_live="doas journalctl -xf"

#Package Managers (don't run pamac with sudo)
alias update_pacman="doas pacman -Syu"
alias update_pamac="pamac update"
alias update_packages="update_pacman && update_pamac"

# Kdocker is a system tray app
# thunderbird does not support trays on linux, which why we do this
alias thunderbird="kdocker thunderbird"


### VIM ###

alias vim="nvim -u ~/.config/nvim/init.vim" 
alias check_nvim_health="vim +checkhealth"
alias install_nvim_plugin="vim +PluginInstall +qall"


### TMUX ###

# PWD trick
#export PS1=$PS1'$( [ -n $TMUX ] && tmux setenv -g TMUX_PWD_$(tmux display -p "#D" | tr -d %) $PWD)'

# Start tmux on shell start
#if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [ -z "$TMUX" ]; then
#    tmux has-session -t main 2>/dev/null
#    if [ $? != 0 ]; then
#        exec tmux new -s main 
#    else
#        exec tmux new -t main
#    fi 
#fi

#https://stackoverflow.com/questions/41783367/tmux-tmux-true-color-is-not-working-properly
alias check_terminal_colours="curl -s https://raw.githubusercontent.com/JohnMorales/dotfiles/master/colors/24-bit-color.sh | bash"

function tmuxNewSession(){
    if ! [ -z $1 ]; then
        if ! [ -z $2 ]; then
            tmux new -s $1 -n $2;
        fi;
        tmux new -s $1;
    else
        echo "Give up a name for a new session (and a window name)\n";
    fi;
}

function tmuxAttach(){
    if ! [ -z $1 ]; then
        tmux attach -t $1;
    else 
        tmux attach ;
    fi; 
}

function tmuxDetachedSession(){
    if ! [ -z $1 ]; then    
        tmux new -d send-keys "$1";
    else 
        echo "Give up a command to run";
    fi;
}

alias tmuxKillServer="tmux kill-server"

function tmuxKillAllButOne(){
    if ! [ -z "$1" ]; then
        tmux kill-session -a -t "$1";
    else
        #Current session
        tmux kill-session -a;
    fi;
}

alias tmuxAttachChooseTree="tmux choose-tree -NO"
alias tmuxShowHooks="tmux show-hooks"
alias tmuxListSessions="tmux ls"
alias tmuxListKeybinds="tmux list-keys"

#alias tmuxTogglePanesSyncCommands="setw synchronize-panes"

### SSH ###

# To prevent 'failed to preserve ownership' errors
function cpSsh(){ cp -r --no-preserve=mode "$1" "$2"; }
function mvSsh(){ cp -r --no-preserve=mode "$1" "$2" && rmTrash "$1"; }

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

#serberMnt
#serberMnt1

function vlcFolder(){
    if [ -d $1 ]; then
        vlc --recursive expand "./$1";
    else
        pwd | vlc --recursive expand ;
    fi;
}

#Git stuff
alias git_list_remotes="git remote -v"
function git_list_sshKey() { cd ~/.ssh/ && echo ~/.ssh/$1 | ssh-keygen -t ed25519 -C $1 && eval "$(ssh-agent -s)" && ssh-add ~/.ssh/$1 && cat $1.pub; }
function git_config() { git config --global user.email $EMAIL && git config --global user.name $NAME; }
function git_test_conn_github() { ssh -vT git@github.com; }
function git_add_remote_url() { git remote -v add "$1" "$2"; }
function git_add_remote_ssh() { git remote -v add "$1" git@github.com:$GITNAME/"$2.git"; }

function git_status() { git status; }
function git_commit_all() { 
    if [ ! -z "$1" ]; then 
        git commit -am "$1"; 
    else
        git commit -a ;
    fi; }

alias git_commit_using_last="git commit --amend"
alias git_list_branches="git branch --list"

#https://stackoverflow.com/questions/1125968/how-do-i-force-git-pull-to-overwrite-local-files
function git_backup_branch_and_reset_to_remote() {
    remote=origin;
    branch=master;
    backp_branch=1;
    stash=false;
    
    if [ ! -z "$1" ] && [[ ! $(gitListRemotes | grep -q $1) ]]; then
        echo "Use a legit remote or add it using 'git_add_remote_ssh' or 'git_add_remote_url'";
    elif [ ! -z "$1" ];then
        remote=$1;
    fi
    echo "Using '$1' as remote\n";
    
    if [ ! -z "$2" ] && [[ ! $(gitListBranches | grep -q $2) ]]; then
        echo "Use a legit branch or add it using 'git_add_branch'";
    elif [ ! -z "$2" ];then
        remote=$2;
    fi
    echo "Using '$2' as branch\n";
    
    if [ ! -z "$3" ] && [ ! "$3" = true ]; then
        for cnt in $(git branch --list | grep --regex 'main.' | wc -l) ; do
       $backp_branch+=1;
    done

    elif [ "$3" = true ];then
        stash=true;
    fi

    if [ ! -z "$1" ] && [ ! -z "$2" ]; then
        git checkout "$2";
        git stash ;
        git fetch --all ;
        git branch "$1" ;
        git reset --hard "$2" ;
        if [ "$3" = true ]; then
            git stash pop;
        else
            echo "No uncomitted changes kept. They can be reapplied with 'git stash pop'"; 
        fi
    elif [ ! -z "$1" ] && [ -z "$2"]; then
        git checkout main;
        git stash;
        git branch "$3" ;
        git fetch --all ;
        git reset --hard origin/main ;
        if [ "$4" = true ]; then
            git checkout "$1";
            git stash pop;
        else    
            echo "No uncomitted changes kept. They can be reapplied with 'git checkout $1 ; git stash pop'";
        fi
    else
        echo "First backup branch, then remote. No remote means 'origin/main'" ;
    fi   
}
alias git_rename_remote="git remote -v rename"
alias git_remove_remote="git remote -v rm"
alias git_switch_branch="git checkout"

function git_set_default_remote_branch() { 
    if [ -z "$1" ] && [ -z "$2" ]; then
        git remote set-head origin main;
    elif [ -z "$1" ]; then
        git remote set-head origin "$2";
    else
        git remote set-head "$1" "$2";
    fi
}
function git_remote_get_default_branch() { 
    if [ -z "$1" ]; then
        git remote set-head origin -a;
    else 
        git remote set-head "$1" -a;
    fi
}

# Docker
alias docker_update="docker-compose down && docker-compose pull && docker-compose up &"
alias pihole_update="cd ~/Applications/docker-pi-hole && docker_update"

alias ds4LOn="ds4drv --led ff0000"
alias ds4LOff="ds4drv --led 000000"
alias ds4="python3 -m ds4drv --hidraw --udp --udp-port 26760"

alias udev_reload="sudo udevadm control --reload-rules && sudo udevadm trigger"

#Devolo PLC Stuff

alias wick="sudo wickrme --no-sandbox"

alias check_songs='serber "cd /mnt/MyStuff/Files/Audio/ && ls | xargs -0"'
alias check_youtubes='serber "cd /mnt/MyStuff/Files/Videos/YouTubes/ && ls | xargs -0 "'

function youtube_video(){
    if [ ! -z "$1" ]; then                                
        youtube-dl -c -i -R 20  --write-sub --yes-playlist "$1" start $end;
    else
        echo "Give up a url, big guy. Know you can do it xoxox" ;
    fi
}

# Numbered tracks => -o "%(playlist)s\%(playlist_index)s - %(title)s.%(ext)s"

function youtube_playList(){
    start=" "
    end=" " 
    if [ ! -z "$2" ]; then
        start=" --playlist-start $2";
    fi
    if [ ! -z "$3" ]; then
        end=" --playlist-end $3";
    fi    
    if [ ! -z "$1" ]; then                                
        youtube-dl -c -i -R 20 -o "%(playlist)s\%(playlist_index)s - %(title)s.%(ext)s" --write-sub --yes-playlist "$1" $start $end;
    else
        echo "Give up a url, big guy. Know you can do it xoxox" ;
    fi
}

function youtube_playList_onlyAudio(){
    start=" "
    end=" " 
    if [ ! -z "$3" ]; then
        start=" --playlist-start $3";
    fi
    if [ ! -z "$4" ]; then
        end=" --playlist-end $4";
    fi
    if [ ! -z "$1" ]; then    
        if [ ! -z "$2" ]; then
            youtube-dl -c -i -R 20 -o "%(playlist)s\%(playlist_index)s - %(title)s.%(ext)s" -x --audio-format $2 --write-sub --yes-playlist "$1" $start $end;
        else 
            youtube-dl -c -i -R 20 -o "%(playlist)s\%(playlist_index)s - %(title)s.%(ext)s" -x --audio-format mp3 --write-sub --yes-playlist "$1" $start $end;
        fi
    else
        echo "Give up a url, big guy. Know you can do it xoxox" ;
    fi
}

function youtube_playList_dir(){
    start=" "
    end=" " 
    if [ ! -z "$3" ]; then
        start=" --playlist-start $3";
    fi
    if [ ! -z "$4" ]; then
        end=" --playlist-end $4";
    fi
    if [ ! -z "$1" ] && [ ! -z "$2" ]; then
        mkdir "$2";
        cd "$2"; 
        youtube-dl -c -i -R 20 -o "%(playlist)s\%(playlist_index)s - %(title)s.%(ext)s" --write-sub --yes-playlist "$1" $start $end ; 
    else
        echo "Give up a url and dir, big guy. Know you can do it xoxox" ;
    fi
}

function youtube_playList_onlyAudio_dir(){
    start=" "
    end=" " 
    if [ ! -z "$3" ]; then
        start="--playlist-start $3";
    fi
    if [ ! -z "$4" ]; then
        end=" --playlist-end $4";
    fi
    if [ -z "$1"] || [ -z "$2" ]; then
        echo "Give up a url and a dir, big guy. Know you can do it xoxox";
    else
        mkdir "$2";
        cd "$2";    
        if [ ! -z "$3" ]; then
            youtube-dl -c -i -R 20 -o "%(playlist)s\%(playlist_index)s - %(title)s.%(ext)s" -x --audio-format $3 --write-sub --yes-playlist "$1" $start $end ;
        else 
            youtube-dl -c -i -R 20 -o "%(playlist)s\%(playlist_index)s - %(title)s.%(ext)s" -x --audio-format mp3 --write-sub --yes-playlist "$1" $start $end;
        fi
    fi
}

#alias vmOn="sudo virsh net-autostart default && sudo virsh net-start default && sudo mv /etc/modprobe.d/vfio.conf.orig /etc/modprobe.d/vfio.conf && sudo mkinitcpio -p linux515 && reboot"
#alias vmOff="sudo virsh net-destroy default && sudo mv /etc/modprobe.d/vfio.conf /etc/modprobe.d/vfio.conf.orig && sudo mkinitcpio -p linux515 && reboot"
