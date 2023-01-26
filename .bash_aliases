# global bashrc -> /etc/bash.bashrc
# global shell profiles -> /etc/profile
. .exports
. ~/Applications/doas.sh
. ~/Applications/general.sh
. ~/Applications/systemctl.sh
. ~/Applications/tmux.sh
. ~/Applications/package_managers.sh
. ~/Applications/manjaro.sh
. ~/Applications/ssh.sh
. ~/Applications/git.sh
. ~/Applications/youtube.sh
. ~/Applications/variety.sh

if [ ! -e ~/lib_systemd ]; then
    linkSoft /lib/systemd/system/ ~/lib_systemd
fi

if [ ! -e ~/etc_systemd ]; then
    linkSoft /etc/systemd/system/ ~/etc_systemd
fi

if [ ! -e ~/.vimrc ]; then
    linkSoft .config/nvim/init.vim ~/.vimrc
fi

# Set caps as AltGr
setxkbmap -option "lv3:caps_switch" 
# Set Shift delete to backspace
xmodmap -e "keycode 119 = Delete BackSpace"

## stty settings
# see with 'stty -a'
# unbinds ctrl-c and bind the function to ctrl-x
stty intr '^x'
stty start 'undef' 
stty stop 'undef' 
#stty 'eol' 'home'

# python virtual env
#python3 -m venv python3
#source venv/bin/activate
