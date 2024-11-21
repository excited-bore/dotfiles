#!/usr/bin/env bash                            

if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi

if ! test -f checks/check_envvar.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_envvar.sh)" 
else
    . ./checks/check_envvar.sh
fi


if ! test -f aliases/.bash_aliases.d/00-rlwrap_scripts.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/00-rlwrap_scripts.sh)" 
else
    . ./aliases/.bash_aliases.d/00-rlwrap_scripts.sh
fi

# Environment variables

#if ! test -z $1; then
    #envvars=$1
#else
#fi

environment-variables_r(){ 
    sudo cp -fv $pathvr /root/.environment.env;
    if ! sudo test -f /root/.profile; then
        sudo touch /root/.profile
    fi
    shell_profiles="${MAGENTA}\t- /root/.profile\n"
    shell_rcs="" 
    if sudo test -f /root/.bash_profile; then
        shell_profiles="$shell_profiles${CYAN}\t- /root/.bash_profile\n"
    fi
    if sudo test -f /root/.bashrc; then
        shell_rcs="$shell_rcs${GREEN}\t- /root/.bashrc\n"
    fi
    prmpt="File(s):\n$shell_profiles${normal} get sourced at login\nFile ${MAGENTA}.profile${RED} won't get sourced at login${normal} if ${CYAN}.*shelltype*_profile${normal} exists\nFile(s):\n${CYAN}$shell_rcs${normal} get sourced when starting a new *shelltype* shell\n"
    printf "$prmpt" 
    
    if ! sudo grep -q "~/.environment.env" /root/.profile; then
        reade -Q 'GREEN' -i 'y' -p "Link .environment.env in ${YELLOW}/root/.profile${GREEN}? [Y/n]: " 'n' prof
        if test $prof == 'y'; then
            printf "\n[ -f ~/.environment.env ] && source ~/.environment.env\n\n" | sudo tee -a /root/.profile
        fi
    fi
    if sudo test -f /root/.bash_profile; then
        printf "\n${GREEN}Since file ${cyan}/root/.bash_profile${green} exists, ${cyan}bash${green} won't source ${magenta}/root/.profile${green} natively at login.\n${normal}"
        reade -Q 'GREEN' -i 'prof' -p "Source $HOME/.profile in $HOME/.bash_profile or source $HOME/.environment.env directly in $HOME/.bash_profile? [Prof/path/none]: " 'path none' bash_prof
        if [[ $bash_prof =~ 'prof' ]]; then
            if sudo grep -q '.bashrc' /root/.bash_profile && ! sudo  grep -q "~/.profile" /root/.bash_profile; then
                sudo sed -i 's|\(\[ -f ~/.bashrc \] && source ~/.bashrc\)|\[ -f \~/.profile \] \&\& source \~/.profile\n\n\1\n|g' /root/.bash_profile
                sudo sed -i 's|\(\[\[ -f ~/.bashrc \]\] && . ~/.bashrc\)|\[ -f \~/.profile \] \&\& source \~/.profile\n\n\1\n|g' /root/.bash_profile
            else 
                printf "\n[ -f ~/.environment.env ] && source ~/.profile\n\n" | sudo tee -a /root/.bash_profile
            fi
        elif test $bash_prof == 'path'; then
            if sudo grep -q '.bashrc' /root/.bash_profile && ! sudo  grep -q "~/.environment.env" /root/.bash_profile; then
                sudo sed -i 's|\(\[ -f ~/.bashrc \] && source ~/.bashrc\)|\[ -f \~/.environment.env \] \&\& source \~/.environment.env\n\n\1\n|g' /root/.bash_profile
                sudo sed -i 's|\(\[\[ -f ~/.bashrc \]\] && . ~/.bashrc\)|\[ -f \~/.environment.env \] \&\& source \~/.environment.env\n\n\1\n|g' /root/.bash_profile
            else 
                printf "\n[ -f ~/.environment.env ] && source ~/.environment.env\n\n" | sudo tee -a /root/.bash_profile
            fi
        fi
        if sudo test -f /root/.bashrc && ! sudo grep -q "~/.environment.env" /root/.bashrc; then
            reade -Q 'GREEN' -i 'y' -p "Source /root/.environment.env in /root/.bashrc? [Y/n]: " 'n' bashrc
            if test $bashrc == 'y'; then 
                if sudo grep -q "[ -f ~/.bash_completion ]" /root/.bashrc; then
                    sudo sed -i 's|\(\[ -f ~/.bash_completion \] \&\& source \~/.bash_completion\)|\[ -f \~/.environment.env \] \&\& source \~/.environment.env\n\n\1\n|g' /root/.bashrc
                elif sudo grep -q "[ -f ~/.bash_aliases ]" /root/.bashrc; then
                    sudo sed -i 's|\(\[ -f ~/.bash_aliases \] \&\& source \~/.bash_aliases\)|\[ -f \~/.environment.env \] \&\& source \~/.environment.env\n\n\1\n|g' /root/.bashrc
                    sudo sed -i 's|\(if \[ -f ~/.bash_aliases \]; then\)|\[ -f \~/.environment.env \] \&\& source \~/.environment.env\n\n\1\n|g' /root/.bashrc
                elif sudo grep -q "[ -f ~/.keybinds ]" /root/.bashrc; then
                    sudo sed -i 's|\(\[ -f ~/.keybinds \] \&\& source \~/.keybinds\)|\[ -f \~/.environment.env \] \&\& source \~/.environment.env\n\n\1\n|g' /root/.bashrc
                else 
                    printf "\n[ -f ~/.environment.env ] && source ~/.environment.env\n\n" | sudo tee -a /root/.bashrc
                fi 
            fi
        fi  
        unset bash_prof_ex prmpt shell_profiles shell_rcs prof bashrc 
    fi 
     
}                                            

