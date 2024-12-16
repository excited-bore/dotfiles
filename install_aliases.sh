if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . checks/check_system.sh
fi

if ! test -f aliases/.bash_aliases.d/00-rlwrap_scripts.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/00-rlwrap_scripts.sh)" 
else
    . ./aliases/.bash_aliases.d/00-rlwrap_scripts.sh
fi

pre='both'
othr='exit intr n'
color='GREEN'
prmpt='[Both/exit/intr/n]: '

echo "Next $(tput setaf 1)sudo$(tput sgr0) will check for terminate background processes /root/.bashrc' "
if grep -q "trap '! \[ -z \"\$(jobs -p)\" ] && kill -9 \$(jobs -p.*" ~/.bashrc || sudo grep -q "trap '! [ -z \"\$(jobs -p)\" ] && kill -9 \$(jobs -p.*" /root/.bashrc; then
    pre='n' 
    othr='both exit intr'
    color='YELLOW'
    prmpt='[N/both/exit/intr]: '
fi 

reade -Q "$color" -i "$pre $othr" -p "Send kill signal to background processes when exiting (Ctrl-q) / interrupting (Ctrl-c) for $USER? $prmpt" int_r
if ! [ $int_r  == "n" ]; then
    if test $int_r == 'both'; then
        sig='INT EXIT'  
    elif test $int_r == 'exit'; then
        sig='EXIT'  
    elif test $int_r == 'intr'; then
        sig='INT'  
    fi
    if grep -q "trap '! \[ -z \"\$(jobs -p)\" ] && kill -9 \$(jobs -p.*" ~/.bashrc; then 
        sed -i '/trap '\''! \[ -z "$(jobs -p)" \] \&\& kill -9 "$(jobs -p.*/d' ~/.bashrc  
    fi 
    printf "trap '! [ -z \"\$(jobs -p)\" ] && kill -9 \$(jobs -p | tr \"\\\n\" \" \")' $sig\n" >> ~/.bashrc
        
    pre='same'
    othr='both exit intr n'
    color='GREEN'
    prmpt='[Same/both/exit/intr/n]: '
    echo "Next $(tput setaf 1)sudo$(tput sgr0) will check for terminate background processes /root/.bashrc' "
     
    if sudo grep -q "trap '! \[ -z \"\$(jobs -p)\" ] && kill -9 \"\$(jobs -p.*" /root/.bashrc; then
        pre='n' 
        othr='same both exit intr'
        color='YELLOW'
        prmpt='[N/same/both/exit/intr]: '
    fi 
    reade -Q "$color" -i "$pre $othr" -p "Send kill signal to background processes when exiting (Ctrl-q)/interrupting (Ctrl-c) for root? $prmpt" int_r 
    if ! [ $int_r  == "n" ]; then
        if test $int_r == 'both'; then
            sig='INT EXIT'  
        elif test $int_r == 'exit'; then
            sig='EXIT'  
        elif test $int_r == 'intr'; then
            sig='INT'  
        fi

        if  sudo grep -q "trap '! \[ -z \"\$(jobs -p)\" ] && kill -9 \$(jobs -p.*" /root/.bashrc; then 
            sudo sed -i '/trap '\''! \[ -z "$(jobs -p)" \] \&\& kill -9 "$(jobs -p.*/d' /root/.bashrc 
        fi  
        printf "trap '! [ -z \"\$(jobs -p)\" ] && kill -9 \"\$(jobs -p | tr \\\n\"  \" \")' $sig\n" | sudo tee -a /root/.bashrc &> /dev/null
    fi     
fi
unset int_r sig


genr=aliases/.bash_aliases.d/general.sh
genrc=aliases/.bash_completion.d/general
if ! test -f aliases/.bash_aliases.d/general.sh; then
    tmp=$(mktemp) && curl -o $tmp https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/general.sh 
    tmp1=$(mktemp) && curl -o $tmp https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliasases/.bash_completion.d/general 
    genr=$tmp
    genrc=$tmp1
