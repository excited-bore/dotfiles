export NAME="Stan Nys"
export EMAIL="stan96@duck.com"
export GITNAME="excited-bore"

alias lsall="ls -al"
alias cp="cp -r"
alias rm="rm -r"
alias r=". ~/.bashrc"
alias x="exit"

function addToGroup() {
    if [[ -z $1 ]]; then
        echo "Give a group and a username (default: $USER)"
    elif [[ -z $2 ]]; then
        sudo usermod -aG $1 $USER
    else
        sudo usermod -aG $1 $2
    fi; }

function makeExecutable() {
    if [[ ! -f $1 ]] ; then
        echo "Give a file to make executable"
    else
        sudo chmod +x $1
    fi; }

alias start="sudo systemctl start"
alias stop="sudo systemctl stop"
alias enable="sudo systemctl enable"
alias enableNow="sudo systemctl enable --now"
alias disable="sudo systemctl disable"
alias disableNow="sudo systmctl disable --now"
alias status="sudo systemctl status"

alias journBoot="sudo journalctl -b"
alias journLive="sudo journalctl -f"

#Package Managers (don't run pamac with sudo)
alias up="pamac update"
#alias up="sudo apt update && sudo apt full-upgrade"
alias up2="sudo pacman -Syu"

alias blueUp="sudo systemctl start bluetooth.service && blueman-manager"
alias blueDown="sudo systemctl stop bluetooth.service"

alias bios="sudo systemctl reboot --firmware-setup"

alias vim="nvim"
alias vimCheckhealth="vim +checkhealth"
alias vimPluginInstall="vim +PluginInstall +qall"

#alias tmux='TERM=xterm-256color tmux -2'

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
    
alias tmuxKillServer="tmux kill-server"

function tmuxKillAllButOne(){
    if ! [ -z "$1" ]; then
        tmux kill-session -a -t "$1";
    else
        #Current session
        tmux kill-session -a;
    fi;
}

alias tmuxListKeybinds="tmux list-keys"
#alias tmuxTogglePanesSyncCommands="setw synchronize-panes"

#Server access
alias serber="ssh burpi@192.168.129.12 -p 37093"
function serberMnt() {
    if ! [ -d /mnt/mount1 ]; then
        mkdir /mnt/mount1; 
    fi;
    sshfs burpi@192.168.129.12:/mnt/MyStuff/ /mnt/mount1/ -p 37093;
}
alias serberUmnt="fusermount3 -u /mnt/mount1/"

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
function gitChanges() { git status; }
function gitCommitAll() { 
    if [ ! -z "$1" ]; then 
        git commit -am "$1"; 
    else
        git commit -a ;
    fi; }
alias gitCommitUsingLast="git commit --amend"
function gitRenameRep() { git remote -v rename $1; }
function gitRemoveRep() { git remote -v rm $1; }

alias ds4LOn="ds4drv --led ff0000"
alias ds4LOff="ds4drv --led 000000"
alias ds4="python3 -m ds4drv --hidraw --udp --udp-port 26760"

alias udevReload="sudo udevadm control --reload-rules && sudo udevadm trigger"

#Devolo PLC Stuff
alias devUp="sudo systemctl start devolonetsvc.service && bash /opt/devolo/dlancockpit/bin/dlancockpit-run.sh"
alias devDown="sudo systemctl stop devolonetsvc.service"

alias wick="sudo wickrme --no-sandbox"

#alias bigNerd="serber | cd /mnt/MyStuff/Files/Videos/YouTubes/"
#alias checkSongs='serber "cd /mnt/MyStuff/Files/Audio/ && ls -la | xargs -0"'
#alias checkYoutubes='serber "cd /mnt/MyStuff/Files/Videos/YouTubes/ && ls -la "'

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
