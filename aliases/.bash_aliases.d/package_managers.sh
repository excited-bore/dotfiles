### APT ###

if type apt &> /dev/null; then
    alias apt-full-upgrade="sudo apt update && sudo apt full-upgrade && sudo apt autoremove"
fi

### PACMAN ###

if type pacman &> /dev/null; then
    alias pacman-update="sudo pacman -Su"
    alias pacman-refresh-update="sudo pacman -Syu"
    alias pacman-forcerefresh-update="sudo pacman -Syyu"
    # pacman-mirrors -f:
    #      -f, --fasttrack [NUMBER]
    #          Generates a random mirrorlist for the users current selected branch, mirrors are randomly selected from the users current mirror pool, either a custom pool or the default pool, the randomly selected
    #          mirrors are ranked by their current access time.  The higher number the higher possibility of a fast mirror.  If a number is given the resulting mirrorlist contains that number of servers.
    alias pacman-create-default-mirrors-and-forcerefresh="sudo pacman-mirrors -f 5 && sudo pacman -Syy"
    alias pacman-create-default-mirrors-and-refresh="sudo pacman-mirrors -f 5 && sudo pacman -Sy"
    alias pacman-rm-lock="sudo rm /var/lib/pacman/db.lck"
    alias pacman-list-AUR-installed="pacman -Qm"
fi

### PAMAC ###

# For manjaro: consider pacui
# https://forum.manjaro.org/t/pacui-bash-script-providing-advanced-pacman-and-yay-pikaur-aurman-pakku-trizen-pacaur-pamac-cli-functionality-in-a-simple-ui/561
#(don't run pamac with sudo)

if type pamac &> /dev/null; then
    alias pamac-update="pamac update"
    alias pamac-update-yes="yes | pamac update"
    alias pamac-upgrade="pamac upgrade"
    alias pamac-upgrade-yes="yes | pamac upgrade"
    alias pamac-search-aur="pamac search --aur"
    alias pamac-forcerefresh="pamac update --force-refresh && pamac upgrade --force-refresh"
    alias pamac-clean="pamac clean"
    alias pamac-checkupdates="checkupdates -a"
    alias manjaro-update-packages="pamac-update"
    alias manjaro-upgrade="pamac upgrade"
fi

### NPM ###

if type npm &> /dev/null; then
    alias npm-update="npm update"
fi

### PIP ###

if type pip &> /dev/null; then
    alias pip-upgrade="python3 -m pip install --upgrade pip"
fi
