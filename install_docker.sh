 #DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi

if ! type update-system &> /dev/null; then
    if ! test -f aliases/.bash_aliases.d/update-system.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/update-system.sh)" 
    else
        . ./aliases/.bash_aliases.d/update-system.sh
    fi
fi

if test -z $SYSTEM_UPDATED; then
    readyn -Y "CYAN" -p "Update system?" updatesysm
    if test $updatesysm == "y"; then
        update-system                     
    fi
fi

if ! type docker &> /dev/null; then
    if test $distro_base == "Debian"; then
        eval "$pac_ins docker.io"
        sudo apt remove docker docker-engine 
        curl -sSL https://get.docker.com | sh
        printf "${cyan}Log out and log in again${normal}, execute ${cyan}'groups'${normal} and check if ${cyan}'docker'${normal} in there.\n Else, execute ${GREEN}'sudo usermod -aG docker $USER'${normal}\n"
    elif test $distro == "Arch" || test $distro == "Manjaro"; then
        eval "$pac_ins docker"
        printf "${cyan}Log out and log in again${normal}, execute ${cyan}'groups'${normal} and check if ${cyan}'docker'${normal} in there.\n Else, execute ${GREEN}'sudo usermod -aG docker $USER'${normal}\n"
    fi
fi
