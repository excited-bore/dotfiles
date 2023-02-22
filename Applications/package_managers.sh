
alias pacman_update="sudo pacman -Syu"
alias pacman_mirrors_pacman_refresh="sudo pacman-mirrors -f 5 && sudo pacman -Syyu"
alias pacman_rm_lock="sudo rm /var/lib/pacman/db.lck"
alias apt_full_upgrade="sudo apt update && sudo apt full-upgrade && sudo apt autoremove"
# For manjaro: consider pacui
# https://forum.manjaro.org/t/pacui-bash-script-providing-advanced-pacman-and-yay-pikaur-aurman-pakku-trizen-pacaur-pamac-cli-functionality-in-a-simple-ui/561
#(don't run pamac with sudo)
alias pamac_update="pamac update"
alias pamac_update_yes="yes | pamac update"
alias pamac_upgrade="pamac upgrade"
alias pamac_search_aur="pamac search --aur"
alias pamac_forcerefresh="pamac update --force-refresh && pamac upgrade --force-refresh"
alias pamac_clean="pamac clean"
alias pamac_checkupdates="checkupdates -a"
alias manjaro_update_packages="pamac_update"
alias manjaro_upgrade="pamac upgrade"
alias npm_update="npm update"
alias pip_upgrade="python3 -m pip install --upgrade pip"
