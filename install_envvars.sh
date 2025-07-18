#!/usr/bin/env bash

SYSTEM_UPDATED="TRUE"

if ! test -f checks/check_all.sh; then
    if ! hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        printf "If not downloading/git cloning the scriptfolder, you should at least install 'curl' beforehand when expecting any sort of succesfull result...\n"
        return 1 || exit 1
    fi
else
    . ./checks/check_all.sh
fi

# Environment variables

environment-variables_r() {
    sudo cp $pathvr /root/.environment
    if ! sudo test -f /root/.profile; then
        sudo touch /root/.profile
    fi
    shell_profiles="${MAGENTA}\t- /root/.profile\n"
    shell_rcs=""
    if sudo test -f /root/.bash_profile; then
        shell_profiles="$shell_profiles${CYAN}\t- /root/.bash_profile\n"
    fi
    if sudo test -f /root/.zsh_profile; then
        shell_profiles="$shell_profiles${CYAN}\t- /root/.zsh_profile\n"
    fi
    if sudo test -f /root/.bashrc; then
        shell_rcs="$shell_rcs${GREEN}\t- /root/.bashrc\n"
    fi
    if sudo test -f /root/.zshrc; then
        shell_rcs="$shell_rcs${GREEN}\t- /root/.zshrc\n"
    fi
    prmpt="File(s):\n$shell_profiles${normal}${GREEN}should${normal} get sourced at login...\nHowever, if a ${CYAN}*shell*_profile${normal} (f.ex. .bash_profile) file exists, ${MAGENTA}.profile${RED} won't get sourced at login${normal}\nFile(s):\n${CYAN}$shell_rcs${normal}get sourced when starting a new *interactive* shell (f.ex. ${CYAN}bash${normal} shell)\n"
#Certain programs check the correct ${CYAN}*shell*_profile${normal}, others (by accident) only check ${MAGENTA}.profile${normal}..\n"
    printf "$prmpt"

    if ! sudo grep -q "/root/.environment" /root/.profile; then
        readyn -p "Link .environment in ${YELLOW}/root/.profile${GREEN}?" prof
        if [[ $prof == 'y' ]]; then
            printf "\n[ -f /root/.environment ] && source /root/.environment\n\n" | sudo tee -a /root/.profile 1> /dev/null
        fi
    fi
    if test -f /root/.bash_profile || test -f /root/.zsh_profile; then
        printf "\n${GREEN}Since a ${cyan}$HOME/.*shell*_profile${green} file exists, the shell in question won't source ${magenta}$HOME/.profile${green} natively at login.\n${normal}"
         
        if test -f /root/.bash_profile && ! sudo grep -q "/root/.environment" /root/.bash_profile; then
            printf "${GREEN}Just source ${YELLOW}/root/.environment${normal} in ${YELLOW}/root/.bash_profile\n${normal}"
            reade -Q GREEN -i 'source delete' -p "Or copy everything from ${YELLOW}/root/.bash_profile${GREEN} into ${YELLOW}/root/.profile${GREEN} and also delete ${YELLOW}/root/.bash_profile${GREEN}? [Source/delete]: " bprof_r 

            if [[ $bprof_r == 'source' ]]; then
                if ! sudo grep -q "/root/.environment" /root/.bash_profile; then 
                    printf "\n[ -f /root/.environment ] && source /root/.environment\n\n" | sudo tee -a /root/.bash_profile 1> /dev/null
                fi 
            elif [[ $bprof_r == 'delete' ]]; then 
                sudo cat /root/.bash_profile | sudo tee -a /root/.profile
                readyn -p 'Check ~/.profile? (will remove /root/.bash_profile afterwards)' eprof
                if [[ $eprofr == 'y' ]]; then
                    sudo less /root/.profile 
                fi
                sudo rm /root/.bash_profile
            fi
        fi
        
        if test -f /root/.zsh_profile && ! sudo grep -q "/root/.environment" /root/.zsh_profile; then
            printf "${GREEN}Just source $HOME/.environment in $HOME/.zsh_profile\n${normal}" 
            reade -Q "GREEN" -i 'source delete' -p "Or copy everything from $HOME/.zsh_profile into $HOME/.profile and also delete $HOME/.zsh_profile? [Source/delete]: " zprof_r

            if [[ $zprof_r == 'source' ]]; then
                if ! sudo grep -q "/root/.environment" /root/.zsh_profile; then 
                    printf "\n[ -f /root/.environment ] && source /root/.environment\n\n" | sudo tee -a /root/.zsh_profile 1> /dev/null
                fi 
            elif [[ $zprof_r == 'delete' ]]; then 
                sudo cat /root/.zsh_profile | sudo tee -a /root/.profile
                sudo rm /root/.zsh_profile
            fi
        fi
    fi

    # This always breaks !  

    #if test -f /root/.bash_profile && ! sudo grep -q "/root/.bash_profile" /root/.profile; then
    #    readyn -n -p "Link /root/.bash_profile in /root/.profile?" bprofr
    #    if [[ "$bprofr" == 'y' ]]; then
    #        printf "\n[ -f /root/.bash_profile ] && source /root/.bash_profile\n\n" | sudo tee -a /root/.profile 1> /dev/null
    #    fi
    #    unset bprofr
    #fi
    #if test -f /root/.zsh_profile && ! grep -q "/root/.zsh_profile" ~/.profile; then
    #    readyn -p "Link /root/.zsh_profile in /root/.profile?" zprofr
    #    if [[ "$zprofr" == 'y' ]]; then
    #        printf "\n[ -f /root/.zsh_profile ] && source /root/.zsh_profile\n\n" | sudo tee -a /root/.profile 1> /dev/null
    #    fi
    #    unset zprofr
    #fi
    
    if sudo test -f /root/.bashrc && ! sudo grep -q "~/.environment" /root/.bashrc; then
        readyn -Y 'GREEN' -p "Source /root/.environment in /root/.bashrc?" bashrc
        if [[ $bashrc == 'y' ]]; then
            if sudo grep -q "[ -f ~/.bash_completion ]" /root/.bashrc; then
                sudo sed -i 's|\(\[ -f ~/.bash_completion \] \&\& source \~/.bash_completion\)|\[ -f \~/.environment \] \&\& source \~/.environment\n\n\1\n|g' /root/.bashrc
            elif sudo grep -q "[ -f ~/.bash_aliases ]" /root/.bashrc; then
                sudo sed -i 's|\(\[ -f ~/.bash_aliases \] \&\& source \~/.bash_aliases\)|\[ -f \~/.environment \] \&\& source \~/.environment\n\n\1\n|g' /root/.bashrc
                sudo sed -i 's|\(if \[ -f ~/.bash_aliases \]; then\)|\[ -f \~/.environment \] \&\& source \~/.environment\n\n\1\n|g' /root/.bashrc
            elif sudo grep -q "[ -f ~/.keybinds ]" /root/.bashrc; then
                sudo sed -i 's|\(\[ -f ~/.keybinds \] \&\& source \~/.keybinds\)|\[ -f \~/.environment \] \&\& source \~/.environment\n\n\1\n|g' /root/.bashrc
            else
                printf "\n[ -f ~/.environment ] && source ~/.environment\n\n" | sudo tee -a /root/.bashrc 1> /dev/null
            fi
        fi
    fi
    if sudo test -f /root/.zshrc && ! sudo grep -q "/root/.environment" /root/.zshrc; then
        readyn -p "Source /root/.environment in /root/.zhrc?" zshrc
        if [[ $zshrc == 'y' ]]; then
            #if grep -q "[ -f ~/.bash_completion ]" ~/.bashrc; then
            #    sed -i 's|\(\[ -f ~/.bash_completion \] \&\& source \~/.bash_completion\)|\[ -f \~/.environment \] \&\& source \~/.environment\n\n\1\n|g' ~/.bashrc
            #elif grep -q "[ -f ~/.bash_aliases ]" ~/.bashrc || grep -q "~/.bash_aliases" ~/.bashrc; then
            #    sed -i 's|\(\[ -f ~/.bash_aliases \] \&\& source \~/.bash_aliases\)|\[ -f \~/.environment \] \&\& source \~/.environment\n\n\1\n|g' ~/.bashrc
            #    sed -i 's|\(if \[ -f ~/.bash_aliases \]; then\)|\[ -f \~/.environment \] \&\& source \~/.environment\n\n\1\n|g' ~/.bashrc
            #elif grep -q "[ -f ~/.keybinds ]" ~/.bashrc; then
            #    sed -i 's|\(\[ -f ~/.keybinds \] \&\& source \~/.keybinds\)|\[ -f \~/.environment \] \&\& source \~/.environment\n\n\1\n|g' ~/.bashrc
            #else
            printf "\n[ -f /root/.environment ] && source /root/.environment\n\n" | sudo tee -a /root/.zshrc 1> /dev/null
            #fi
        fi
        unset bash_prof_ex prmpt shell_profiles shell_rcs prof bashrc
    fi 
    unset bash_prof_ex prmpt shell_profiles shell_rcs prof bashrc
}

