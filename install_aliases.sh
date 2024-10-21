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
if grep -q "trap '! [ -z \"\$(jobs -p)\" ] \&\& kill \"\$(jobs -p)\"' .*" ~/.bashrc || sudo grep -q "trap '! [ -z \"\$(jobs -p)\" ] \&\& kill \"\$(jobs -p)\"' .*" /root/.bashrc; then
    pre='n' 
    othr='both exit intr'
    color='YELLOW'
    prmpt='[N/both/exit/intr]: '
fi 

reade -Q "$color" -i "$pre" -p "Send kill signal to background processes when exiting (Ctrl-q)/interrupting (Ctrl-c) for $USER? $prmpt" "$othr" int_r
if ! [ $int_r  == "n" ]; then
    if test $int_r == 'both'; then
        sig='INT EXIT'  
    elif test $int_r == 'exit'; then
        sig='EXIT'  
    elif test $int_r == 'intr'; then
        sig='INT'  
    fi
    if ! grep -q "trap '! [ -z \"\$(jobs -p)\" ] \&\& kill \"\$(jobs -p)\"' .*" ~/.bashrc; then 
        printf "trap '! [ -z \"\$(jobs -p)\" ] && kill \"\$(jobs -p)\"' $sig\n" >> ~/.bashrc
    else  
        sed -i 's|trap '\''! \[ -z "$(jobs -p)" \] \&\& kill "$(jobs -p)"'\'' .*|trap '\''! [ -z "$(jobs -p)" \] \&\& kill "$(jobs -p)"'\'' '"$sig"'|g' ~/.bashrc 
    fi 
    
    pre='same'
    othr='both exit intr n'
    color='GREEN'
    prmpt='[Same/both/exit/intr/n]: '
    echo "Next $(tput setaf 1)sudo$(tput sgr0) will check for terminate background processes /root/.bashrc' "
     
    if sudo grep -q 'trap ''kill $(jobs -p)' /root/.bashrc; then
        pre='n' 
        othr='same both exit intr'
        color='YELLOW'
        prmpt='[N/same/both/exit/intr]: '
    fi 
    reade -Q "$color" -i "$pre" -p "Send kill signal to background processes when exiting (Ctrl-q)/interrupting (Ctrl-c) for root? $prmpt" "$othr" int_r 
    if ! [ $int_r  == "n" ]; then
        if test $int_r == 'both'; then
            sig='INT EXIT'  
        elif test $int_r == 'exit'; then
            sig='EXIT'  
        elif test $int_r == 'intr'; then
            sig='INT'  
        fi

        if ! sudo grep -q "trap 'kill \$(jobs -p).*" /root/.bashrc; then 
            printf "trap '! [ -z \"\$(jobs -p)\" ] && kill \"\$(jobs -p)\" $sig\n'" | sudo tee -a /root/.bashrc
        else  
            sudo sed -i 's|trap '\''! \[ -z "$(jobs -p)" \] \&\& kill "$(jobs -p)"'\'' .*|trap '\''! [ -z "$(jobs -p)" \] \&\& kill "$(jobs -p)"'\'' '"$sig"'|g' /root/.bashrc 
        fi  
    fi     
fi
unset int_r sig


genr=aliases/.bash_aliases.d/general.sh
if ! test -f aliases/.bash_aliases.d/general.sh; then
    tmp=$(mktemp) && curl -o $tmp https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/general.sh 
    genr=$tmp
fi

reade -Q "GREEN" -i "y" -p "Install general.sh at ~/? (aliases related to general actions - cd/mv/cp/rm + completion script replacement for 'read -e') [Y/n]: " "n" ansr         

