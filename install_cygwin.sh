#!/bin/bash

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

if ! test -f aliases/.bash_aliases.d/00-rlwrap_scripts.sh; then
    eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/00-rlwrap_scripts.sh)" 
else
    . ./aliases/.bash_aliases.d/00-rlwrap_scripts.sh
fi

if test $machine == 'Windows' && ! type cygpath.exe &> /dev/null; then
    winget install Cygwin.Cygwin
fi

if test $win_bash_shell == 'Cygwin' && ! type apt-cyg &> /dev/null || test $win_bash_shell == 'Git' && ! echo $PATH | grep -q '/c/cygwin64/bin'; then
    printf "${green}Even though cygwin comes preinstalled with a lot of tools, it does not come with a package manager.. ${normal}\n"
    read -p 'Install apt-cyg? (Package manager for Cygwin) [Y/n]: ' apt_cyg
    if test "$apt_cyg" == '' || test "$apt_cyg" == "y" || test "$apt_cyg" == 'Y'; then
        tmpd=$(mktemp -d)
        curl.exe https://raw.githubusercontent.com/transcode-open/apt-cyg/master/apt-cyg > $tmpd/apt-cyg
        install $tmpd/apt-cyg /bin
        #if test $win_bash_shell == 'Cygwin'; then
        #else
            #sudo mv $tmpd/apt-cyg /c/cygwin64/bin
        #fi
        #echo '! [[ $(uname -s) =~ "CYGWIN" ]] && export PATH=$PATH:/c/cygwin64/bin' | cat - ~/.bashrc > $tmpf && mv $tmpf ~/.bashrc && rm $tmpf && rm -r $tmpd
    fi
fi
