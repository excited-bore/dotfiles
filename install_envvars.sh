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
        printf "\n${green}since file ${cyan}/root/.bash_profile${green} exists, ${cyan}bash${green} won't source ${magenta}/root/.profile${green} natively at login.\n${normal}"
        reade -q 'green' -i 'prof' -p "source $home/.profile in $home/.bash_profile or source $home/.environment.env directly in $home/.bash_profile? [prof/path/none]: " 'path none' bash_prof
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
            reade -q 'green' -i 'y' -p "source /root/.environment.env in /root/.bashrc? [y/n]: " 'n' bashrc
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
    shell_profiles="${magenta}\t- $home/.profile\n"
    shell_rcs="" 
    if test -f ~/.bash_profile; then
        shell_profiles="$shell_profiles${cyan}\t- $home/.bash_profile\n"
    fi
    if test -f ~/.bashrc; then
        shell_rcs="$shell_rcs${green}\t- $home/.bashrc\n"
    fi
    prmpt="file(s):\n$shell_profiles${normal} get sourced at login\nfile ${magenta}.profile${red} won't get sourced at login${normal} if ${cyan}.*shelltype*_profile${normal} exists\nfile(s):\n${cyan}$shell_rcs${normal} get sourced when starting a new *shelltype* shell\n"
    printf "$prmpt" 
    
    if ! grep -q "~/.environment.env" ~/.profile; then
        reade -q 'green' -i 'y' -p "link .environment.env in ~/.profile? [y/n]: " 'n' prof
        if test $prof == 'y'; then
            printf "\n[ -f ~/.environment.env ] && source ~/.environment.env\n\n" >> ~/.profile
        fi
    fi
    if test -f ~/.bash_profile; then
        printf "\n${green}since file ${cyan}$home/.bash_profile${green} exists, ${cyan}bash${green} won't source ${magenta}$home/.profile${green} natively at login.\n${normal}"
        reade -q 'green' -i 'prof' -p "source $home/.profile in $home/.bash_profile or source $home/.environment.env directly in $home/.bash_profile? [prof/path/none]: " 'path none' bash_prof
        if [[ $bash_prof =~ 'prof' ]]; then
            if grep -q '.bashrc' ~/.bash_profile && ! grep -q "~/.profile" ~/.bash_profile; then
                sed -i 's|\(\[ -f ~/.bashrc \] && source ~/.bashrc\)|\[ -f \~/.profile \] \&\& source \~/.profile\n\n\1\n|g' ~/.bash_profile
                sed -i 's|\(\[\[ -f ~/.bashrc \]\] && . ~/.bashrc\)|\[ -f \~/.profile \] \&\& source \~/.profile\n\n\1\n|g' ~/.bash_profile
            else 
                printf "\n[ -f ~/.environment.env ] && source ~/.profile\n\n" >> ~/.bash_profile
            fi
        elif test $bash_prof == 'path'; then
            if grep -q '.bashrc' ~/.bash_profile && ! grep -q "~/.environment.env" ~/.bash_profile; then
                sed -i 's|\(\[ -f ~/.bashrc \] && source ~/.bashrc\)|\[ -f \~/.environment.env \] \&\& source \~/.environment.env\n\n\1\n|g' ~/.bash_profile
                sed -i 's|\(\[\[ -f ~/.bashrc \]\] && . ~/.bashrc\)|\[ -f \~/.environment.env \] \&\& source \~/.environment.env\n\n\1\n|g' ~/.bash_profile
            else 
                printf "\n[ -f ~/.environment.env ] && source ~/.environment.env\n\n" >> ~/.bash_profile
            fi
        fi
        if test -f ~/.bashrc && ! grep -q "~/.environment.env" ~/.bashrc; then
            reade -q 'green' -i 'y' -p "source $home/.environment.env in $home/.bashrc? [y/n]: " 'n' bashrc
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
    
    if ! sudo grep -q '.environment.env' /root/.bashrc && ! sudo grep -q '.environment.env' $profile_r; then
        yes_edit_no environment-variables_r "$pathvr" "install .environment.env in /root/?" "edit" "yellow"; 
    fi 
}

