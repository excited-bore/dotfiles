# https://www.docker.com

hash docker &> /dev/null && SYSTEM_UPDATED='TRUE'

TOP=$(git rev-parse --show-toplevel)

if ! test -f $TOP/checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . $TOP/checks/check_all.sh
fi

if ! hash docker &> /dev/null; then
    if [[ $distro_base == "Debian" ]]; then
        eval "$pac_ins_y docker.io"
        eval "$pac_rm_y docker docker-engine" 
        curl https://get.docker.com | sh
        printf "${cyan}Log out and log in again${normal}, execute ${cyan}'groups'${normal} and check if ${cyan}'docker'${normal} in there.\n Else, execute ${GREEN}'sudo usermod -aG docker $USER'${normal}\n"
    elif [[ $distro == "Arch" ]]; then
        eval "$pac_ins_y docker"
        printf "${cyan}Log out and log in again${normal}, execute ${cyan}'groups'${normal} and check if ${cyan}'docker'${normal} in there.\n Else, execute ${GREEN}'sudo usermod -aG docker $USER'${normal}\n"
    fi
fi