environment-variables(){
    cp -fv $pathvr ~/.environment.env
    if ! test -f ~/.profile; then
        touch ~/.profile
    fi
    shell_profiles="${MAGENTA}\t- $HOME/.profile\n"
    shell_rcs="" 
    if test -f ~/.bash_profile; then
        shell_profiles="$shell_profiles${CYAN}\t- $HOME/.bash_profile\n"
    fi
    if test -f ~/.bashrc; then
        shell_rcs="$shell_rcs${GREEN}\t- $HOME/.bashrc\n"
    fi
    prmpt="File(s):\n$shell_profiles${normal} get sourced at login\nFile ${MAGENTA}.profile${RED} won't get sourced at login${normal} if ${CYAN}.*shelltype*_profile${normal} exists\nFile(s):\n${CYAN}$shell_rcs${normal} get sourced when starting a new *shelltype* shell\n"
    printf "$prmpt" 
    
    if ! grep -q "~/.environment.env" ~/.profile; then
        reade -Q 'GREEN' -i 'y' -p "Link .environment.env in ~/.profile? [Y/n]: " 'n' prof
        if test $prof == 'y'; then
            printf "\n[ -f ~/.environment.env ] && source ~/.environment.env\n\n" >> ~/.profile
        fi
        unset prof
    fi
    if test -f ~/.bash_profile && ! grep -q "~/.bash_profile" ~/.profile; then
        reade -Q 'GREEN' -i 'y' -p "Link ~/.bash_profile in ~/.profile? [Y/n]: " 'n' bprof
        if test $prof == 'y'; then
            printf "\n[ -f ~/.bash_profile ] && source ~/.bash_profile\n\n" >> ~/.profile
        fi
        unset bprof
    fi
     
    if test -f ~/.bash_profile; then
        printf "\n${GREEN}Since file ${cyan}$HOME/.bash_profile${green} exists, ${cyan}bash${green} won't source ${magenta}$HOME/.profile${green} natively at login.\n${normal}"
        reade -Q 'GREEN' -i 'prof' -p "Source $HOME/.profile in $HOME/.bash_profile or source $HOME/.environment.env directly in $HOME/.bash_profile? [Prof/path/none]: " 'path none' bash_prof
        if [[ $bash_prof =~ 'prof' ]]; then
            if ! grep -q "~/.profile" ~/.bash_profile; then
                printf "\n[ -f ~/.environment.env ] && source ~/.profile\n\n" >> ~/.bash_profile
            fi
        elif test $bash_prof == 'path'; then
            if ! grep -q "~/.environment.env" ~/.bash_profile; then
                printf "\n[ -f ~/.environment.env ] && source ~/.environment.env\n\n" >> ~/.bash_profile
            fi
        fi
        if test -f ~/.bashrc && ! grep -q "~/.environment.env" ~/.bashrc; then
            reade -Q 'GREEN' -i 'y' -p "Source $HOME/.environment.env in $HOME/.bashrc? [Y/n]: " 'n' bashrc
            if test $bashrc == 'y'; then 
                if grep -q "[ -f ~/.bash_completion ]" ~/.bashrc; then
                     sed -i 's|\(\[ -f ~/.bash_completion \] \&\& source \~/.bash_completion\)|\[ -f \~/.environment.env \] \&\& source \~/.environment.env\n\n\1\n|g' ~/.bashrc
                elif grep -q "[ -f ~/.bash_aliases ]" ~/.bashrc || grep -q "~/.bash_aliases" ~/.bashrc; then
                     sed -i 's|\(\[ -f ~/.bash_aliases \] \&\& source \~/.bash_aliases\)|\[ -f \~/.environment.env \] \&\& source \~/.environment.env\n\n\1\n|g' ~/.bashrc
                     sed -i 's|\(if \[ -f ~/.bash_aliases \]; then\)|\[ -f \~/.environment.env \] \&\& source \~/.environment.env\n\n\1\n|g' ~/.bashrc
                elif grep -q "[ -f ~/.keybinds ]" ~/.bashrc; then
                     sed -i 's|\(\[ -f ~/.keybinds \] \&\& source \~/.keybinds\)|\[ -f \~/.environment.env \] \&\& source \~/.environment.env\n\n\1\n|g' ~/.bashrc
                else
                    printf "\n[ -f ~/.environment.env ] && source ~/.environment.env\n\n" >> ~/.bashrc
                fi
            fi
        fi  
        unset bash_prof_ex prmpt shell_profiles shell_rcs prof bashrc 
    fi
    
    if ! sudo grep -q '.environment.env' /root/.bashrc && ! sudo grep -q '.environment.env' $PROFILE_R; then
        yes_edit_no environment-variables_r "$pathvr" "Install .environment.env in /root/?" "edit" "YELLOW"; 
    fi 
}

