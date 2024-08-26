
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

if test $machine == 'Windows'; then
    if test $win_bash_shell == 'Cygwin'; then
        cyg_bashr=~/.bashrc 
        cyg_home=~/ 
    elif test $win_bash_shell == 'Git'; then
        USER="$(basename $(cd ~ && pwd))"
        cyg_bash="/c/cygwin$ARCH_WIN/home/.bashrc" 
        cyg_home="/c/cygwin$ARCH_WIN/home/"
    fi
    
    # Install Cygwin
    if ! type winget &> /dev/null; then
        pwsh install_winget.ps1 
    fi
    if ! test $win_bash_shell == 'Cygwin' && ! test -d /c/cygwin$ARCH_WIN; then
        winget install Cygwin.Cygwin
    fi
    
    # Install dos2unix 
    if ! type dos2unix &> /dev/null; then
        printf "${CYAN}Bash scripts won't run in Cygwin without convertion ${green}(using ${magenta}'dos2unix'${green} f.ex.)${normal}\n"
        reade -Q "GREEN" -i "y" -p "Install dos2unix? [Y/n]: " "n" dos2unx
        if test $dos2unx == 'y' ; then 
            winget install dos2unix
        else
            exit 1
        fi 
        unset dos2unx 
    fi

    # Dos2unix preexec hook
    if type dos2unix &> /dev/null && ! grep -q '.bash-preexec.sh' $cyg_bash; then
       printf "${CYAN}Installing preexecuting hook for dos2unix${normal}\n" 
       tmpd=$(mktemp -d) 
       curl.exe https://raw.githubusercontent.com/rcaloras/bash-preexec/master/bash-preexec.sh -P $tmpd 
       mv $tmpd/bash-preexec.sh $cyg_home/.bash_preexec.sh 
       printf "[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh\npreexec() { dos2unix $1; }\n" >> $cyg_bash         
       unset tmpd 
    fi
    if test $win_bash_shell == 'Cygwin'; then
        source ~/.bashrc 
    fi

    # Install apt-cyg 
    if test $win_bash_shell == 'Cygwin' && ! type apt-cyg &> /dev/null || ! test -f /c/cygwin$ARCH_WIN/bin/apt-cyg; then
        printf "${green}Even though cygwin comes preinstalled with a lot of tools, it does not come with a package manager.. ${normal}\n"
        reade -Q 'GREEN' -i 'y' -p 'Install apt-cyg? (Package manager for Cygwin) [Y/n]: ' 'n' apt_cyg
        if test "$apt_cyg" == '' || test "$apt_cyg" == "y" || test "$apt_cyg" == 'Y'; then
            tmpd=$(mktemp -d)
            curl.exe https://raw.githubusercontent.com/transcode-open/apt-cyg/master/apt-cyg > $tmpd/apt-cyg
            if test $win_bash_shell == 'Cygwin'; then
                install $tmpd/apt-cyg /bin
            elif test $win_bash_shell == 'Git'; then
                /c/cygwin$ARCH_WIN/bin/bash.exe "install $tmpd/apt-cyg"
            else
                printf "Dont know how to install using this shell\nFile downloaded at '$tmpd/apt-cyg' and should install using 'C:\cygwin64\bin\bash.exe install $tmpd/apt-cyg'\n"
                exit 1
            fi
        fi 
    fi 

    unset cyg_home cyg_bash 
fi