fi

readyn -p "Install general.sh at ~/? (aliases related to general actions - cd/mv/cp/rm + completion script replacement for 'read -e')" ansr         

if test $ansr == "y"; then
    if test -f ~/.environment.env; then
        sed -i 's|^export TRASH_BIN_LIMIT=|export TRASH_BIN_LIMIT=|g' ~/.environment.env
    fi

    #if type gio &> /dev/null; then 
    #    readyn -p "Set cp/mv (when overwriting) to backup files? (will also trash backups) "" ansr         
    #    if [ "$ansr" != "y" ]; then
    #        sed -i 's|^alias cp="cp-trash -rv"|#alias cp="cp-trash -rv"|g' $genr
    #        sed -i 's|^alias mv="mv-trash -v"|#alias mv="mv-trash -v"|g' $genr
    #    else
    #        sed -i 's|.*alias cp="cp-trash -rv"|alias cp="cp-trash -rv"|g' $genr
    #        sed -i 's|.*alias mv="mv-trash -v"|alias mv="mv-trash -v"|g' $genr
    #    fi
    #    unset ansr
    #        
    #fi 

    if type eza &>/dev/null; then
        readyn -p "${CYAN}eza${GREEN} installed. Set ls (list items directory) to 'eza'?" eza_verb
        if test $eza_verb == 'y'; then

            ezalias="eza"

            readyn -p "Add '--header' as an option for 'eza'? (explanation of table content at top)" eza_hdr
            if test $eza_hdr == 'y'; then
                ezalias=$ezalias" --header" 
            fi
            
            readyn -p "Always color 'eza' output?" eza_clr
            if test $eza_clr == 'y'; then
                ezalias=$ezalias" --color=always" 
            fi
             
            readyn -p "Always show filetype/directory icons for items with 'eza'? " eza_icon
            if test $eza_icon == 'y'; then
                ezalias=$ezalias" --icons=always" 
            fi
              
            sed -i 's|.*alias ls=".*|alias ls="'"$ezalias"'"|g' $genr  
            unset ezalias eza_clr eza_hdr eza_icon 
        fi
    fi

        readyn -p "Set cp alias?" cp_all

        if type xcp &> /dev/null; then 
            readyn -p "${CYAN}xcp${GREEN} installed. Use xcp instead of cp?" cp_xcp
            if test $cp_xcp == 'y'; then
                cp_xcp='xcp --glob ' 
            else
                cp_xcp="cp" 
            fi
 
            readyn -p "Be recursive? (Recursive means copy everything inside directories without aborting)" cp_r
            if test "$cp_r" == 'y'; then
                cp_r='--recursive ' 
            else
                cp_r="" 
            fi 
            readyn -p "Be verbose? (All info about copying process)" cp_v
            if test "$cp_v" == 'y'; then
                cp_v='--verbose ' 
            else
                cp_v="" 
            fi

            readyn -n -p "Never overwrite already present files?" cp_ov
            if test $cp_ov == 'y'; then
                cp_ov='--no-clobber ' 
            else
                cp_ov="" 
            fi
            
            readyn -p "Lookup files/directories of symlinks?" cp_der
            if test $cp_der == 'y'; then
                cp_der='--dereference ' 
            else
                cp_der="" 
            fi
             

            sed -i 's|^alias cp=".*|alias cp="'"$cp_xcp $cp_r $cp_v $cp_ov $cp_der"' --"|g' $genr

            unset cp_all cp_xcp cp_v cp_ov   
    fi 
     
    readyn -p "Set rm (remove) to always be verbose?" rm_verb
     
    prompt="${green}    - Force remove, recursively delete given directories (enable deletion of direction without deleting every file in directory first) and ${bold}always give at least one prompt before removing?${normal}${green}
    - Force remove, ${YELLOW}don't${normal}${green} recursively look for files and give a prompt not always, but if removing 3 or more files/folder?
    - Recursively look without a prompt?${normal}\n" 
    prompt2="Rm = [Recur-prompt/none/prompt/recur"       
    pre="recur-prompt" 
    ansrs="none prompt recur" 

    if type rm-prompt &> /dev/null; then 
        prompt="${GREEN}    - Alias 'rm' to use 'rm-prompt' which lists all files and directories before removing them ${normal}\n$prompt"
        prompt2="Rm = [Rm-prompt/recur-prompt/none/prompt/recur"       
        pre="rm-prompt" 
        ansrs="recur-prompt none prompt recur " 
    fi 
    
    if type gio &> /dev/null; then 
        prompt="$prompt${green}    - Don't use 'rm' but use 'gio trash' to trash files (leaving a copy in ${cyan}trash:///${green} after 'removing')${normal}\n"
        prompt2="$prompt2/trash]: "       
        ansrs="none prompt recur trash" 
    else  
        prompt2="$prompt2]: "       
    fi 

    printf "${CYAN}Set rm (remove) to:\n$prompt" 
    reade -Q "GREEN" -i "$pre $ansrs" -p "$prompt2" ansr 
    if $([ "$ansr" == "none" ] || [ -z "$ansr" ]) && test "$rm_verb" == 'n'; then
        sed -i 's|^alias rm="|#alias rm="|g' $genr
    else
        sed -i 's|.*alias cp="cp-trash -rv"|alias cp="cp-trash -rv"|g' $genr
        sed -i 's|.*alias mv="mv-trash -v"|alias mv="mv-trash -v"|g' $genr
    fi
    
    if type bat &> /dev/null; then
        readyn -n -p "Set 'cat' as alias for 'bat'?" cat
        if [ "$cat" == "y" ]; then
            sed -i 's|.*alias cat="bat"|alias cat="bat"|g' $genr
        else
            sed -i 's|^alias cat="bat"|#alias cat="bat"|g' $genr
        fi
    fi
    unset cat
 
   if type ack &> /dev/null; then
        readyn -n -p "Set 'ack' as alias for 'grep'?" ack_gr
        if [ "$ack_gr" == "y" ]; then
            sed -i 's|.*alias grep="ack"|alias ack="ack"|g' $genr
        else
            sed -i 's|^alias grep="ack"|alias grep="grep --color=always"|g' $genr
        fi
    fi
    unset ack_gr

    rver=$(echo $(ruby --version) | awk '{print $2}' | cut -d. -f-2)'.0'
    paths=$(gem environment | awk '/- GEM PATH/{flag=1;next}/- GEM CONFIGURATION/{flag=0}flag' | sed 's|     - ||g' | paste -s -d ':')
    if grep -q "GEM" $ENVVAR; then
        sed -i "s|.export GEM_|export GEM_|g" $ENVVAR 
        sed -i "s|.export PATH=\$PATH:\$GEM_PATH|export PATH=\$PATH:\$GEM_PATH|g" $ENVVAR
        sed -i "s|export GEM_HOME=.*|export GEM_HOME=$HOME/.gem/ruby/$rver|g" $ENVVAR
        sed -i "s|export GEM_PATH=.*|export GEM_PATH=$paths|g" $ENVVAR
        sed -i 's|export PATH=$PATH:$GEM_PATH.*|export PATH=$PATH:$GEM_PATH:$GEM_HOME/bin|g' $ENVVAR
    else
        printf "export GEM_HOME=$HOME/.gem/ruby/$rver\n" >> $ENVVAR
        printf "export GEM_PATH=$paths\n" >> $ENVVAR
        printf "export PATH=\$PATH:\$GEM_PATH:\$GEM_HOME/bin\n" >> $ENVVAR
    fi

    general_r(){ 
        sudo cp -fv $genr /root/.bash_aliases.d/;
        sudo cp -fv $genrc /root/.bash_completion.d/;
    }
    general(){
        cp -fv $genr ~/.bash_aliases.d/
        cp -fv $genrc ~/.bash_completion.d/
        yes_edit_no general_r "$genr $genrc" "Install general.sh at /root/?" "yes" "YELLOW"; }
    yes_edit_no general "$genr $genrc" "Install general.sh at ~/?" "yes" "GREEN"