environment-variables() {
    cp $pathvr ~/.environment
    if ! test -f ~/.profile; then
        touch ~/.profile
    fi
    shell_profiles="${MAGENTA}\t- $HOME/.profile\n"
    shell_rcs=""
    if sudo test -f ~/.bash_profile; then
        shell_profiles="$shell_profiles${CYAN}\t- $HOME/.bash_profile\n"
    fi
    if sudo test -f ~/.zsh_profile; then
        shell_profiles="$shell_profiles${CYAN}\t- $HOME/.zsh_profile\n"
    fi
    if sudo test -f ~/.bashrc; then
        shell_rcs="$shell_rcs${GREEN}\t- $HOME/.bashrc\n"
    fi
    if sudo test -f ~/.zshrc; then
        shell_rcs="$shell_rcs${GREEN}\t- $HOME/.zshrc\n"
    fi
    prmpt="File(s):\n$shell_profiles${normal}${GREEN}should${normal} get sourced at login...\nHowever, if a ${CYAN}*shell*_profile${normal} (f.ex. .bash_profile) file exists, ${MAGENTA}.profile${RED} won't get sourced at login${normal}\nFile(s):\n${CYAN}$shell_rcs${normal}get sourced when starting a new *interactive* shell (f.ex. ${CYAN}bash${normal} shell)\n"
#Certain programs check the correct ${CYAN}*shell*_profile${normal}, others (by accident) only check ${MAGENTA}.profile${normal}..\n"
    printf "$prmpt"

    if ! grep -q "~/.environment" ~/.profile; then
        readyn -p "Link .environment in ~/.profile?" prof
        if [[ $prof == 'y' ]]; then
            printf "\n[ -f ~/.environment ] && source ~/.environment\n\n" >>~/.profile
        fi
        unset prof
    fi
    if test -f ~/.bash_profile || test -f ~/.zsh_profile; then
        printf "\n${GREEN}Since a ${cyan}$HOME/.*shell*_profile${green} file exists, the shell in question won't source ${magenta}$HOME/.profile${green} natively at login.\n${normal}"
         
        if test -f ~/.bash_profile && ! grep -q "~/.environment" ~/.bash_profile; then
            printf "${GREEN}Just source $HOME/.environment in $HOME/.bash_profile\n${normal}"
            reade -Q GREEN -i 'source delete' -p "Or copy everything from $HOME/.bash_profile into $HOME/.profile and also delete $HOME/.bash_profile? [Source/delete]: " bprof 

            if [[ $bprof == 'source' ]]; then
                if ! grep -q "~/.environment" ~/.bash_profile; then 
                    printf "\n[ -f ~/.environment ] && source ~/.environment\n\n" >>~/.bash_profile
                fi 
            elif [[ $bprof == 'delete' ]]; then 
                cat ~/.bash_profile | tee -a ~/.profile
                readyn -p 'Check ~/.profile? (will remove ~/.bash_profile afterwards)' eprof
                if [[ $eprof == 'y' ]]; then
                    less ~/.profile 
                fi
                rm ~/.bash_profile
            fi
        fi
        
        if test -f ~/.zsh_profile && ! grep -q "~/.environment" ~/.zsh_profile; then
            printf "${GREEN}Just source $HOME/.environment in $HOME/.zsh_profile\n${normal}"
            reade -Q GREEN -i 'source delete' -p "Or copy everything from $HOME/.zsh_profile into $HOME/.profile and also delete $HOME/.zsh_profile? [Source/delete]: " zprof 

            if [[ $zprof == 'source' ]]; then
                if ! grep -q "~/.environment" ~/.zsh_profile; then 
                    printf "\n[ -f ~/.environment ] && source ~/.environment\n\n" >>~/.zsh_profile
                fi 
            elif [[ $zprof == 'delete' ]]; then 
                cat ~/.zsh_profile | tee -a ~/.profile
                rm ~/.zsh_profile
            fi
        fi
         
    fi

    # This always breaks !  
    
    #if test -f ~/.bash_profile && ! grep -q "~/.bash_profile" ~/.profile; then
    #    readyn -n -p "Link ~/.bash_profile in ~/.profile?" bprof
    #    if [[ "$bprof" == 'y' ]]; then
    #        printf "\n[ -f ~/.bash_profile ] && source ~/.bash_profile\n\n" >>~/.profile 
    #    fi
    #    unset bprof
    #fi
    #if test -f ~/.zsh_profile && ! grep -q "~/.zsh_profile" ~/.profile; then
    #    readyn -p "Link ~/.zsh_profile in ~/.profile?" zprof
    #    if [[ "$zprof" == 'y' ]]; then
    #        printf "\n[ -f ~/.zsh_profile ] && source ~/.zsh_profile\n\n" >>~/.profile
    #    fi
    #    unset bprof
    #fi
        
    if test -f ~/.bashrc && ! grep -q "~/.environment" ~/.bashrc; then
        readyn -p "Source $HOME/.environment in $HOME/.bashrc?" bashrc
        if [[ $bashrc == 'y' ]]; then
            if grep -q "[ -f ~/.bash_completion ]" ~/.bashrc; then
                sed -i 's|\(\[ -f ~/.bash_completion \] \&\& source \~/.bash_completion\)|\[ -f \~/.environment \] \&\& source \~/.environment\n\n\1\n|g' ~/.bashrc
            elif grep -q "[ -f ~/.bash_aliases ]" ~/.bashrc || grep -q "~/.bash_aliases" ~/.bashrc; then
                sed -i 's|\(\[ -f ~/.bash_aliases \] \&\& source \~/.bash_aliases\)|\[ -f \~/.environment \] \&\& source \~/.environment\n\n\1\n|g' ~/.bashrc
                sed -i 's|\(if \[ -f ~/.bash_aliases \]; then\)|\[ -f \~/.environment \] \&\& source \~/.environment\n\n\1\n|g' ~/.bashrc
            elif grep -q "[ -f ~/.keybinds ]" ~/.bashrc; then
                sed -i 's|\(\[ -f ~/.keybinds \] \&\& source \~/.keybinds\)|\[ -f \~/.environment \] \&\& source \~/.environment\n\n\1\n|g' ~/.bashrc
            else
                printf "\n[ -f ~/.environment ] && source ~/.environment\n\n" >>~/.bashrc
            fi
        fi
        unset bash_prof_ex prmpt shell_profiles shell_rcs prof bashrc
    fi

    if test -f ~/.zshrc && ! grep -q "~/.environment" ~/.zshrc; then
        readyn -p "Source $HOME/.environment in $HOME/.zshrc?" zshrc
        if [[ $zshrc == 'y' ]]; then
            #if grep -q "[ -f ~/.bash_completion ]" ~/.bashrc; then
            #    sed -i 's|\(\[ -f ~/.bash_completion \] \&\& source \~/.bash_completion\)|\[ -f \~/.environment \] \&\& source \~/.environment\n\n\1\n|g' ~/.bashrc
            #elif grep -q "[ -f ~/.bash_aliases ]" ~/.bashrc || grep -q "~/.bash_aliases" ~/.bashrc; then
            #    sed -i 's|\(\[ -f ~/.bash_aliases \] \&\& source \~/.bash_aliases\)|\[ -f \~/.environment \] \&\& source \~/.environment\n\n\1\n|g' ~/.bashrc
            #    sed -i 's|\(if \[ -f ~/.bash_aliases \]; then\)|\[ -f \~/.environment \] \&\& source \~/.environment\n\n\1\n|g' ~/.bashrc
            #elif grep -q "[ -f ~/.keybinds ]" ~/.bashrc; then
            #    sed -i 's|\(\[ -f ~/.keybinds \] \&\& source \~/.keybinds\)|\[ -f \~/.environment \] \&\& source \~/.environment\n\n\1\n|g' ~/.bashrc
            #else
            printf "\n[ -f ~/.environment ] && source ~/.environment\n\n" >>~/.zshrc
            #fi
        fi
        unset bash_prof_ex prmpt shell_profiles shell_rcs prof bashrc
    fi 

    #if ! grep -q '.environment' /root/.bashrc && ! grep -q '.environment' $PROFILE_R; then
    yes-edit-no -f environment-variables_r -g "$pathvr" -p "Install .environment in /root/?" -e -Q "YELLOW"
    #fi
}

