if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi

if ! test -f checks/check_pathvar.sh.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_pathvar.sh)" 
else
    . ./checks/check_pathvar.sh
fi


if test $machine == 'Windows' && [[ $(uname -s) == 'MINGW' ]] && ! test -d /c/git-sdk-32; then
    tempd=$(mktemp -d)
    ltstv=$(curl -sL https://api.github.com/repos/git-for-windows/build-extra/releases/latest | jq -r ".tag_name")
    file=$(echo $ltstv | sed "s/git-sdk-\(.*\)/git-sdk-installer-\1-$ARCH_WIN.7z.exe/g")
    wget -P $tempd "https://github.com/git-for-windows/build-extra/releases/$file"
    ./$tempd/$file
fi