pathvr=$(pwd)/envvars/.environment.env
if ! test -f $pathvr; then
    tmp=$(mktemp) && curl -o $tmp https://raw.githubusercontent.com/excited-bore/dotfiles/main/envvars/.environment.env
    pathvr=$tmp
fi

pre='y'
othr='n'
color='GREEN'
prmpt='[Y/n]: '

#echo "Next $(tput setaf 1)sudo$(tput sgr0) check for /root/.environment.env' "
#if test -f ~/.environment.env && sudo test -f /root/.environment.env; then
#    pre='n' 
#    othr='y'
#    color='YELLOW'
#    prmpt='[N/y]: '
#fi


reade -Q "$color" -i "$pre" -p "Check existence/Create '.environment.env' and link it to '.bashrc' in $HOME/ and /root/? $prmpt" "$othr" envvars

if [ "$envvars" == "y" ] && test "$1" == 'n'; then

    #Comment out every export in .environment
    sed -i -e '/export/ s/^#*/#/' $pathvr
        
    # Allow if checks
    sed -i 's/^#\[\[/\[\[/' $pathvr
    sed -i 's/^#type/type/' $pathvr

    # Comment out FZF stuff
    sed -i 's/  --bind/ #--bind/' $pathvr
    sed -i 's/  --preview-window/ #--preview-window/' $pathvr
    sed -i 's/  --color/ #--color/' $pathvr

    # Set tmpdir
    sed 's|#export TMPDIR|export TMPDIR|' -i $pathvr

    if ! grep -q '.environment.env' ~/.bashrc && ! grep -q '.environment.env' $PROFILE; then
        yes_edit_no environment-variables "$pathvr" "Install .environment.env in $HOME?" "edit" "GREEN"
        printf "It's recommended to logout and login again to notice a change for ${MAGENTA}.profile${normal} and any ${CYAN}.*shelltype*_profiles\n${normal}" 
    fi