fi

update_sysm=aliases/.bash_aliases.d/update-system.sh
reade=rlwrap-scripts/reade
readyn=rlwrap-scripts/readyn
pacmn=aliases/.bash_aliases.d/package_managers.sh
test $distro == "Manjaro" && manjaro=aliases/.bash_aliases.d/manjaro.sh
type systemctl &> /dev/null && systemd=aliases/.bash_aliases.d/systemctl.sh
type sudo &> /dev/null && dosu=aliases/.bash_aliases.d/sudo.sh
type git &> /dev/null && gits=aliases/.bash_aliases.d/git.sh
type ssh &> /dev/null && sshs=aliases/.bash_aliases.d/ssh.sh
ps1=aliases/.bash_aliases.d/PS1_colours.sh
variti=aliases/.bash_aliases.d/variety.sh
type python &> /dev/null && pthon=aliases/.bash_aliases.d/python.sh
if ! test -d aliases/.bash_aliases.d/; then
    tmp1=$(mktemp) && curl -o $tmp https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/update-system.sh && update_sysm=$tmp1
    tmp4=$(mktemp) && curl -o $tmp4 https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/package_managers.sh && pacmn=$tmp4
    test $distro == "Manjaro" && tmp7=$(mktemp) && curl -o $tmp7 https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/manjaro.sh && manjaro=$tmp7
    type systemctl &> /dev/null && tmp2=$(mktemp) && curl -o $tmp2 https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/systemctl.sh && systemd=$tmp2
    type sudo &> /dev/null && tmp3=$(mktemp) && curl -o $tmp3 https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/sudo.sh && dosu=$tmp3
    type git &> /dev/null && tmp10=$(mktemp) && curl -o $tmp10 https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/git.sh && gits=$tmp5
    type ssh &> /dev/null && tmp5=$(mktemp) && curl -o $tmp5 https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/ssh.sh && sshs=$tmp5
    tmp6=$(mktemp) && curl -o $tmp6 https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/ps1.sh && ps1=$tmp6
    tmp8=$(mktemp) && curl -o $tmp8 https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/variety.sh && variti=$tmp8
    type python &> /dev/null && tmp9=$(mktemp) && curl -o $tmp9 https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/python.sh && pthon=$tmp9
