export NAME="Stan Nys"
export EMAIL="stan96@duck.com"
export GITNAME="excited-bore"

# PWD trick
export PS1=$PS1'$( [ -n $TMUX ] && tmux setenv -g TMUX_PWD_$(tmux display -p "#D" | tr -d %) $PWD)'
export PYTHONPATH=/usr/bin/python:/usr/bin/python3:/usr/bin/python3.10

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

# Jump to bottom of screen
# https://stackoverflow.com/questions/49733211/bash-jump-to-bottom-of-terminal
alias b="tput cup $(tput lines) 0" 

bind -x '"\C-l":"clear;b;ls"'
b;ls 

## stty settings
# see with 'stty -a'
# unbinds ctrl-c and bind the function to ctrl-d
stty 'intr' '^d'

# Listen hidden files and permissions
alias lsAll="ls -al"

# Preserve env
alias sudo="sudo -E"
# Cp / rm recursively
alias cp="cp -r"
alias rm="rm -r"
# Ask for Interaction when overwriting newer files
alias mv="mv -i"
alias rmTrash="trash"
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

function lnHard(){
    if ([[ "$1" = /* ]] || [ -d "$1" ] || [ -f "$1" ]) && ([[ $(readlink -f "$2") ]] || [[ $(readlink -d "$2") ]]); then
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
alias less="less -X"
alias r=". ~/.bashrc" # && . ~/.inputrc"
alias x="exit"
alias w="clear ;b; ls -a"
alias c="cd .."
alias men="man man"
alias bashBinds="bind -p | less"
alias ttyBinds="stty -a"

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
    for arg in $@
    do
        gio trash --restore $arg;
    done
}



function addToGroup() {
    if [[ -z $1 ]]; then
        echo "Give a group and a username (default: $USER)"
    elif [[ -z $2 ]]; then
        sudo usermod -aG $1 $USER
    else
        sudo usermod -aG $1 $2
    fi; }

function markExecutable() {
    if [[ ! -f $1 ]] ; then
        echo "Give a file to make executable"
    else
        sudo chmod u+x $1
    fi; }

alias start="sudo systemctl start"
alias stop="sudo systemctl stop"
alias enable="sudo systemctl enable"
alias enableNow="sudo systemctl enable --now"
alias disable="sudo systemctl disable"
alias disableNow="sudo systmctl disable --now"
alias status="sudo systemctl status"
alias bios="sudo systemctl reboot --firmware-setup"
alias blueUp="sudo systemctl start bluetooth.service && blueman-manager"
alias blueDown="sudo systemctl stop bluetooth.service"
alias devUp="sudo systemctl start devolonetsvc.service && bash /opt/devolo/dlancockpit/bin/dlancockpit-run.sh"
alias devDown="sudo systemctl stop devolonetsvc.service"

alias journBoot="sudo journalctl -b"
alias journLive="sudo journalctl -f"

#Package Managers (don't run pamac with sudo)
alias up="pamac update"

# Kdocker is a system tray app
# thunderbird does not support trays on linux, which why we do this
alias thunderbird="kdocker thunderbird"

### TMUX ###
alias vim="nvim"
alias vimCheckhealth="vim +checkhealth"
alias vimPluginInstall="vim +PluginInstall +qall"

### TMUX ###

# Start tmux on shell start
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [ -z "$TMUX" ]; then
    tmux has-session -t main 2>/dev/null
    if [ $? != 0 ]; then
        exec tmux new -s main 
    else
        exec tmux new -t main
    fi 
fi

#https://stackoverflow.com/questions/41783367/tmux-tmux-true-color-is-not-working-properly
alias checkColours="curl -s https://raw.githubusercontent.com/JohnMorales/dotfiles/master/colors/24-bit-color.sh | bash"

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

function serberMnt() {
    if [ ! -d /mnt/mount1 ]; then
        mkdir /mnt/mount1; 
    fi;
    if [ ! -d ~/Files/ ]; then
        lnSoft /mnt/mount1 ~/Files;
    fi
    if [ ! -e ~/Files/ ]; then
        sshfs burpi@192.168.129.12:/mnt/MyStuff/ /mnt/mount1/ -p 37093 -o follow_symlinks,reconnect,default_permissions,uid=1000,gid=1001,workaround=rename;
    fi
}

function serberMnt1(){
    if ! [ -d /mnt/mount2 ]; then
        mkdir /mnt/mount2; 
    fi;
    if [ ! -d ~/Files/ ]; then
        lnSoft /mnt/mount2 ~/burpi;
    fi
    if [ ! -e ~/Files/ ]; then
        sshfs burpi@192.168.129.12:/home/burpi /mnt/mount2/ -p 37093 -o follow_symlinks,reconnect,default_permissions,uid=1000,gid=1001,workaround=rename;
    fi
}

serberMnt
serberMnt1

function vlcFolder(){
    if [ -d $1 ]; then
        vlc --recursive expand "./$1";
    else
        pwd | vlc --recursive expand ;
    fi;
}

#Git stuff
alias gitListedReps="git remote -v"
function gitSshKey() { cd ~/.ssh/ && echo ~/.ssh/$1 | ssh-keygen -t ed25519 -C $1 && eval "$(ssh-agent -s)" && ssh-add ~/.ssh/$1 && cat $1.pub; }
function gitConfig() { git config --global user.email $EMAIL && git config --global user.name $NAME; }
function gitTest() { ssh -vT git@github.com; }
function gitAddRep() { git remote -v add $1 git@github.com:$GITNAME/$1.git; }
function gitStatus() { git status; }
function gitCommitAll() { 
    if [ ! "$1" == 0 ]; then 
        git commit -am "$1"; 
    else
        git commit -a ;
    fi; }
alias gitCommitUsingLast="git commit --amend"
function gitRenameRep() { git remote -v rename $1; }
function gitRemoveRep() { git remote -v rm $1; }

# Docker
alias dockerUpdate="docker-compose down && docker-compose pull && docker-compose up &"
alias piUpdate="cd ~/Applications/docker-pi-hole && dockerUpdate"

alias ds4LOn="ds4drv --led ff0000"
alias ds4LOff="ds4drv --led 000000"
alias ds4="python3 -m ds4drv --hidraw --udp --udp-port 26760"

alias udevReload="sudo udevadm control --reload-rules && sudo udevadm trigger"

#Devolo PLC Stuff

alias wick="sudo wickrme --no-sandbox"

#alias checkSongs='serber "cd /mnt/MyStuff/Files/Audio/ && ls -la | xargs -0"'
#alias checkYoutubes='serber "cd /mnt/MyStuff/Files/Videos/YouTubes/ && ls -la "'

function youtube_playList(){
    if [ ! -z $1 ]; then    #&& [[ $1 =~ 'https://www.youtub' ]]
                            #if [ ! -z $2 ]; then
        youtube-dl -c --write-sub --yes-playlist $1
    fi
}

newSong() {
    serber "cd /mnt/MyStuff/Files/Audio/ && mkdir -p $1 && cd $1/ && youtube-dl -x --audio-format mp3 $2"
}

oldSong() {
    serber "cd /mnt/MyStuff/Files/Audio/$1/ && youtube-dl -c -x --audio-format mp3 $2"
}

yt_vid() {
    serber "cd /mnt/MyStuff/Files/Videos/YouTubes/ && youtube-dl -c --write-sub $1"
}

yt_vid_newDir() {
    serber "cd /mnt/MyStuff/Files/Videos/YouTubes/ && mkdir -p $1 && cd $1 && youtube-dl --write-sub $2"
}

yt_vid_oldDir() {
    serber "cd /mnt/MyStuff/Files/Videos/YouTubes/$1/ && youtube-dl -c --write-sub $2"
}

#alias vmOn="sudo virsh net-autostart default && sudo virsh net-start default && sudo mv /etc/modprobe.d/vfio.conf.orig /etc/modprobe.d/vfio.conf && sudo mkinitcpio -p linux515 && reboot"
#alias vmOff="sudo virsh net-destroy default && sudo mv /etc/modprobe.d/vfio.conf /etc/modprobe.d/vfio.conf.orig && sudo mkinitcpio -p linux515 && reboot"
