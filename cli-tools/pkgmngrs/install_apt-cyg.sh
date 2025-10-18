SYSTEM_UPDATED='TRUE'

if ! [[ -f ../../checks/check_all.sh ]]; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ../../checks/check_all.sh
fi


# Install apt-cyg 
if [[ $win_bash_shell == 'Cygwin' ]] && ! hash apt-cyg &> /dev/null; then
    printf "${green}Even though cygwin comes preinstalled with a lot of tools, it does not come with a package manager.. ${normal}\n"
    readyn -p 'Install apt-cyg? (Package manager for Cygwin)' apt_cyg
    if [[ "$apt_cyg" == "y" ]]; then
        tmpd=$(mktemp -d) 
        curl.exe https://raw.githubusercontent.com/transcode-open/apt-cyg/master/apt-cyg > $tmpd/apt-cyg
        install $tmpd/apt-cyg /bin
    fi 
fi 
unset apt_cyg