pathvr=$(pwd)/envvars/.environment
if ! test -f $pathvr; then
    tmp=$(mktemp) && curl -o $tmp https://raw.githubusercontent.com/excited-bore/dotfiles/main/envvars/.environment
    pathvr=$tmp
fi

pre='y'
othr='n'
color='GREEN'
prmpt='[Y/n]: '

#echo "Next $(tput setaf 1)sudo$(tput sgr0) check for /root/.environment' "
#if test -f ~/.environment && sudo test -f /root/.environment; then
#    pre='n'
#    othr='y'
#    color='YELLOW'
#    prmpt='[N/y]: '
#fi

reade -Q "$color" -i "$pre $othr" -p "Check existence/Create '.environment' and link it to '.bashrc' in $HOME/ and /root/? $prmpt" envvars

if [[ "$envvars" == "y" ]] && [[ "$1" == 'n' ]]; then

    #Comment out every export in .environment
    sed -i -e '/export/ s/^#*/#/' $pathvr

    # Allow if checks
    sed -i 's/^#\[\[/\[\[/' $pathvr
    sed -i 's/^#(\[/(\[/' $pathvr
    sed -i 's/^#type/type/' $pathvr
    sed -i 's/^#hash/hash/' $pathvr

    # Comment out FZF stuff
    sed -i 's/  --bind/ #--bind/' $pathvr
    sed -i 's/  --preview-window/ #--preview-window/' $pathvr
    sed -i 's/  --color/ #--color/' $pathvr

    # Set TMPDIR
    sed -i 's|#export TMPDIR|export TMPDIR|' $pathvr

    # Set READE_NOSTYLE
    sed -i 's|#export READE_NOSTYLE|export READE_NOSTYLE|' $pathvr

    #if ! grep -q '.environment' ~/.bashrc && ! grep -q '.environment' $PROFILE; then
    yes-edit-no -f environment-variables -g "$pathvr" -p "Install .environment in $HOME?" -e 
    printf "It's recommended to logout and login again to notice a change for ${MAGENTA}.profile${normal} and any ${CYAN}.*shell*_profiles\n${normal}"

