if [[ $distro == "Manjaro" || $distro == "Arch" ]]; then
    alias kitty_remote_fix="sudo pacman -S kitty-terminfo"
elif [ $distro_base == "Debian" ]; then
    alias kitty_remote_fix="sudo apt install kitty-terminfo"
fi

#alias kserber="kitty +kitten ssh -i $ssh_file funnyman@192.168.129.17"
alias kitty_remote_fix_alt="infocmp -a xterm-kitty | ssh funnyman@192.168.129.17 tic -x -o \~/.terminfo /dev/stdin"
# These were all different ways to solve the same problem: fix kitty over ssh
# Installing kitty-terminfo on remote is the most sensible way to fix it