if test $ansr == "y"; then
    if test -f ~/.environment.env; then
        sed -i 's|^export TRASH_BIN_LIMIT=|export TRASH_BIN_LIMIT=|g' ~/.environment.env
    fi
    reade -Q "GREEN" -i "y" -p "Set cp/mv (when overwriting) to backup files? (will also trash backups) [Y/n]: " "n" ansr         
    if [ "$ansr" != "y" ]; then
        sed -i 's|^alias cp="cp-trash -rv"|#alias cp="cp-trash -rv"|g' $genr
        sed -i 's|^alias mv="mv-trash -v"|#alias mv="mv-trash -v"|g' $genr
    else
        sed -i 's|.*alias cp="cp-trash -rv"|alias cp="cp-trash -rv"|g' $genr
        sed -i 's|.*alias mv="mv-trash -v"|alias mv="mv-trash -v"|g' $genr
    fi
    unset ansr

    if type gio &> /dev/null; then 
        reade -Q "YELLOW" -i "n" -p "Set 'gio trash' alias for rm? [N/y]: " "y" ansr 
        if [ "$ansr" != "y" ]; then
            sed -i 's|^alias rm="gio trash"|#alias rm="gio trash"|g' $genr
        else
            sed -i 's|.*alias rm="gio trash"|alias rm="gio trash"|g' $genr
        fi
    fi 
    if type bat &> /dev/null; then
        reade -Q "YELLOW" -i "n" -p "Set 'cat' as alias for 'bat'? [N/y]: " "y" cat
        if [ "$cat" != "y" ]; then
            sed -i 's|^alias cat="bat"|#alias cat="bat"|g' $genr
        else
            sed -i 's|.*alias cat="bat"|alias cat="bat"|g' $genr
        fi
    fi
    unset cat

    general_r(){ 
        sudo cp -fv $genr /root/.bash_aliases.d/;
    }
    general(){
        cp -fv $genr ~/.bash_aliases.d/
        yes_edit_no general_r "$genr" "Install general.sh at /root/?" "yes" "YELLOW"; }
    yes_edit_no general "$genr" "Install general.sh at ~/?" "yes" "GREEN"
fi

update_sysm=aliases/.bash_aliases.d/update-system.sh
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
    yes_edit_no update_sysm_r "$update_sysm" "Install update-system.sh at /root/?" "yes" "YELLOW";
}
yes_edit_no update_sysm "$update_sysm" "Install update-system.sh at ~/.bash_aliases.d/? (Global system update function)?" "yes" "GREEN"

packman_r(){ 
    sudo cp -fv $pacmn /root/.bash_aliases.d/
}
packman(){
    cp -fv $pacmn ~/.bash_aliases.d/
    yes_edit_no packman_r "$pacmn" "Install package_managers.sh at /root/?" "yes" "YELLOW" 
}
yes_edit_no packman "$pacmn" "Install package_managers.sh at ~/.bash_aliases.d/ (package manager aliases)? " "yes" "GREEN"

if [ $distro == "Manjaro" ] ; then
    manj_r(){ 
        sudo cp -fv $manjaro /root/.bash_aliases.d/; 
    }
    manj(){
        cp -fv $manjaro ~/.bash_aliases.d/
        yes_edit_no manj_r "$manjaro" "Install manjaro.sh at /root/?" "yes" "YELLOW" 
    }
    yes_edit_no manj "$manjaro" "Install manjaro.sh at ~/.bash_aliases.d/ (manjaro specific aliases)? " "yes" "GREEN"
fi


systemd_r(){ 
    sudo cp -fv $systemd /root/.bash_aliases.d/;
}
systemd(){
    cp -fv $systemd ~/.bash_aliases.d/
    yes_edit_no systemd_r "$systemd" "Install systemctl.sh at /root/?" "yes" "YELLOW"; }
yes_edit_no systemd "$systemd" "Install systemctl.sh at ~/.bash_aliases.d/? (systemctl aliases/functions)?" "yes" "GREEN"
    

dosu_r(){ 
    sudo cp -fv $dosu /root/.bash_aliases.d/ ;
}    

dosu(){ 
    cp -fv $dosu ~/.bash_aliases.d/;
    yes_edit_no dosu_r "$dosu" "Install sudo.sh at /root/?" "yes" "YELLOW"; }
yes_edit_no dosu "$dosu" "Install sudo.sh at ~/.bash_aliases.d/ (sudo aliases)?" "yes" "GREEN"


git_r(){ 
    sudo cp -fv $gits /root/.bash_aliases.d/; 
}
gith(){
    cp -fv $gits ~/.bash_aliases.d/
    yes_edit_no git_r "$gits" "Install git.sh at /root/?" "yes" "YELLOW" 
}
yes_edit_no gith "$gits" "Install git.sh at ~/.bash_aliases.d/ (git aliases)? " "yes" "GREEN"

ssh_r(){ 
    sudo cp -fv $sshs /root/.bash_aliases.d/; 
}
sshh(){
    cp -fv $sshs ~/.bash_aliases.d/
    yes_edit_no ssh_r "$sshs" "Install ssh.sh at /root/?" "yes" "YELLOW" 
}
yes_edit_no sshh "$sshs" "Install ssh.sh at ~/.bash_aliases.d/ (ssh aliases)? " "yes" "GREEN"


ps1_r(){ 
    sudo cp -fv $ps1 /root/.bash_aliases.d/; 
}
ps11(){
    cp -fv $ps1 ~/.bash_aliases.d/
    yes_edit_no ps1_r "$ps1" "Install PS1_colours.sh at /root/?" "yes" "YELLOW" 
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

