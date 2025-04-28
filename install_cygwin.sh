if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi

if ! test -f checks/check_envvar.sh.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_envvar.sh)" 
else
    . ./checks/check_envvar.sh
fi

if ! type reade &> /dev/null; then
    eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/00-rlwrap_scripts.sh)" 
else
    . ./aliases/.bash_aliases.d/00-rlwrap_scripts.sh
fi


if test $machine == 'Windows'; then
    alias wget='wget.exe' 
    alias curl='curl.exe' 
    if test $win_bash_shell == 'Cygwin'; then
        cyg_bashr=~/.bashrc 
        cyg_home=~/ 
    elif test $win_bash_shell == 'Git'; then
        USER="$(basename $(cd ~ && pwd))"
        cyg_bash="/c/cygwin$ARCH_WIN/home/$USER/.bashrc" 
        cyg_home="/c/cygwin$ARCH_WIN/home/$USER/"
    fi
    
    # Install Cygwin
    if ! type winget &> /dev/null; then
        tmpd=$(mktemp -d)
        wget -P $tmpd https://raw.githubusercontent.com/asheroto/winget-install/master/winget-install.ps1  
        sudo pwsh $tmpd/winget-install.ps1
    fi
    if ! test $win_bash_shell == 'Cygwin' && ! test -d /c/cygwin$ARCH_WIN; then
        winget install Cygwin.Cygwin
        #/c/cygwin$ARCH_WIN/bin/mintty.exe -i /c/cygwin$ARCH_WIN/Cygwin-Terminal.ico - 
    fi
    
    # Install dos2unix 
    if ! type dos2unix &> /dev/null; then
        printf "${CYAN}Bash scripts won't run in Cygwin without convertion from dos${green}(using ${magenta}'dos2unix'${green} f.ex.)${normal}\n"
        readyn -p "Install dos2unix?" dos2unx
        if test $dos2unx == 'y' ; then 
            winget install dos2unix
        #else
            #exit 1
        fi 
        unset dos2unx 
    fi
    
    printf "${GREEN}Done! ${normal} Don't forget ${cyan}right-click${normal} the terminal window, then ${MAGENTA}Options->Keys${magenta}(left bar)${normal} and check ${CYAN}'Ctrl+Shift+letter shortcuts'${normal} for ${GREEN}Ctrl+Shift+C for Copy and Ctrl+Shift+V for paste (after selecting with mouse)${normal} instead of ${YELLOW}Shift+Insert/Ctrl+Insert for Copy/Paste${normal}\n" 
     
    if test -d /c/cygwin$ARCH_WIN && ! test -d $cyg_home; then
        printf "${RED}Test run Cygwin terminal first before running 'install_cygwin.sh' again (still need to install dos2unix and apt-cyg)${normal}\nThe script checks if something what it already has been installed and what not so you won't have to reconfigure.\n" 
        #exit 1
    fi

    # Dos2unix preexec hook
    # 'Sort of' works, not the most elegant solution
    #
    #if type dos2unix &> /dev/null && ! test -f $cyg_home/.bash-preexec.sh && ! grep -q '~/.bash-preexec.sh' $cyg_bash; then
    #   printf "${CYAN}Installing preexecuting hook for dos2unix${normal}\n" 
    #   wget https://raw.githubusercontent.com/rcaloras/bash-preexec/master/bash-preexec.sh -P $cyg_home 
    #   mv $cyg_home/bash-preexec.sh $cyg_home/.bash-preexec.sh 
    #   prmpt="[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh
    #   preexec() {
    #    if [[ \"\$1\" =~ './' ]] && [[ \"\$1\" =~ '.sh' ]]; then
    #            if grep -q './' \"\$(realpath \$(basename \$1))\"; then
    #                    dos2unix < \$1 | sed 's/.*\.\/\(.*\)/dos2unix \1 \&\& \.\/\1/g' | sed 's/.*\.\ \(.*\)/dos2unix \1 \&\& . \1/g' | /bin/bash;
    #            else
    #                    dos2unix < \$1 | /bin/bash
    #            fi
    #        fi
    #   }\n"
    #   printf "$prmpt" >> $cyg_bash  
    #   #printf "[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh\npreexec() { test -f \$1 && dos2unix \$1; }\n" >> $cyg_bash         
    #fi

    if test $win_bash_shell == 'Cygwin'; then
        source ~/.bashrc 
    fi

    # Install apt-cyg 
    if ! type apt-cyg &> /dev/null || test $win_bash_shell == 'Git' && ! test -f /c/cygwin$ARCH_WIN/bin/apt-cyg; then
        printf "${green}Even though cygwin comes preinstalled with a lot of tools, it does not come with a package manager.. ${normal}\n"
        readyn -p 'Install apt-cyg? (Package manager for Cygwin)' apt_cyg
        if test "$apt_cyg" == '' || test "$apt_cyg" == "y" || test "$apt_cyg" == 'Y'; then
            tmpd=$(mktemp -d) 
            curl.exe https://raw.githubusercontent.com/transcode-open/apt-cyg/master/apt-cyg > $tmpd/apt-cyg
            if test $win_bash_shell == 'Cygwin'; then
                install $tmpd/apt-cyg /bin
            elif test $win_bash_shell == 'Git'; then
                #/c/cygwin$ARCH_WIN/bin/bash.exe "install $tmpd/apt-cyg /bin"
                cp -v $tmp/apt-cyg $cyg_home 
                printf "Open up Cygwin terminal and type 'install apt-cyg /bin' to finish installing apt-cyg\n"
            else
                printf "Dont know how to install using this shell\nFile downloaded at '$tmpd/apt-cyg' and should install using 'C:\cygwin64\bin\bash.exe install $tmpd/apt-cyg'\n"
            fi
        fi 
    fi 
    unset cyg_home cyg_bash 
fi