fi 

update_sysm_r(){ 
    sudo cp -fv $update_sysm /root/.bash_aliases.d/;
    sudo sed -i '/SYSTEM_UPDATED="TRUE"/d' /root/.bash_aliases.d/update-system.sh
}
update_sysm(){
    cp -fv $update_sysm ~/.bash_aliases.d/
    sed -i '/SYSTEM_UPDATED="TRUE"/d' ~/.bash_aliases.d/update-system.sh
    yes_edit_no update_sysm_r "$update_sysm" "Install update-system.sh at /root/.bash_aliases.d//?" "yes" "YELLOW";
}
yes_edit_no update_sysm "$update_sysm" "Install update-system.sh at ~/.bash_aliases.d/? (Global system update function)?" "yes" "GREEN"

packman_r(){ 
    sudo cp -fv $pacmn /root/.bash_aliases.d/
}
packman(){
    cp -fv $pacmn ~/.bash_aliases.d/
    yes_edit_no packman_r "$pacmn" "Install package_managers.sh at /root/.bash_aliases.d/?" "yes" "YELLOW" 
}
yes_edit_no packman "$pacmn" "Install package_managers.sh at ~/.bash_aliases.d/ (package manager aliases)? " "yes" "GREEN"

reade_r(){ 
    sudo cp -fv $reade $readyn /root/.bash_aliases.d/
}
readei(){
    cp -fv $reade $readyn ~/.bash_aliases.d/
    yes_edit_no reade_r "$reade $readyn" "Install reade and readyn at /root/.bash_aliases.d/?" "yes" "YELLOW" 
}
yes_edit_no readei "$reade $readyn" "Install reade and readyn at ~/.bash_aliases.d/ (rlwrap/read functions)? " "yes" "GREEN"