pathvr=$(pwd)/envvars/.environment.env
if ! test -f $pathvr; then
    tmp=$(mktemp) && curl -o $tmp https://raw.githubusercontent.com/excited-bore/dotfiles/main/envvars/.environment.env
    pathvr=$tmp
fi

pre='y'
othr='n'
color='green'
prmpt='[y/n]: '

#echo "next $(tput setaf 1)sudo$(tput sgr0) check for /root/.environment.env' "
#if test -f ~/.environment.env && sudo test -f /root/.environment.env; then
#    pre='n' 
#    othr='y'
#    color='yellow'
#    prmpt='[n/y]: '
#fi


reade -q "$color" -i "$pre" -p "check existence/create '.environment.env' and link it to '.bashrc' in $home/ and /root/? $prmpt" "$othr" envvars

if [ "$envvars" == "y" ] && test "$1" == 'n'; then

    #comment out every export in .environment
    sed -i -e '/export/ s/^#*/#/' $pathvr
        
    # allow if checks
    sed -i 's/^#\[\[/\[\[/' $pathvr
    sed -i 's/^#type/type/' $pathvr

    # comment out fzf stuff
    sed -i 's/  --bind/ #--bind/' $pathvr
    sed -i 's/  --preview-window/ #--preview-window/' $pathvr
    sed -i 's/  --color/ #--color/' $pathvr

    # set tmpdir
    sed 's|#export tmpdir|export tmpdir|' -i $pathvr

    if ! grep -q '.environment.env' ~/.bashrc && ! grep -q '.environment.env' $profile; then
        yes_edit_no environment-variables "$pathvr" "install .environment.env in $home?" "edit" "green"
        printf "it's recommended to logout and login again to notice a change for ${magenta}.profile${normal} and any ${cyan}.*shelltype*_profiles\n${normal}" 
    fi

