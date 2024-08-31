if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . checks/check_system.sh
fi

if ! test -f checks/check_envvar.sh.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_envvar.sh)" 
else
    . checks/check_envvar.sh
fi


if test $machine == 'Windows' && [[ $(uname -s) == 'MINGW' ]] && ! test -d /c/git-sdk-32; then
    tempd=$(mktemp -d)
    ltstv=$(curl -sL https://api.github.com/repos/git-for-windows/build-extra/releases/latest | jq -r ".tag_name")
    file=$(echo $ltstv | sed "s/git-sdk-\(.*\)/git-sdk-installer-\1-$ARCH_WIN.7z.exe/g")
    wget -P $tempd "https://github.com/git-for-windows/build-extra/releases/download/$ltstv/$file"
    eval $tempd/$file
    printf "${GREEN}Done! ${normal} Don't forget ${cyan}right-click${normal} the terminal window, then ${MAGENTA}Options->Keys${magenta}(left bar)${normal} and check ${CYAN}'Ctrl+Shift+letter shortcuts'${normal} for ${GREEN}Ctrl+Shift+C for Copy and Ctrl+Shift+V for paste (after selecting with mouse)${normal} instead of ${YELLOW}Shift+Insert/Ctrl+Insert for Copy/Paste${normal}\n" 

fi