if [ "$distro" == "Manjaro" ] ; then
    manj_r(){ 
        sudo cp -fv $manjaro /root/.bash_aliases.d/; 
    }
    manj(){
        cp -fv $manjaro ~/.bash_aliases.d/
        yes_edit_no manj_r "$manjaro" "Install manjaro.sh at /root/.bash_aliases.d/?" "yes" "YELLOW" 
    }
    yes_edit_no manj "$manjaro" "Install manjaro.sh at ~/.bash_aliases.d/ (manjaro specific aliases)? " "yes" "GREEN"
fi


systemd_r(){ 
    sudo cp -fv $systemd /root/.bash_aliases.d/;
}
systemd(){
    cp -fv $systemd ~/.bash_aliases.d/
    yes_edit_no systemd_r "$systemd" "Install systemctl.sh at /root/.bash_aliases.d/?" "yes" "YELLOW"; }
yes_edit_no systemd "$systemd" "Install systemctl.sh at ~/.bash_aliases.d/? (systemctl aliases/functions)?" "yes" "GREEN"
    

dosu_r(){ 
    sudo cp -fv $dosu /root/.bash_aliases.d/ ;
}    

dosu(){ 
    cp -fv $dosu ~/.bash_aliases.d/;
    yes_edit_no dosu_r "$dosu" "Install sudo.sh at /root/.bash_aliases.d/?" "yes" "YELLOW"; }
yes_edit_no dosu "$dosu" "Install sudo.sh at ~/.bash_aliases.d/ (sudo aliases)?" "yes" "GREEN"


git_r(){ 
    sudo cp -fv $gits /root/.bash_aliases.d/; 
}
gith(){
    cp -fv $gits ~/.bash_aliases.d/
    yes_edit_no git_r "$gits" "Install git.sh at /root/.bash_aliases.d/?" "yes" "YELLOW" 
}
yes_edit_no gith "$gits" "Install git.sh at ~/.bash_aliases.d/ (git aliases)? " "yes" "GREEN"

ssh_r(){ 
    sudo cp -fv $sshs /root/.bash_aliases.d/; 
}
sshh(){
    cp -fv $sshs ~/.bash_aliases.d/
    yes_edit_no ssh_r "$sshs" "Install ssh.sh at /root/.bash_aliases.d/?" "yes" "YELLOW" 
}
yes_edit_no sshh "$sshs" "Install ssh.sh at ~/.bash_aliases.d/ (ssh aliases)? " "yes" "GREEN"


ps1_r(){ 
    sudo cp -fv $ps1 /root/.bash_aliases.d/; 
}
ps11(){
    cp -fv $ps1 ~/.bash_aliases.d/
    yes_edit_no ps1_r "$ps1" "Install PS1_colours.sh at /root/.bash_aliases.d/?" "yes" "YELLOW" 
}
yes_edit_no ps11 "$ps1" "Install PS1_colours.sh at ~/.bash_aliases.d/ (Coloured command prompt)? " "yes" "GREEN"

if type python &> /dev/null; then
    pthon(){
        cp -fv $pthon ~/.bash_aliases.d/
    }
    yes_edit_no pthon "$pthon" "Install python.sh at ~/.bash_aliases.d/ (aliases for a python development)? " "yes" "GREEN" 
fi

# Variety aliases 
# 
variti_r(){ 
    sudo cp -fv $variti /root/.bash_aliases.d/; 
}
variti(){
    cp -fv $variti ~/.bash_aliases.d/
    yes_edit_no variti_r "$variti" "Install variety.sh at /root/?" "yes" "YELLOW" 
}
yes_edit_no variti "$variti" "Install variety.sh at ~/.bash_aliases.d/ (aliases for a variety of tools)? " "yes" "GREEN" 