elif [ "$envvars" == "y" ]; then 
    
    #comment out every export in .environment
    sed -i -e '/export/ s/^#*/#/' $pathvr
        
    # allow if checks
    sed -i 's/^#\[\[/\[\[/' $pathvr
    sed -i 's/^#type/type/' $pathvr
    
    # comment out fzf stuff
    sed -i 's/  --bind/ #--bind/' $pathvr
    sed -i 's/  --preview-window/ #--preview-window/' $pathvr
    sed -i 's/  --color/ #--color/' $pathvr

    # set tmpdir
    sed 's|#export tmpdir|export tmpdir|' -i $pathvr

    if ! grep -q '.environment.env' ~/.bashrc && ! grep -q '.environment.env' $profile; then
        yes_edit_no environment-variables "$pathvr" "install .environment.env in $home?" "edit" "green"
        printf "it's recommended to logout and login again to notice a change for ${magenta}.profile${normal} and any ${cyan}.*shelltype*_profiles\n${normal}" 
    fi
    
    # package managers
    #reade -q "yellow" -i "y" -p "check and create dist,dist_base,arch,pm and wrapper? (distro, distro base, architecture, package manager and pm wrapper) [y/n]:" "n" dists
    #if [ "$dists" == "y" ]; then
    #   printf "not yet implemented\n"
    #fi
    
    # todo: non ugly values
    reade -q "green" -i "y" -p "set ls_colors with some predefined values? [y/n]: " "n" lsclrs
    if [ "$lsclrs" == "y" ] || [ -z "$lsclrs" ]; then
        sed 's/^#export ls_colors/export ls_colors/' -i $pathvr
    fi
    
    reade -q "green" -i "y" -p "set pager? (page reader) [y/n]: " "n" pgr
    if [ "$pgr" == "y" ] || [ -z "$pgr" ]; then
        # uncomment export pager=
        sed 's/^#export pager=/export pager=/' -i $pathvr
        
        pagers="more"
        prmpt="${green} \tless = default pager - basic, archaic but very customizable\n\tmore = preinstalled other pager - leaves text by default, less customizable (ironically)\n"
        if type pg &> /dev/null; then
            pagers="$pagers pg"
            prmpt="$prmpt \tpg = archaic and unintuitive like vi\n"
        fi
        if type most &> /dev/null; then
            pagers="$pagers most"
            prmpt="$prmpt \tmost = installed pager that is very customizable\n"
        fi
        if type bat &> /dev/null; then
            pagers="$pagers bat"
            prmpt="$prmpt \tbat = cat clone / pager wrapper with syntax highlighting\n"
            sed -i 's/#export bat=/export bat=/' $pathvr
        fi
        if type moar &> /dev/null; then
            pagers="$pagers moar"
            prmpt="$prmpt \tmoar = installed pager with an awesome default configuration\n"
            sed -i 's/#export moar=/export moar=/' $pathvr
        fi
        if type nvimpager &> /dev/null; then
            pagers="$pagers nvimpager"
            prmpt="$prmpt \tnvimpager = the pager that acts and feels like neovim. did you guess?\n"
        fi
        printf "$prmpt${normal}"
        
        reade -q "green" -i "less" -p "pager(less default)=" "$pagers" pgr2
        
        pgr2="$(where_cmd $pgr2)"
        sed -i 's|export pager=.*|export pager='"$pgr2"'|' $pathvr

        # set less options that system supports 
        sed -i 's|#export less=|export less=|g' $pathvr
        if type man &> /dev/null; then
            lss=$(cat $pathvr | grep 'export less="*"' | sed 's|export less="\(.*\)"|\1|g')
            lss_n=""
            for opt in ${lss}; do
                opt1=$(echo "$opt" | sed 's|--\(\)|\1|g' | sed 's|\(\)\=.*|\1|g')
                if (man less | grep -fq "${opt1}") 2> /dev/null; then
                    lss_n="$lss_n $opt"
                fi
            done
            sed -i "s|export less=.*|export less=\" $lss_n\"|g" $pathvr
            unset lss lss_n opt opt1
        fi 
        #sed -i 's/#export lessedit=/export lessedit=/' .environment.env

        # set moar options
        sed -i 's/#export moar=/export moar=/' $pathvr
        if test "$(basename ""$pgr2"")" == "bat" && type moar &> /dev/null || test "$(basename ""$pgr2"")" == "bat" && type nvimpager &> /dev/null ; then
            pagers=""
            prmpt="${cyan}bat is a pager wrapper that defaults to less except if bat_pager is set\n\t${green}less = default pager - basic, archaic but very customizable\n"
            if type moar &> /dev/null; then
                pagers="$pagers moar"
                prmpt="$prmpt \tmoar = custom pager with an awesome default configuration\n"
            fi
            if type nvimpager &> /dev/null; then
                pagers="$pagers nvimpager"
                prmpt="$prmpt \tnvimpager = the pager that acts and feels like neovim. did you guess?\n"
            fi
            printf "$prmpt${normal}"
            reade -q "green" -i "less" -p "bat_pager(less default)=" "$pagers" pgr2
            pgr2="$(where_cmd $pgr2)"
            [[ "$pgr2" =~ "less" ]] && pgr2="$pgr2 \$less --line-numbers"  
            [[ "$pgr2" =~ "moar" ]] && pgr2="$pgr2 \$moar --no-linenumbers"  
            sed 's/^#export bat_pager=/export bat_pager=/' -i $pathvr
            sed -i "s|^export bat_pager=.*|export bat_pager=\"$pgr2\"|" $pathvr
        fi
    fi
    unset prmpt
    
    if type nvim &> /dev/null; then
        reade -q "green" -i "y" -p "set neovim as manpager? [y/n]: " "n" manvim
        if [ "$manvim" == "y" ]; then
           sed -i 's|.export manpager=.*|export manpager='\''nvim +man!'\''|g' $pathvr 
        fi
    fi

    reade -q "green" -i "y" -p "set editor and visual? [y/n]: " "n" edtvsl
    if [ "$edtvsl" == "y" ] || [ -z "$edtvsl" ]; then
        if type vi &> /dev/null; then
            editors="vi $editors"
            prmpt="$prmpt \tvi = archaic and non-userfriendly editor\n"
        fi
        if type nano &> /dev/null; then 
            editors="nano"
            prmpt="${green}\tnano = default editor - basic, but userfriendly\n" 
        fi 
        if type micro &> /dev/null; then
            editors="micro $editors"
            prmpt="$prmpt \tmicro = relatively good out-of-the-box editor - decent keybindings, yet no customizations\n"
        fi
        if type ne &> /dev/null; then
            editors="ne $editors"
            prmpt="$prmpt \tnice editor = relatively good out-of-the-box editor - decent keybindings, yet no customizations\n"
        fi
        if type vim &> /dev/null; then
            editors="vim $editors"
            prmpt="$prmpt \tvim = the one and only true modal editor - not userfriendly, but many features (maybe even too many) and greatly customizable\n"
            sed -i "s|#export myvimrc=|export myvimrc=|g" $pathvr
            sed -i "s|#export mygvimrc=|export mygvimrc=|g" $pathvr
        fi
        if type nvim &> /dev/null; then                                  
            editors="nvim $editors"
            prmpt="$prmpt \tnvim (neovim) = a better vim? - faster and less buggy then regular vim, even a little userfriendlier\n"
            sed -i "s|#export myvimrc=|export myvimrc=|g" $pathvr
            sed -i "s|#export mygvimrc=|export mygvimrc=|g" $pathvr
        fi
        if type emacs &> /dev/null; then
            editors="emacs $editors"
            prmpt="$prmpt \temacs = one of the oldest and versatile editors - modal and featurerich, but overwhelming as well\n"
        fi
        if type code &> /dev/null; then
            editors="$editors code"
            prmpt="$prmpt \tcode = visual studio code - modern standard for most when it comes to text editors (warning: does not work well when paired with sudo)\n"
        fi
        printf "$prmpt${normal}"
        touch $tmpdir/editor-outpt
        # redirect output to file in subshell (mimeopen gives output but also starts read. this cancels read). in tmp because that gets cleaned up
        (echo "" | mimeopen -a editor-check.sh &> $tmpdir/editor-outpt)
        editors="$(cat $tmpdir/editor-outpt | awk 'nr > 2' | awk '{if (prev_1_line) print prev_1_line; prev_1_line=prev_line} {prev_line=$nf}' | sed 's|[()]||g' | tr -s [:space:] \\n | uniq | tr '\n' ' ') $editors"
        editors="$(echo $editors | tr ' ' '\n' | sort -u)"
        prmpt="found editors using ${cyan}mimeopen${normal} (non definitive list): ${green}\n"
        for i in $editors; do
            prmpt="$prmpt\t - $i\n"
        done
        prmpt="$prmpt${normal}"

        frst="$(echo $editors | awk '{print $1}')" 
        editors_p="$(echo $editors | sed "s/\<$frst\> //g")" 
        #frst="$(echo $compedit | awk '{print $1}')"
        #compedit="$(echo $compedit | sed "s/\<$frst\> //g")"
        printf "$prmpt"
        reade -q "green" -i "$frst" -p "editor (terminal - $frst default)=" "$editors_p" edtor
        edtor="$(where_cmd $edtor)"
        if [[ "$edtor" =~ "emacs" ]]; then
            edtor="$edtor -nw"
        fi
        sed -i 's|#export editor=.*|export editor='$edtor'|g' $pathvr
        
        # make .txt file and output file
         
        reade -q 'cyan' -i 'n' -p "set visual to '\\\\\$editor'? (otherwise set manually again) [n/y]: " 'y' vis_ed
        if test $vis_ed == 'y'; then
            sed -i 's|#export visual=|export visual=|g' $pathvr
            sed -i 's|export visual=.*|export visual=$editor|g' $pathvr
        else
            prmpt="found visual editors using ${cyan}mimeopen${normal} (non definitive list): ${green}\n"
            for i in $editors; do
                prmpt="$prmpt\t - $i\n"
            done
            prmpt="$prmpt${normal}"
            #frst="$(echo $compedit | awk '{print $1}')"
            #compedit="$(echo $compedit | sed "s/\<$frst\> //g")"
            printf "$prmpt"

            reade -q "green" -i "$frst" -p "visual (gui editor - $frst default)=" "$editors_p" vsual
            vsual="$(where_cmd $vsual)"
            sed -i 's|#export visual=|export visual=|g' $pathvr
            sed -i 's|export visual=.*|export visual='"$vsual"'|g' $pathvr
        fi
        
        unset vis_ed

        if grep -q "#export sudo_editor" $pathvr; then
            reade -q "green" -i "y" -p "set sudo_editor to \\\\\$editor? [y/n]: " "n" sud_edt
            if test "$sud_edt" == "y"; then
                sed -i 's|#export sudo_editor.*|export sudo_editor=$editor|g' $pathvr
            fi
        fi
        unset sud_edit

        if grep -q "#export sudo_visual" $pathvr; then
            printf "!! warning: certain visual code editors (like ${cyan}'visual studio code'${normal}) don't work properly when using ${red}sudo${normal}\nit might be better to keep using \$editor depending on what \$visual is configured as\n" 
            reade -q "green" -i "y" -p "set sudo_visual to \\\\\$editor? [y/n]: " "n" sud_vis
            if test "$sud_vis" == "y"; then
                sed -i 's|#export sudo_visual.*|export sudo_visual=$editor|g' $pathvr
            else 
                reade -q "green" -i "y" -p "set sudo_visual to \\\\\$visual? [y/n]: " "n" sud_edt
                if test "$sud_vis" == "y"; then
                    sed -i 's|#export sudo_visual.*|export sudo_visual=$visual|g' $pathvr
                fi     
            fi
        fi
        unset sud_vis

        if test -f /etc/sudoers; then 
            echo "next $(tput setaf 1)sudo$(tput sgr0) will check for 'defaults env_keep += \"pager\"' in /etc/sudoers"
            if ! sudo grep -q "defaults env_keep += \"pager\"" /etc/sudoers; then
                printf "${bold}${yellow}sudo by default does not respect the user's pager environment. if you were to want to use a custom pager with sudo (except with ${cyan}systemctl/journalctl${bold}${yellow}, more on that later) you would need to always pass your environment using 'sudo -e'\n${normal}"
                reade -q "yellow" -i "y" -p "change this behaviour permanently in /etc/sudoers? [y/n]: " "n" sudrs
                if test "$sudrs" == "y"; then
                    sudo sed -i '1s/^/defaults env_keep += "pager systemd_pagersecure"\n/' /etc/sudoers
                    echo "added ${red}'defaults env_keep += \"pager systemd_pagersecure\"'${normal} to /etc/sudoers"
                fi
            fi

            echo "next $(tput setaf 1)sudo$(tput sgr0) will check for 'defaults env_keep += \"editor\"' and 'defaults env_keep += \"visual\"' in /etc/sudoers"
            if ! sudo grep -q "defaults env_keep += \"editor\"" /etc/sudoers || ! sudo grep -q "defaults env_keep += \"visual\""  /etc/sudoers; then
                printf "${bold}${yellow}sudo by default does not respect the user's editor/visual environment and sudo_editor is not always checked by programs.\nif you were to want edit root crontabs (sudo crontab -e), you would get vi (unless using 'sudo -e' to pass your environment)\n${normal}"
                reade -q "yellow" -i "y" -p "change this behaviour permanently in /etc/sudoers? (run 'man --pager='less -p ^security' less' if you want to see the potential security holes when using less) [y/n]: " "n" sudrs
                if test "$sudrs" == "y"; then
                    if ! sudo grep -q "defaults env_keep += \"editor\"" /etc/sudoers ; then 
                        sudo sed -i '1s/^/defaults env_keep += "editor"\n/' /etc/sudoers
                        echo "added ${red}'defaults env_keep += \"editor\"'${normal} to /etc/sudoers"
                    fi
                    if ! sudo grep -q "defaults env_keep += \"visual\"" /etc/sudoers; then 
                        sudo sed -i '1s/^/defaults env_keep += "visual"\n/' /etc/sudoers
                        echo "added ${red}'defaults env_keep += \"visual\"'${normal} to /etc/sudoers"
                    fi
                fi
            fi
        fi 
    fi
    unset edtvsl compedit frst editors prmpt

    # set display
    if type nmcli &> /dev/null; then
        addr=$(nmcli device show | grep ip4.addr | awk 'nr==1{print $2}'| sed 's|\(.*\)/.*|\1|')
    fi
    #reade -q "green" -i "n" -p "set display to ':$(addr).0'? [y/n]:" "n" dsply
    if [[ $- =~ i ]] && [[ -n "$ssh_tty" ]]; then
        reade -q "yellow" -i "n" -p "detected shell is ssh. for x11, it's more reliable performance to dissallow shared clipboard (to prevent constant hanging). set display to 'localhost:10.0'? [y/n]:" "n" dsply
        if [ "$dsply" == "y" ] || [ -z "$dsply" ]; then
            sed -i "s|.export display=.*|export display=\"localhost:10.0\"|" $pathvr
        fi
    fi
    unset dsply

    if type go &> /dev/null; then
        sed -i 's|#export gopath|export gopath|' $pathvr 
    fi
    unset snapvrs

    if type snap &> /dev/null; then
        sed -i 's|#export path=/bin/snap|export path=/bin/snap|' $pathvr 
    fi
    unset snapvrs
    
    if type flatpak &> /dev/null; then
        sed -i 's|#export flatpak|export flatpak|' $pathvr 
        sed -i 's|#\(export path=$path:$home/.local/bin/flatpak\)|\1|g' $pathvr
    fi
    unset snapvrs

    # todo do something for flatpak  (xdg_data_dirs)
    # check if xdg installed
    if type xdg-open &> /dev/null ; then
        prmpt="${green}this will set xdg environment variables to their respective defaults\n\
        xdg is related to default applications\n\
        setting these could be usefull when installing certain programs \n\
        defaults:\n\
        - xdg_cache_home=$home/.cache\n\
        - xdg_config_home=$home/.config\n\
        - xdg_config_dirs=/etc/xdg\n\
        - xdg_data_home=$home/.local/share\n\
        - xdg_data_dirs=/usr/local/share/:/usr/share\n\
        - xdg_state_home=$home/.local/state\n"
        printf "$prmpt${normal}"
        reade -q "green" -i "y" -p "set xdg environment? [y/n]: " "n" xdginst
        if [ -z "$xdginst" ] || [ "y" == "$xdginst" ]; then
            sed 's/^#export xdg_cache_home=\(.*\)/export xdg_cache_home=\1/' -i $pathvr 
            sed 's/^#export xdg_config_home=\(.*\)/export xdg_config_home=\1/' -i $pathvr
            sed 's/^#export xdg_config_dirs=\(.*\)/export xdg_config_dirs=\1/' -i $pathvr
            sed 's/^#export xdg_data_home=\(.*\)/export xdg_data_home=\1/' -i $pathvr    
            sed 's/^#export xdg_data_dirs=\(.*\)/export xdg_data_dirs=\1/' -i $pathvr
            sed 's/^#export xdg_state_home=\(.*\)/export xdg_state_home=\1/' -i $pathvr
            sed 's/^#export xdg_runtime_dir=\(.*\)/export xdg_runtime_dir=\1/' -i $pathvr
        fi
    fi
    unset xdginst


    # todo: check around for other systemdvars 
    # check if systemd installed
    if type systemctl &> /dev/null; then
        pagesec=1
        printf "${cyan}systemd comes preinstalled with ${green}systemd_pagersecure=1${normal}.\n this means any pager without a 'secure mode' cant be used for ${cyan}systemctl/journalctl${normal}.\n(features that are fairly obscure and mostly less-specific in the first place -\n no editing (v), no examining (:e), no pipeing (|)...)\n it's an understandable concern to be better safe and sound, but this does constrain the user to ${cyan}only using less.${normal}\n"
        reade -q "yellow" -i "y" -p "${yellow}set systemd_pagersecure to 0? [y/n]: " "n" page_sec
        if test "$page_sec" == "y"; then
            pagesec=0 
            if test -f /etc/sudoers; then 
                echo "next $(tput setaf 1)sudo$(tput sgr0) will check for 'defaults env_keep += \"systemd_pagersecure\"' in /etc/sudoers"
                if ! sudo grep -q "defaults env_keep += \"systemd_pagersecure\"" /etc/sudoers; then
                    printf "${bold}${yellow}sudo won't respect the user's systemd_pagersecure environment. if you were to want to keep your userdefined less options or use a custom pager when using sudo with ${cyan}systemctl/journalctl${bold}${yellow}, you would need to always pass your environment using 'sudo -e'\n${normal}"
                    reade -q "yellow" -i "y" -p "change this behaviour permanently in /etc/sudoers? [y/n]: " "n" sudrs
                    if test "$sudrs" == "y"; then
                        sudo sed -i '1s/^/defaults env_keep += "systemd_pagersecure"\n/' /etc/sudoers
                        echo "added ${red}'defaults env_keep += \"systemd_pagersecure\"'${normal} to /etc/sudoers"
                    fi
                fi
            fi     
        fi
        prmpt="${yellow}this will set systemd environment-variables\n\
        when setting a new pager for systemd or changing logging specifics\n\
        defaults:\n\
        - systemd_pager=\$pager\n\
        - systemd_colors=256\n\
        - systemd_pagersecure=$pagesec\n\
        - systemd_less=\"frxmk\"\n\
        - systemd_log_level=\"warning\"\n\
        - systemd_log_color=\"true\"\n\
        - systemd_log_time=\"true\"\n\
        - systemd_log_location=\"true\"\n\
        - systemd_log_tid=\"true\"\n\
        - systemd_log_target=\"auto\"\n"
        printf "$prmpt${normal}"
        reade -q "yellow" -i "y" -p "set systemd environment? [y/n]: " "n" xdginst
        if [ -z "$xdginst" ] || [ "y" == "$xdginst" ]; then
            sed 's/^#export systemd_pager=\(.*\)/export systemd_pager=\1/' -i $pathvr 
            if test "$pagesec" == 0; then
                sed 's/^#export systemd_pagersecure=\(.*\)/export systemd_pagersecure=0/' -i $pathvr
            else
                sed 's/^#export systemd_pagersecure=\(.*\)/export systemd_pagersecure=1/' -i $pathvr
            fi
            sed 's/^#export systemd_colors=\(.*\)/export systemd_colors=\1/' -i $pathvr
            sed 's/^#export systemd_less=\(.*\)/export systemd_less=\1/' -i $pathvr    
            sed 's/^#export systemd_log_level=\(.*\)/export systemd_log_level=\1/' -i $pathvr
            sed 's/^#export systemd_log_time=\(.*\)/export systemd_log_time=\1/' -i $pathvr
            sed 's/^#export systemd_log_location=\(.*\)/export systemd_log_location=\1/' -i $pathvr
            sed 's/^#export systemd_log_tid=\(.*\)/export systemd_log_tid=\1/' -i $pathvr
            sed 's/^#export systemd_log_target=\(.*\)/export systemd_log_target=\1/' -i $pathvr
        fi
    fi
   
    if test -d $home/.fzf/bin; then
        sed -i 's|^#export path=$path:$home/.fzf/bin|export path=$path:$home/.fzf/bin|g' $pathvr
    fi

    if type libvirtd &> /dev/null; then
        sed -i 's/^#export libvirt_default_uri/export libvirt_default_uri/' $pathvr
    fi
   
    yes_edit_no environment-variables "$pathvr" "install .environment.env in $home?" "edit" "green"
    printf "it's recommended to logout and login again to notice a change for ${magenta}.profile${normal} and any ${cyan}.*shelltype*_profiles\n${normal}" 

fi 

#unset prmpt pathvr xdgInst