elif [[ "$envvars" == "y" ]]; then

    #Comment out every export in .environment
    sed -i -e '/export/ s/^#*/#/' $pathvr

    # Allow if checks
    sed -i 's/^#\[\[/\[\[/' $pathvr
    sed -i 's/^#(\[/(\[/' $pathvr
    sed -i 's/^#type/type/' $pathvr
    sed -i 's/^#hash/hash/' $pathvr

    # Comment out FZF stuff
    sed -i 's/  --bind/ #--bind/' $pathvr
    sed -i 's/  --preview-window/ #--preview-window/' $pathvr
    sed -i 's/  --color/ #--color/' $pathvr

    # Set TMPDIR
    sed 's|#export TMPDIR|export TMPDIR|' -i $pathvr
    
    # Set READE_NOSTYLE
    sed -i 's|#export READE_NOSTYLE|export READE_NOSTYLE|' $pathvr

    if ! grep -q '.environment' ~/.bashrc && ! grep -q '.environment' $PROFILE; then
        yes-edit-no -f environment-variables -g "$pathvr" -p "Install .environment in $HOME?" -e
        printf "It's recommended to logout and login again to notice a change for ${MAGENTA}.profile${normal} and any ${CYAN}.*shell*_profiles\n${normal}"
    fi

    # Package Managers
    #reade -Q "YELLOW" -i "y" -p "Check and create DIST,DIST_BASE,ARCH,PM and WRAPPER? (distro, distro base, architecture, package manager and pm wrapper) [Y/n]:" "n" Dists
    #if [ "$Dists" == "y" ]; then
    #   printf "NOT YET IMPLEMENTED\n"
    #fi

    # TODO: non ugly values
    readyn -p "Set LS_COLORS with some predefined values?" lsclrs
    if [[ "$lsclrs" == "y" ]] || [ -z "$lsclrs" ]; then
        sed 's/^#export LS_COLORS/export LS_COLORS/' -i $pathvr
    fi

    readyn -p "Set PAGER? (Page reader)" pgr
    if [[ "$pgr" == "y" ]] || [ -z "$pgr" ]; then
        # Uncomment export PAGER=
        sed 's/^#export PAGER=/export PAGER=/' -i $pathvr

        prmpt=""
        pagers=""
        
        if hash pg &>/dev/null; then
            pagers="pg $pagers"
            prmpt="\tpg = Archaic and unintuitive pager like vi is as an editor\n$prmpt"
        fi
        if hash more &>/dev/null; then
            pagers="more $pagers"
            prmpt="\tmore = Archaic pager - leaves text by default, less customizable (ironically)\n$prmpt"
        fi
        if type most &>/dev/null; then
            pagers="most $pagers"
            prmpt="\tmost = Installed pager that is very customizable\n$prmpt"
        fi
        if type bat &>/dev/null; then
            pagers="bat $pagers"
            prmpt="\tbat = Cat clone / pager wrapper with syntax highlighting\n$prmpt"
        fi
        if type nvimpager &>/dev/null; then
            pagers="nvimpager $pagers"
            prmpt="\tnvimpager = The pager that acts and feels like Neovim. Did you guess?\n$prmpt"
        fi
        if hash less &>/dev/null; then
            pagers="less $pagers"
            prmpt="\tless = Default pager - Basic, archaic but very customizable\n$prmpt"
        fi
        if type moar &>/dev/null; then
            pagers="moar $pagers"
            prmpt="\tmoar = Installed pager with an awesome default configuration\n$prmpt"
        fi
        printf "${green}$prmpt${normal}"

        reade -Q "GREEN" -i "$pagers" -p "PAGER(less default)=" pgr2


        pgr2="$(where_cmd $pgr2)"
        sed -i 's|export PAGER=.*|export PAGER='"$pgr2"'|' $pathvr
        
        unset pgr2 

        # Set less options that system supports
        sed -i 's|#export LESS=|export LESS=|g' $pathvr
        if hash man &>/dev/null; then
            lss=$(cat $pathvr | grep 'export LESS="*"' | sed 's|export LESS="\(.*\)"|\1|g')
            lss_n=""
            for opt in ${lss}; do
                opt1=$(echo "$opt" | sed 's|--\(\)|\1|g' | sed 's|\(\)\=.*|\1|g')
                if (man less | grep -Fq "${opt1}") 2>/dev/null; then
                    lss_n="$lss_n $opt"
                fi
            done
            sed -i "s|export LESS=.*|export LESS=\" $lss_n\"|g" $pathvr
            unset lss lss_n opt opt1
        fi
        #sed -i 's/#export LESSEDIT=/export LESSEDIT=/' .environment

        # Set moar options
        hash moar &> /dev/null && 
            sed -i 's/#export MOAR=/export MOAR=/' $pathvr
      
        # Set bat options
        hash bat &> /dev/null && 
            sed -i 's/#export BAT=/export BAT=/' $pathvr
    
        if [[ "$(basename ""$pgr2"")" == "bat" ]] && hash moar &>/dev/null || [[ "$(basename ""$pgr2"")" == "bat" ]] && hash nvimpager &>/dev/null; then
            prmpt=""
            pagers=""
            
            if hash pg &>/dev/null; then
                pagers="pg $pagers"
                prmpt="\tpg = Archaic and unintuitive pager like vi is as an editor\n$prmpt"
            fi
            if hash more &>/dev/null; then
                pagers="more $pagers"
                prmpt="\tmore = Archaic pager - leaves text by default, less customizable (ironically)\n$prmpt"
            fi
            if type most &>/dev/null; then
                pagers="most $pagers"
                prmpt="\tmost = Installed pager that is very customizable\n$prmpt"
            fi
            if type nvimpager &>/dev/null; then
                pagers="nvimpager $pagers"
                prmpt="\tnvimpager = The pager that acts and feels like Neovim. Did you guess?\n$prmpt"
            fi
            if hash less &>/dev/null; then
                pagers="less $pagers"
                prmpt="\tless = Default pager - Basic, archaic but very customizable\n$prmpt"
            fi
            if type moar &>/dev/null; then
                pagers="moar $pagers"
                prmpt="\tmoar = Installed pager with an awesome default configuration\n$prmpt"
            fi
            printf "${green}$prmpt${normal}"
            
            reade -Q "GREEN" -i "$pagers" -p "BAT_PAGER(less default)=" pgr2
            pgr2="$(where_cmd $pgr2)"
            [[ "$pgr2" =~ "less" ]] && pgr2="$pgr2 \$LESS --line-numbers"
            [[ "$pgr2" =~ "moar" ]] && pgr2="$pgr2 \$MOAR --no-linenumbers"
            sed 's/^#export BAT_PAGER=/export BAT_PAGER=/' -i $pathvr
            sed -i "s|^export BAT_PAGER=.*|export BAT_PAGER=\"$pgr2\"|" $pathvr
        fi
    fi
    
    unset pagers prmpt

    if type nvim &>/dev/null; then
        readyn -p "Set Neovim as MANPAGER?" manvim
        if [[ "$manvim" == "y" ]]; then
            sed -i 's|.export MANPAGER=.*|export MANPAGER='\''nvim +Man!'\''|g' $pathvr
        fi
    fi

    readyn -p "Set EDITOR and VISUAL?" edtvsl
    if [[ "$edtvsl" == "y" ]]; then
        editors="" 
        prmpt="${green}" 
        if hash vi &>/dev/null; then
            editors="vi $editors"
            prmpt="$prmpt \tvi = Archaic and non-userfriendly editor\n"
        fi
        if hash nano &>/dev/null; then
            editors="nano $editors"
            prmpt="$prmpt \tnano = Default editor - Basic, but userfriendly\n"
        fi
        if hash edit &>/dev/null; then
            editors="edit $editors"
            prmpt="$prmpt \tedit = One of unix default editors = Archaic editor - not recommended\n"
        fi
        if hash micro &>/dev/null; then
            editors="micro $editors"
            prmpt="$prmpt \tMicro = Relatively good out-of-the-box editor - Decent keybindings, yet no customizations\n"
        fi
        if hash ne &>/dev/null; then
            editors="ne $editors"
            prmpt="$prmpt \tNice editor = Relatively good out-of-the-box editor - Decent keybindings, yet no customizations\n"
        fi

        if hash vim &>/dev/null; then
            editors="vim $editors"
            prmpt="$prmpt \tvim = The one and only true modal editor - Not userfriendly, but many features (maybe even too many) and greatly customizable\n"
            #sed -i "s|#export MYVIMRC=|export MYVIMRC=|g" $pathvr
            #sed -i "s|#export MYGVIMRC=|export MYGVIMRC=|g" $pathvr
        fi
        if hash nvim &>/dev/null; then
            editors="nvim $editors"
            prmpt="$prmpt \tnvim (neovim) = A better vim? - Faster and less buggy then regular vim, even a little userfriendlier\n"
            #sed -i "s|#export MYVIMRC=|export MYVIMRC=|g" $pathvr
            #sed -i "s|#export MYGVIMRC=|export MYGVIMRC=|g" $pathvr
        fi
        if hash emacs &>/dev/null; then
            editors="emacs $editors"
            prmpt="$prmpt \tEmacs = One of the oldest and versatile editors - Modal and featurerich, but overwhelming as well\n"
        fi
        if hash code &>/dev/null; then
            editors="$editors code"
            prmpt="$prmpt \tCode = Visual Studio Code - Modern standard for most when it comes to text editors (Warning: does not work well when paired with sudo)\n"
        fi
       
        printf "$prmpt${normal}"
        
        touch $TMPDIR/editor-outpt
        # Redirect output to file in subshell (mimeopen gives output but also starts read. This cancels read). In tmp because that gets cleaned up
        (echo "" | mimeopen -a editor-check.sh &>$TMPDIR/editor-outpt)
        editors1="$(cat $TMPDIR/editor-outpt | awk 'NR > 2' | awk '{if (prev_1_line) print prev_1_line; prev_1_line=prev_line} {prev_line=$NF}' | sed 's|[()]||g' | tr '\n' ' ' | uniq)$editors"
        editors1="$(echo $editors1 | tr ' ' '\n' | sort -u | xargs | tr ' ' '\n')"
        prmpt="Found editors using ${CYAN}mimeopen${normal} (non definitive list): ${GREEN}\n"
        while IFS= read -r i; do            
            prmpt="$prmpt\t - $i\n"
        done <<< $editors1
        printf "$prmpt${normal}"
       
        editors="$(echo $editors1 | tr '\n' ' ')"
        frst="$(echo $editors | awk '{print $1}')"
        editors_p="$(echo $editors | sed "s/\<$frst\> //g")"
        
        reade -Q "GREEN" -i "$frst $editors_p" -p "EDITOR (Terminal - $frst default)=" edtor
        
        edtor="$(where_cmd $edtor)"
        if [[ "$edtor" =~ "emacs" ]]; then
            edtor="$edtor -nw"
        fi
        sed -i 's|#export EDITOR=.*|export EDITOR='$edtor'|g' $pathvr

        # Make .txt file and output file

        readyn -N 'CYAN' -n -p "Set VISUAL to the value of 'EDITOR'? (otherwise set manually again)" vis_ed
        if [[ $vis_ed == 'y' ]]; then
            sed -i 's|#export VISUAL=|export VISUAL=|g' $pathvr
            sed -i 's|export VISUAL=.*|export VISUAL=$EDITOR|g' $pathvr
        else
           
            prmpt="Found visual editors using ${CYAN}mimeopen${normal} (non definitive list): ${GREEN}\n"
            while IFS= read -r i; do            
                prmpt="$prmpt\t - $i\n"
            done <<< $editors1
            prmpt="$prmpt${normal}"
            #frst="$(echo $compedit | awk '{print $1}')"
            #compedit="$(echo $compedit | sed "s/\<$frst\> //g")"
            printf "$prmpt"
        
            reade -Q "GREEN" -i "$frst $editors_p" -p "VISUAL (GUI editor - $frst default)=" vsual
            vsual="$(where_cmd $vsual)"
            sed -i 's|#export VISUAL=|export VISUAL=|g' $pathvr
            sed -i 's|export VISUAL=.*|export VISUAL='"$vsual"'|g' $pathvr
        fi

        unset vis_ed

        if grep -q "#export SUDO_EDITOR" $pathvr; then
            readyn -p "Set SUDO_EDITOR to the value of 'EDITOR'?" sud_edt
            if [[ "$sud_edt" == "y" ]]; then
                sed -i 's|#export SUDO_EDITOR.*|export SUDO_EDITOR=$EDITOR|g' $pathvr
            fi
        fi
        unset sud_edit

        if grep -q "#export SUDO_VISUAL" $pathvr; then
            printf "!! Warning: Certain visual code editors (like ${CYAN}'Visual Studio Code'${normal}) don't work properly when using ${RED}sudo${normal}\nIt might be better to keep using \$EDITOR depending on what \$VISUAL is configured as\n"
            readyn -p "Set SUDO_VISUAL to the value of 'EDITOR'?" sud_vis
            if [[ "$sud_vis" == "y" ]]; then
                sed -i 's|#export SUDO_VISUAL.*|export SUDO_VISUAL=$EDITOR|g' $pathvr
            else
                readyn -p "Set SUDO_VISUAL to the value of 'VISUAL'?" sud_edt
                if [[ "$sud_vis" == "y" ]]; then
                    sed -i 's|#export SUDO_VISUAL.*|export SUDO_VISUAL=$VISUAL|g' $pathvr
                fi
            fi
        fi
        unset sud_vis

        if test -f /etc/sudoers; then
            echo "Next $(tput setaf 1)sudo$(tput sgr0) will check for 'Defaults env_keep += \"PAGER\"' in /etc/sudoers"
            if ! sudo grep -q "Defaults env_keep += \"PAGER\"" /etc/sudoers; then
                printf "${bold}${yellow}Sudo by default does not respect the user's PAGER environment. If you were to want to use a custom pager with sudo (except with ${cyan}systemctl/journalctl${bold}${yellow}, more on that later) you would need to always pass your environment using 'sudo -E'\n${normal}"
                readyn -Y 'YELLOW' -p "Change this behaviour permanently in /etc/sudoers?" sudrs
                if [[ "$sudrs" == "y" ]]; then
                    sudo sed -i '1s/^/Defaults env_keep += "PAGER SYSTEMD_PAGERSECURE"\n/' /etc/sudoers
                    echo "Added ${RED}'Defaults env_keep += \"PAGER SYSTEMD_PAGERSECURE\"'${normal} to /etc/sudoers"
                fi
            fi

            echo "Next $(tput setaf 1)sudo$(tput sgr0) will check for 'Defaults env_keep += \"EDITOR\"' and 'Defaults env_keep += \"VISUAL\"' in /etc/sudoers"
            if ! sudo grep -q "Defaults env_keep += \"EDITOR\"" /etc/sudoers || ! sudo grep -q "Defaults env_keep += \"VISUAL\"" /etc/sudoers; then
                printf "${bold}${yellow}Sudo by default does not respect the user's EDITOR/VISUAL environment and SUDO_EDITOR is not always checked by programs.\nIf you were to want edit root crontabs (sudo crontab -e), you would get vi (unless using 'sudo -E' to pass your environment)\n${normal}"
                readyn -Y "YELLOW" -p "Change this behaviour permanently in /etc/sudoers? (Run 'man --pager='less -p ^security' less' if you want to see the potential security holes when using less)" sudrs
                if [[ "$sudrs" == "y" ]]; then
                    if ! sudo grep -q "Defaults env_keep += \"EDITOR\"" /etc/sudoers; then
                        sudo sed -i '1s/^/Defaults env_keep += "EDITOR"\n/' /etc/sudoers
                        echo "Added ${RED}'Defaults env_keep += \"EDITOR\"'${normal} to /etc/sudoers"
                    fi
                    if ! sudo grep -q "Defaults env_keep += \"VISUAL\"" /etc/sudoers; then
                        sudo sed -i '1s/^/Defaults env_keep += "VISUAL"\n/' /etc/sudoers
                        echo "Added ${RED}'Defaults env_keep += \"VISUAL\"'${normal} to /etc/sudoers"
                    fi
                fi
            fi
        fi
    fi
    unset edtvsl compedit frst editors prmpt

    # Set DISPLAY
    if type nmcli &>/dev/null; then
        addr=$(nmcli device show | grep IP4.ADDR | awk 'NR==1{print $2}' | sed 's|\(.*\)/.*|\1|')
    fi
    #reade -Q "GREEN" -i "n" -p "Set DISPLAY to ':$(addr).0'? [Y/n]:" "n" dsply
    if [[ $- =~ i ]] && [[ -n "$SSH_TTY" ]]; then
        reade -Y "YELLOW" -n -p "Detected shell is SSH. For X11, it's more reliable performance to dissallow shared clipboard (to prevent constant hanging). Set DISPLAY to 'localhost:10.0'?" dsply
        if [[ "$dsply" == "y" ]] || [ -z "$dsply" ]; then
            sed -i "s|.export DISPLAY=.*|export DISPLAY=\"localhost:10.0\"|" $pathvr
        fi
    fi
    unset dsply

    if type go &>/dev/null; then
        #sed -i 's|#export GOPATH|export GOPATH|' $pathvr
        sed -i 's|#export PATH=$PATH:$GOPATH|export PATH=$PATH:$GOPATH|' $pathvr
    fi
    unset snapvrs

    if type snap &>/dev/null; then
        sed -i 's|#export PATH=/bin/snap|export PATH=/bin/snap|' $pathvr
    fi
    unset snapvrs

    if type flatpak &>/dev/null; then
        sed -i 's|#export FLATPAK|export FLATPAK|' $pathvr
        sed -i 's|#\(export PATH=$PATH:$HOME/.local/bin/flatpak\)|\1|g' $pathvr
    fi
    unset snapvrs

    # TODO do something for flatpak  (XDG_DATA_DIRS)
    # Check if xdg installed
    if type xdg-open &>/dev/null; then
        prmpt="${green}This will set XDG environment variables to their respective defaults\n\
        XDG is related to default applications\n\
        Setting these could be usefull when installing certain programs \n\
        Defaults:\n\
        - XDG_CACHE_HOME=$HOME/.cache\n\
        - XDG_CONFIG_HOME=$HOME/.config\n\
        - XDG_CONFIG_DIRS=/etc/xdg\n\
        - XDG_DATA_HOME=$HOME/.local/share\n\
        - XDG_DATA_DIRS=/usr/local/share/:/usr/share\n\
        - XDG_STATE_HOME=$HOME/.local/state\n"
        printf "$prmpt${normal}"
        readyn -p "Set XDG environment?" xdgInst
        if [ -z "$xdgInst" ] || [[ "y" == "$xdgInst" ]]; then
            sed 's/^#export XDG_CACHE_HOME=\(.*\)/export XDG_CACHE_HOME=\1/' -i $pathvr
            sed 's/^#export XDG_CONFIG_HOME=\(.*\)/export XDG_CONFIG_HOME=\1/' -i $pathvr
            sed 's/^#export XDG_CONFIG_DIRS=\(.*\)/export XDG_CONFIG_DIRS=\1/' -i $pathvr
            sed 's/^#export XDG_DATA_HOME=\(.*\)/export XDG_DATA_HOME=\1/' -i $pathvr
            sed 's/^#export XDG_DATA_DIRS=\(.*\)/export XDG_DATA_DIRS=\1/' -i $pathvr
            sed 's/^#export XDG_STATE_HOME=\(.*\)/export XDG_STATE_HOME=\1/' -i $pathvr
            sed 's/^#export XDG_RUNTIME_DIR=\(.*\)/export XDG_RUNTIME_DIR=\1/' -i $pathvr
        fi
    fi
    unset xdgInst

    # TODO: check around for other systemdvars
    # Check if systemd installed
    if type systemctl &>/dev/null; then
        pageSec=1
        printf "${cyan}Systemd comes preinstalled with ${GREEN}SYSTEMD_PAGERSECURE=1${normal}.\n This means any pager without a 'secure mode' cant be used for ${CYAN}systemctl/journalctl${normal}.\n(Features that are fairly obscure and mostly less-specific in the first place -\n No editing (v), no examining (:e), no pipeing (|)...)\n It's an understandable concern to be better safe and sound, but this does constrain the user to ${CYAN}only using less.${normal}\n"
        readyn -N "YELLOW" -n -p "${yellow}Set SYSTEMD_PAGERSECURE to 0?" page_sec
        if [[ "$page_sec" == "y" ]]; then
            pageSec=0
            if test -f /etc/sudoers; then
                echo "Next $(tput setaf 1)sudo$(tput sgr0) will check for 'Defaults env_keep += \"SYSTEMD_PAGERSECURE\"' in /etc/sudoers"
                if ! sudo grep -q "Defaults env_keep += \"SYSTEMD_PAGERSECURE\"" /etc/sudoers; then
                    printf "${bold}${yellow}Sudo won't respect the user's SYSTEMD_PAGERSECURE environment. If you were to want to keep your userdefined less options or use a custom pager when using sudo with ${cyan}systemctl/journalctl${bold}${yellow}, you would need to always pass your environment using 'sudo -E'\n${normal}"
                    readyn -Y "YELLOW" -p "Change this behaviour permanently in /etc/sudoers?" sudrs
                    if [[ "$sudrs" == "y" ]]; then
                        sudo sed -i '1s/^/Defaults env_keep += "SYSTEMD_PAGERSECURE"\n/' /etc/sudoers
                        echo "Added ${RED}'Defaults env_keep += \"SYSTEMD_PAGERSECURE\"'${normal} to /etc/sudoers"
                    fi
                fi
            fi
        fi
        prmpt="${yellow}This will set SYSTEMD environment-variables\n\
        When setting a new pager for systemd or changing logging specifics\n\
        Defaults:\n\
        - SYSTEMD_PAGER=\$PAGER\n\
        - SYSTEMD_COLORS=256\n\
        - SYSTEMD_PAGERSECURE=$pageSec\n\
        - SYSTEMD_LESS=\"FRXMK\"\n\
        - SYSTEMD_LOG_LEVEL=\"warning\"\n\
        - SYSTEMD_LOG_COLOR=\"true\"\n\
        - SYSTEMD_LOG_TIME=\"true\"\n\
        - SYSTEMD_LOG_LOCATION=\"true\"\n\
        - SYSTEMD_LOG_TID=\"true\"\n\
        - SYSTEMD_LOG_TARGET=\"auto\"\n"
        printf "$prmpt${normal}"
        readyn -Y "YELLOW" -p "Set systemd environment?" xdgInst

        if test -z "$xdgInst" || [[ "y" == "$xdgInst" ]]; then
            sed 's/^#export SYSTEMD_PAGER=\(.*\)/export SYSTEMD_PAGER=\1/' -i $pathvr
            if [[ "$pageSec" == 0 ]]; then
                sed 's/^#export SYSTEMD_PAGERSECURE=\(.*\)/export SYSTEMD_PAGERSECURE=0/' -i $pathvr
            else
                sed 's/^#export SYSTEMD_PAGERSECURE=\(.*\)/export SYSTEMD_PAGERSECURE=1/' -i $pathvr
            fi
            sed 's/^#export SYSTEMD_COLORS=\(.*\)/export SYSTEMD_COLORS=\1/' -i $pathvr
            sed 's/^#export SYSTEMD_LESS=\(.*\)/export SYSTEMD_LESS=\1/' -i $pathvr
            sed 's/^#export SYSTEMD_LOG_LEVEL=\(.*\)/export SYSTEMD_LOG_LEVEL=\1/' -i $pathvr
            sed 's/^#export SYSTEMD_LOG_TIME=\(.*\)/export SYSTEMD_LOG_TIME=\1/' -i $pathvr
            sed 's/^#export SYSTEMD_LOG_LOCATION=\(.*\)/export SYSTEMD_LOG_LOCATION=\1/' -i $pathvr
            sed 's/^#export SYSTEMD_LOG_TID=\(.*\)/export SYSTEMD_LOG_TID=\1/' -i $pathvr
            sed 's/^#export SYSTEMD_LOG_TARGET=\(.*\)/export SYSTEMD_LOG_TARGET=\1/' -i $pathvr
        fi
    fi

    if test -d $HOME/.fzf/bin; then
        sed -i 's|^#export PATH=$PATH:$HOME/.fzf/bin|export PATH=$PATH:$HOME/.fzf/bin|g' $pathvr
    fi

    if type libvirtd &>/dev/null; then
        sed -i 's/^#export LIBVIRT_DEFAULT_URI/export LIBVIRT_DEFAULT_URI/' $pathvr
    fi

    yes-edit-no -f environment-variables -g "$pathvr" -p "Install .environment in $HOME?" -e 
    printf "It's recommended to logout and login again to notice a change for ${MAGENTA}.profile${normal} and any ${CYAN}.*shell*_profiles\n${normal}"

fi

# Check one last time if ~/.bash_preexec - for both $USER and root - is the last line in their ~/.bash_profile and ~/.bashrc

if ! test -f ./checks/check_bash_source_order.sh; then
    if type curl &>/dev/null; then
        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_bash_source_order.sh)
    else
        printf "If not downloading/git cloning the scriptfolder, you should at least install 'curl' beforehand when expecting any sort of succesfull result...\n"
        return 1 || exit 1
    fi
else
    . ./checks/check_bash_source_order.sh
fi

test -n "$BASH_VERSION" && source ~/.bashrc 
test -n "$ZSH_VERSION" && source ~/.zshrc 
