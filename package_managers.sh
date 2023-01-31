alias pacman_update="doas pacman -Syu"
#(don't run pamac with sudo)
alias pamac_update="pamac update"
alias apt_full="sudo apt update && sudo apt full-upgrade && sudo apt autoremove"

alias pamac_clean="pamac clean"
alias pamac_checkupdates="checkupdates -a"
alias npm_update="npm update"
#alias python_update="pip update"
alias update_packages="update_pacman && update_pamac"
