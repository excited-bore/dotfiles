DLSCRIPT=1

if ! test -f checks/check_all.sh; then
    if type curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        printf "If not downloading/git cloning the scriptfolder, you should at least install 'curl' beforehand when expecting any sort of succesfull result...\n"
        return 1 || exit 1
    fi
else
    . ./checks/check_all.sh
fi



if [[ $machine == 'Windows' ]] && [[ $(uname -s) == 'MINGW' ]] && ! test -d /c/git-sdk-32; then
    tempd=$(mktemp -d)
    ltstv=$(curl -sL https://api.github.com/repos/git-for-windows/build-extra/releases/latest | jq -r ".tag_name")
    file=$(echo $ltstv | sed "s/git-sdk-\(.*\)/git-sdk-installer-\1-$ARCH_WIN.7z.exe/g")
    wget-aria-dir $tempd "https://github.com/git-for-windows/build-extra/releases/download/$ltstv/$file"
    eval $tempd/$file
    printf "${GREEN}Done! ${normal} Don't forget ${cyan}right-click${normal} the terminal window, then ${MAGENTA}Options->Keys${magenta}(left bar)${normal} and check ${CYAN}'Ctrl+Shift+letter shortcuts'${normal} for ${GREEN}Ctrl+Shift+C for Copy and Ctrl+Shift+V for paste (after selecting with mouse)${normal} instead of ${YELLOW}Shift+Insert/Ctrl+Insert for Copy/Paste${normal}\n" 

fi