elif [ "$envvars" == "y" ]; then 
    
    #Comment out every export in .environment
    sed -i -e '/export/ s/^#*/#/' $pathvr
        
    # Allow if checks
    sed -i 's/^#\[\[/\[\[/' $pathvr
    sed -i 's/^#type/type/' $pathvr
    
    # Comment out FZF stuff
    sed -i 's/  --bind/ #--bind/' $pathvr
    sed -i 's/  --preview-window/ #--preview-window/' $pathvr
    sed -i 's/  --color/ #--color/' $pathvr

    # Set tmpdir
    sed 's|#export TMPDIR|export TMPDIR|' -i $pathvr

    if ! grep -q '.environment.env' ~/.bashrc && ! grep -q '.environment.env' $PROFILE; then
        yes_edit_no environment-variables "$pathvr" "Install .environment.env in $HOME?" "edit" "GREEN"
        printf "It's recommended to logout and login again to notice a change for ${MAGENTA}.profile${normal} and any ${CYAN}.*shelltype*_profiles\n${normal}" 
    fi
    
    # Package Managers
    #reade -Q "YELLOW" -i "y" -p "Check and create DIST,DIST_BASE,ARCH,PM and WRAPPER? (distro, distro base, architecture, package manager and pm wrapper) [Y/n]:" "n" Dists
    #if [ "$Dists" == "y" ]; then
    #   printf "NOT YET IMPLEMENTED\n"
    #fi
    
    # TODO: non ugly values
    reade -Q "GREEN" -i "y" -p "Set LS_COLORS with some predefined values? [Y/n]: " "n" lsclrs
    if [ "$lsclrs" == "y" ] || [ -z "$lsclrs" ]; then
        sed 's/^#export LS_COLORS/export LS_COLORS/' -i $pathvr
    fi
    
    reade -Q "GREEN" -i "y" -p "Set PAGER? (Page reader) [Y/n]: " "n" pgr
    if [ "$pgr" == "y" ] || [ -z "$pgr" ]; then
        # Uncomment export PAGER=
        sed 's/^#export PAGER=/export PAGER=/' -i $pathvr
        
        pagers="more"
        prmpt="${green} \tless = Default pager - Basic, archaic but very customizable\n\tmore = Preinstalled other pager - leaves text by default, less customizable (ironically)\n"
        if type pg &> /dev/null; then
            pagers="$pagers pg"
            prmpt="$prmpt \tpg = Archaic and unintuitive like vi\n"
        fi
        if type most &> /dev/null; then
            pagers="$pagers most"
            prmpt="$prmpt \tmost = Installed pager that is very customizable\n"
        fi
        if type bat &> /dev/null; then
            pagers="$pagers bat"
            prmpt="$prmpt \tbat = Cat clone / pager wrapper with syntax highlighting\n"
            sed -i 's/#export BAT=/export BAT=/' $pathvr
        fi
        if type moar &> /dev/null; then
            pagers="$pagers moar"
            prmpt="$prmpt \tmoar = Installed pager with an awesome default configuration\n"
            sed -i 's/#export MOAR=/export MOAR=/' $pathvr
        fi
        if type nvimpager &> /dev/null; then
            pagers="$pagers nvimpager"
            prmpt="$prmpt \tnvimpager = The pager that acts and feels like Neovim. Did you guess?\n"
        fi
        printf "$prmpt${normal}"
        
        reade -Q "GREEN" -i "less" -p "PAGER(less default)=" "$pagers" pgr2
        
        pgr2="$(where_cmd $pgr2)"
        sed -i 's|export PAGER=.*|export PAGER='"$pgr2"'|' $pathvr

        # Set less options that system supports 
        sed -i 's|#export LESS=|export LESS=|g' $pathvr
        if type man &> /dev/null; then
            lss=$(cat $pathvr | grep 'export LESS="*"' | sed 's|export LESS="\(.*\)"|\1|g')
            lss_n=""
            for opt in ${lss}; do
                opt1=$(echo "$opt" | sed 's|--\(\)|\1|g' | sed 's|\(\)\=.*|\1|g')
                if (man less | grep -Fq "${opt1}") 2> /dev/null; then
                    lss_n="$lss_n $opt"
                fi
            done
            sed -i "s|export LESS=.*|export LESS=\" $lss_n\"|g" $pathvr
            unset lss lss_n opt opt1
        fi 
        #sed -i 's/#export LESSEDIT=/export LESSEDIT=/' .environment.env

        # Set moar options
        sed -i 's/#export MOAR=/export MOAR=/' $pathvr
        if test "$(basename ""$pgr2"")" == "bat" && type moar &> /dev/null || test "$(basename ""$pgr2"")" == "bat" && type nvimpager &> /dev/null ; then
            pagers=""
            prmpt="${cyan}Bat is a pager wrapper that defaults to less except if BAT_PAGER is set\n\t${green}less = Default pager - Basic, archaic but very customizable\n"
            if type moar &> /dev/null; then
                pagers="$pagers moar"
                prmpt="$prmpt \tmoar = Custom pager with an awesome default configuration\n"
            fi
            if type nvimpager &> /dev/null; then
                pagers="$pagers nvimpager"
                prmpt="$prmpt \tnvimpager = The pager that acts and feels like Neovim. Did you guess?\n"
            fi
            printf "$prmpt${normal}"
            reade -Q "GREEN" -i "less" -p "BAT_PAGER(less default)=" "$pagers" pgr2
            pgr2="$(where_cmd $pgr2)"
            [[ "$pgr2" =~ "less" ]] && pgr2="$pgr2 \$LESS --line-numbers"  
            [[ "$pgr2" =~ "moar" ]] && pgr2="$pgr2 \$MOAR --no-linenumbers"  
            sed 's/^#export BAT_PAGER=/export BAT_PAGER=/' -i $pathvr
            sed -i "s|^export BAT_PAGER=.*|export BAT_PAGER=\"$pgr2\"|" $pathvr
        fi
    fi
    unset prmpt
    
    if type nvim &> /dev/null; then
        reade -Q "GREEN" -i "y" -p "Set Neovim as MANPAGER? [Y/n]: " "n" manvim
        if [ "$manvim" == "y" ]; then
           sed -i 's|.export MANPAGER=.*|export MANPAGER='\''nvim +Man!'\''|g' $pathvr 
        fi
    fi

    reade -Q "GREEN" -i "y" -p "Set EDITOR and VISUAL? [Y/n]: " "n" edtvsl
    if [ "$edtvsl" == "y" ] || [ -z "$edtvsl" ]; then
        if type vi &> /dev/null; then
            editors="vi $editors"
            prmpt="$prmpt \tvi = Archaic and non-userfriendly editor\n"
        fi
        if type nano &> /dev/null; then 
            editors="nano"
            prmpt="${green}\tnano = Default editor - Basic, but userfriendly\n" 
        fi 
        if type micro &> /dev/null; then
            editors="micro $editors"
            prmpt="$prmpt \tMicro = Relatively good out-of-the-box editor - Decent keybindings, yet no customizations\n"
        fi
        if type ne &> /dev/null; then
            editors="ne $editors"
            prmpt="$prmpt \tNice editor = Relatively good out-of-the-box editor - Decent keybindings, yet no customizations\n"
        fi
        if type vim &> /dev/null; then
            editors="vim $editors"
            prmpt="$prmpt \tvim = The one and only true modal editor - Not userfriendly, but many features (maybe even too many) and greatly customizable\n"
            sed -i "s|#export MYVIMRC=|export MYVIMRC=|g" $pathvr
            sed -i "s|#export MYGVIMRC=|export MYGVIMRC=|g" $pathvr
        fi
        if type nvim &> /dev/null; then                                  
            editors="nvim $editors"
            prmpt="$prmpt \tnvim (neovim) = A better vim? - Faster and less buggy then regular vim, even a little userfriendlier\n"
            sed -i "s|#export MYVIMRC=|export MYVIMRC=|g" $pathvr
            sed -i "s|#export MYGVIMRC=|export MYGVIMRC=|g" $pathvr
        fi
        if type emacs &> /dev/null; then
            editors="emacs $editors"
            prmpt="$prmpt \tEmacs = One of the oldest and versatile editors - Modal and featurerich, but overwhelming as well\n"
        fi
        if type code &> /dev/null; then
            editors="$editors code"
            prmpt="$prmpt \tCode = Visual Studio Code - Modern standard for most when it comes to text editors (Warning: does not work well when paired with sudo)\n"
        fi
        printf "$prmpt${normal}"
        touch $TMPDIR/editor-outpt
        # Redirect output to file in subshell (mimeopen gives output but also starts read. This cancels read). In tmp because that gets cleaned up
        (echo "" | mimeopen -a editor-check.sh &> $TMPDIR/editor-outpt)
        editors="$(cat $TMPDIR/editor-outpt | awk 'NR > 2' | awk '{if (prev_1_line) print prev_1_line; prev_1_line=prev_line} {prev_line=$NF}' | sed 's|[()]||g' | tr -s [:space:] \\n | uniq | tr '\n' ' ') $editors"
        editors="$(echo $editors | tr ' ' '\n' | sort -u)"
        prmpt="Found visual editors using ${CYAN}mimeopen${normal} (non definitive list): ${GREEN}\n"
        for i in $editors; do
            prmpt="$prmpt\t - $i\n"
        done
        prmpt="$prmpt${normal}"

        frst="$(echo $editors | awk '{print $1}')" 
        editors_p="$(echo $editors | sed "s/\<$frst\> //g")" 
        #frst="$(echo $compedit | awk '{print $1}')"
        #compedit="$(echo $compedit | sed "s/\<$frst\> //g")"
        printf "$prmpt"
        reade -Q "GREEN" -i "$frst" -p "EDITOR (Terminal - $frst default)=" "$editors_p" edtor
        edtor="$(where_cmd $edtor)"
        if [[ "$edtor" =~ "emacs" ]]; then
            edtor="$edtor -nw"
        fi
        sed -i 's|#export EDITOR=.*|export EDITOR='$edtor'|g' $pathvr
        
        # Make .txt file and output file
         
        reade -Q 'CYAN' -i 'n' -p "Set VISUAL to '\\\\\$EDITOR'? (otherwise set manually again) [N/y]: " 'y' vis_ed
        if test $vis_ed == 'y'; then
            sed -i 's|#export VISUAL=|export VISUAL=|g' $pathvr
            sed -i 's|export VISUAL=.*|export VISUAL=$EDITOR|g' $pathvr
        else
            prmpt="Found visual editors using ${CYAN}mimeopen${normal} (non definitive list): ${GREEN}\n"
            for i in $editors; do
                prmpt="$prmpt\t - $i\n"
            done
            prmpt="$prmpt${normal}"
            #frst="$(echo $compedit | awk '{print $1}')"
            #compedit="$(echo $compedit | sed "s/\<$frst\> //g")"
            printf "$prmpt"

            reade -Q "GREEN" -i "$frst" -p "VISUAL (GUI editor - $frst default)=" "$editors_p" vsual
            vsual="$(where_cmd $vsual)"
            sed -i 's|#export VISUAL=|export VISUAL=|g' $pathvr
            sed -i 's|export VISUAL=.*|export VISUAL='"$vsual"'|g' $pathvr
        fi
        
        unset vis_ed

        if grep -q "#export SUDO_EDITOR" $pathvr; then
            reade -Q "GREEN" -i "y" -p "Set SUDO_EDITOR to \\\\\$EDITOR? [Y/n]: " "n" sud_edt
            if test "$sud_edt" == "y"; then
                sed -i 's|#export SUDO_EDITOR.*|export SUDO_EDITOR=$EDITOR|g' $pathvr
            fi
        fi
        unset sud_edit

        if grep -q "#export SUDO_VISUAL" $pathvr; then
            printf "!! Warning: Certain visual code editors (like ${CYAN}'Visual Studio Code'${normal}) don't work properly when using ${RED}sudo${normal}\nIt might be better to keep using \$EDITOR depending on what \$VISUAL is configured as\n" 
            reade -Q "GREEN" -i "y" -p "Set SUDO_VISUAL to \\\\\$EDITOR? [Y/n]: " "n" sud_vis
            if test "$sud_vis" == "y"; then
                sed -i 's|#export SUDO_VISUAL.*|export SUDO_VISUAL=$EDITOR|g' $pathvr
            else 
                reade -Q "GREEN" -i "y" -p "Set SUDO_VISUAL to \\\\\$VISUAL? [Y/n]: " "n" sud_edt
                if test "$sud_vis" == "y"; then
                    sed -i 's|#export SUDO_VISUAL.*|export SUDO_VISUAL=$VISUAL|g' $pathvr
                fi     
            fi
        fi
        unset sud_vis

        if test -f /etc/sudoers; then 
            echo "Next $(tput setaf 1)sudo$(tput sgr0) will check for 'Defaults env_keep += \"PAGER\"' in /etc/sudoers"
            if ! sudo grep -q "Defaults env_keep += \"PAGER\"" /etc/sudoers; then
                printf "${bold}${yellow}Sudo by default does not respect the user's PAGER environment. If you were to want to use a custom pager with sudo (except with ${cyan}systemctl/journalctl${bold}${yellow}, more on that later) you would need to always pass your environment using 'sudo -E'\n${normal}"
                reade -Q "YELLOW" -i "y" -p "Change this behaviour permanently in /etc/sudoers? [Y/n]: " "n" sudrs
                if test "$sudrs" == "y"; then
                    sudo sed -i '1s/^/Defaults env_keep += "PAGER SYSTEMD_PAGERSECURE"\n/' /etc/sudoers
                    echo "Added ${RED}'Defaults env_keep += \"PAGER SYSTEMD_PAGERSECURE\"'${normal} to /etc/sudoers"
                fi
            fi

            echo "Next $(tput setaf 1)sudo$(tput sgr0) will check for 'Defaults env_keep += \"EDITOR\"' and 'Defaults env_keep += \"VISUAL\"' in /etc/sudoers"
            if ! sudo grep -q "Defaults env_keep += \"EDITOR\"" /etc/sudoers || ! sudo grep -q "Defaults env_keep += \"VISUAL\""  /etc/sudoers; then
                printf "${bold}${yellow}Sudo by default does not respect the user's EDITOR/VISUAL environment and SUDO_EDITOR is not always checked by programs.\nIf you were to want edit root crontabs (sudo crontab -e), you would get vi (unless using 'sudo -E' to pass your environment)\n${normal}"
                reade -Q "YELLOW" -i "n" -p "Change this behaviour permanently in /etc/sudoers? (Run 'man --pager='less -p ^security' less' if you want to see the potential security holes when using less) [N/y]: " "y" sudrs
                if test "$sudrs" == "y"; then
                    if ! sudo grep -q "Defaults env_keep += \"EDITOR\"" /etc/sudoers ; then 
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
    if type nmcli &> /dev/null; then
        addr=$(nmcli device show | grep IP4.ADDR | awk 'NR==1{print $2}'| sed 's|\(.*\)/.*|\1|')
    fi
    #reade -Q "GREEN" -i "n" -p "Set DISPLAY to ':$(addr).0'? [Y/n]:" "n" dsply
    if [[ $- =~ i ]] && [[ -n "$SSH_TTY" ]]; then
        reade -Q "YELLOW" -i "n" -p "Detected shell is SSH. For X11, it's more reliable performance to dissallow shared clipboard (to prevent constant hanging). Set DISPLAY to 'localhost:10.0'? [Y/n]:" "n" dsply
        if [ "$dsply" == "y" ] || [ -z "$dsply" ]; then
            sed -i "s|.export DISPLAY=.*|export DISPLAY=\"localhost:10.0\"|" $pathvr
        fi
    fi
    unset dsply

    if type go &> /dev/null; then
        sed -i 's|#export GOPATH|export GOPATH|' $pathvr 
    fi
    unset snapvrs

    if type snap &> /dev/null; then
        sed -i 's|#export PATH=/bin/snap|export PATH=/bin/snap|' $pathvr 
    fi
    unset snapvrs
    
    if type flatpak &> /dev/null; then
        sed -i 's|#export FLATPAK|export FLATPAK|' $pathvr 
        sed -i 's|#\(export PATH=$PATH:$HOME/.local/bin/flatpak\)|\1|g' $pathvr
    fi
    unset snapvrs

    # TODO do something for flatpak  (XDG_DATA_DIRS)
    # Check if xdg installed
    if type xdg-open &> /dev/null ; then
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
        reade -Q "GREEN" -i "y" -p "Set XDG environment? [Y/n]: " "n" xdgInst
        if [ -z "$xdgInst" ] || [ "y" == "$xdgInst" ]; then
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
    if type systemctl &> /dev/null; then
        pageSec=1
        printf "${cyan}Systemd comes preinstalled with ${GREEN}SYSTEMD_PAGERSECURE=1${normal}.\n This means any pager without a 'secure mode' cant be used for ${CYAN}systemctl/journalctl${normal}.\n(Features that are fairly obscure and mostly less-specific in the first place -\n No editing (v), no examining (:e), no pipeing (|)...)\n It's an understandable concern to be better safe and sound, but this does constrain the user to ${CYAN}only using less.${normal}\n"
        reade -Q "YELLOW" -i "y" -p "${yellow}Set SYSTEMD_PAGERSECURE to 0? [Y/n]: " "n" page_sec
        if test "$page_sec" == "y"; then
            pageSec=0 
            if test -f /etc/sudoers; then 
                echo "Next $(tput setaf 1)sudo$(tput sgr0) will check for 'Defaults env_keep += \"SYSTEMD_PAGERSECURE\"' in /etc/sudoers"
                if ! sudo grep -q "Defaults env_keep += \"SYSTEMD_PAGERSECURE\"" /etc/sudoers; then
                    printf "${bold}${yellow}Sudo won't respect the user's SYSTEMD_PAGERSECURE environment. If you were to want to keep your userdefined less options or use a custom pager when using sudo with ${cyan}systemctl/journalctl${bold}${yellow}, you would need to always pass your environment using 'sudo -E'\n${normal}"
                    reade -Q "YELLOW" -i "y" -p "Change this behaviour permanently in /etc/sudoers? [Y/n]: " "n" sudrs
                    if test "$sudrs" == "y"; then
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
        reade -Q "YELLOW" -i "y" -p "Set systemd environment? [Y/n]: " "n" xdgInst
        if [ -z "$xdgInst" ] || [ "y" == "$xdgInst" ]; then
            sed 's/^#export SYSTEMD_PAGER=\(.*\)/export SYSTEMD_PAGER=\1/' -i $pathvr 
            if test "$pageSec" == 0; then
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

    if type libvirtd &> /dev/null; then
        sed -i 's/^#export LIBVIRT_DEFAULT_URI/export LIBVIRT_DEFAULT_URI/' $pathvr
    fi
   
    yes_edit_no environment-variables "$pathvr" "Install .environment.env in $HOME?" "edit" "GREEN"
    printf "It's recommended to logout and login again to notice a change for ${MAGENTA}.profile${normal} and any ${CYAN}.*shelltype*_profiles\n${normal}" 

fi 

#unset prmpt pathvr xdgInst
