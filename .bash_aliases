$name="Stan Nys"
$email="stan96@duck.com"


#Devolo PLC Stuff
alias devUp="sudo systemctl start devolonetsvc.service && bash /opt/devolo/dlancockpit/bin/dlancockpit-run.sh"
alias devDown="sudo systemctl stop devolonetsvc.service"

alias journBoot="sudo journalctl -b"
alias journLive="sudo journalctl -f"
alias udevReload="sudo udevadm control --reload-rules && sudo udevadm trigger"
alias wick="sudo wickrme --no-sandbox"

#Package Managers (don't run pamac with sudo)
alias pac="sudo pacman -Syu"
alias pam="pamac update"

alias blueUp="sudo systemctl start bluetooth.service && blueman-manager"
alias blueDown="sudo systemctl stop bluetooth.service"

alias status="sudo systemctl status"
alias serber="ssh burpi@192.168.129.12 -p 37093"
alias bigNerd="serber | cd /mnt/MyStuff/Files/Videos/YouTubes/"
alias bios="sudo systemctl reboot --firmware-setup"
alias ds4LOn="ds4drv --led ff0000"
alias ds4LOff="ds4drv --led 000000"

alias vim="nvim"
alias ds4="python3 -m ds4drv --hidraw --udp --udp-port 26760"
alias checkSongs='serber "cd /mnt/MyStuff/Files/Audio/ && ls -la | xargs -0"'
alias checkYoutubes='serber "cd /mnt/MyStuff/Files/Videos/YouTubes/ && ls -la "'

alias x="exit"

#Git stuff
alias gitListedReps="git remote -v"
function gitSshKey() { cd ~/.ssh/ && ssh-keygen -t ed25519 -C "$2" && eval "$(ssh-agent -s)" && ssh-add ~/.ssh/$1; }
function gitConfig() { git config --global user.email "$email" && git config --global user.name "$name"; }
function gitAddRep() { git remote -v add $1 git@github.com:/excited-bore/$1.git; }
function gitRenameRep() { git remote -v rename $1; }
function gitRemoveRep() { git remote -v rm $1; }

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
