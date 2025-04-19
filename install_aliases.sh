#!/bin/bash

export SYSTEM_UPDATED="TRUE"

if ! test -f checks/check_all.sh; then
    eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)"
else
    . ./checks/check_all.sh
fi

[[ "$(type sudo)" =~ 'aliased' ]] && unalias sudo

get-script-dir SCRIPT_DIR

rlwrpscrpt=aliases/.bash_aliases.d/00-rlwrap_scripts.sh
reade=rlwrap-scripts/reade
readyn=rlwrap-scripts/readyn
yesnoedit=rlwrap-scripts/yes-no-edit
csysm=checks/check_system.sh
if ! test -d checks/; then
    tmp=$(mktemp) && curl -o $tmp https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/00-rlwrap_scripts.sh && rlwrapscrpt=$tmp
    tmp=$(mktemp) && curl -o $tmp https://raw.githubusercontent.com/excited-bore/dotfiles/main/rlwrap-scripts/reade && reade=$tmp
    tmp=$(mktemp) && curl -o $tmp https://raw.githubusercontent.com/excited-bore/dotfiles/main/rlwrap-scripts/readyn && readyn=$tmp
    tmp=$(mktemp) && curl -o $tmp https://raw.githubusercontent.com/excited-bore/dotfiles/main/rlwrap-scripts/yes-no-edit && yesnoedit=$tmp
    tmp=$(mktemp) && curl -o $tmp https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh && csysm=$tmp
fi

reade_r() {
    sudo cp -f $rlwrpscrpt /root/.bash_aliases.d/
    sudo cp -f $reade /root/.bash_aliases.d/01-reade.sh
    sudo cp -f $readyn /root/.bash_aliases.d/02-readyn.sh
    sudo cp -f $yesnoedit /root/.bash_aliases.d/03-yes-no-edit.sh
}
readeu() {
    cp -f $rlwrpscrpt ~/.bash_aliases.d/
    cp -f $reade ~/.bash_aliases.d/01-reade.sh
    cp -f $readyn ~/.bash_aliases.d/02-readyn.sh
    cp -f $yesnoedit ~/.bash_aliases.d/03-yes-no-edit.sh
    yes-no-edit -f reade_r -g "$reade $readyn $yesnoedit $rlwrpscrpt" -p "Install reade, readyn and yes-no-edit at /root/.bash_aliases.d/?" -i "y" -Q "YELLOW"
}
yes-no-edit -f readeu -g "$reade $readyn $yesnoedit $rlwrpscrpt" -p "Install reade, readyn, yes-no-edit and rlwrap_scripts at ~/.bash_aliases.d/ (rlwrap/read functions that are used in other aliases)? " -i "y" -Q "GREEN"

csysm_r() {
    sudo cp -f $csysm /root/.bash_aliases.d/04-check_system.sh
}
csysm() {
    cp -f $csysm ~/.bash_aliases.d/04-check_system.sh
    yes-no-edit -f csysm_r -g "$csysm" -p "Install check_system.sh at /root/?" -i "y" -Q "YELLOW"
}
yes-no-edit -f csysm -g "$csysm" -p "Install check_system.sh at ~/.bash_aliases.d/ (do a checkup on what kind of system this is - used for later scripts)?" -i "y" -Q "GREEN"

genr=aliases/.bash_aliases.d/general.sh
genrc=aliases/.bash_completion.d/general
if ! test -f aliases/.bash_aliases.d/general.sh; then
    tmp=$(mktemp) && curl -o $tmp https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/general.sh
    tmp1=$(mktemp) && curl -o $tmp https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliasases/.bash_completion.d/general
    genr=$tmp
    genrc=$tmp1
fi

readyn -p "Install general.sh at ~/? (aliases related to general actions - cd/mv/cp/rm + completion script replacement for 'read -e')" ansr

if [[ $ansr == "y" ]]; then
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
        if [[ $eza_verb == 'y' ]]; then

            ezalias="eza"

            readyn -p "Add '--header' as an option for 'eza'? (explanation of table content at top)" eza_hdr
            if [[ $eza_hdr == 'y' ]]; then
                ezalias=$ezalias" --header"
            fi

            readyn -p "Always color 'eza' output?" eza_clr
            if [[ $eza_clr == 'y' ]]; then
                ezalias=$ezalias" --color=always"
            fi

            readyn -p "Always show filetype/directory icons for items with 'eza'? " eza_icon
            if [[ $eza_icon == 'y' ]]; then
                ezalias=$ezalias" --icons=always"
            fi

            sed -i 's|.*alias ls=".*|type eza \&> /dev/null \&\& alias ls="'"$ezalias"'"|g' $genr
            unset ezalias eza_clr eza_hdr eza_icon
        fi
    fi

    readyn -p "Set cp alias?" cp_all
 

    if [[ $cp_all == 'y' ]]; then
        cp_xcp="cp"
        cp_r=''
        cp_vr=''
        cp_ov=''
        cp_der=''
        if type xcp &>/dev/null; then
            readyn -p "${CYAN}xcp${GREEN} installed. Use xcp instead of cp (might conflict with sudo cp if cargo not available is sudo path / secure_path in /etc/sudoers)?" cp_xcpq
            if [[ $cp_xcpq == 'y' ]]; then
                cp_xcp='xcp --glob'
            fi
        fi
        readyn -p "Be recursive? (Recursive means copy everything inside directories without aborting)" cp_rq
        if [[ "$cp_rq" == 'y' ]]; then
            cp_r='--recursive'
            #xcp_r="--recursive"
        fi
        readyn -p "Be verbose? (All info about copying process)" cp_vq
        if [[ "$cp_vq" == 'y' ]]; then
            cp_v='--verbose'
            #xcp_v="--verbose"
        fi

        readyn -n -p "Never overwrite already present files?" cp_ovq
        if [[ $cp_ovq == 'y' ]]; then
            cp_ov='--no-clobber'
            #xcp_ov="--no-clobber"
        fi

        readyn -p "Lookup files/directories of symlinks?" cp_derq
        if [[ $cp_derq == 'y' ]]; then
            cp_der='--dereference'
            #xcp_der="--dereference"
        fi
        
        
        #if type xcp &> /dev/null && [[ $cp_xcpq == 'y' ]]; then
            #sed -i 's|^alias cp=".*|alias cp="'"$cp_xcp $xcp_r $xcp_v $xcp_ov $xcp_der"' --"|g' $genr 
        #else 
            sed -i 's|^alias cp=".*|alias cp="'"$cp_xcp $cp_r $cp_v $cp_ov $cp_der"'"|g' $genr
        #fi
        #[[ "$cp_xcp" =~ 'xcp --glob' ]] && sed -i 's|^alias cp=".*|type xcp \&> /dev/null && alias cp="'"$cp_xcp $cp_r $cp_v $cp_ov $cp_der"' --" \|\| alias cp="cp "'"$cp_r $cp_v $cp_ov $cp_der"' --"|g' $genr || sed -i 's|^alias cp=".*|type xcp \&> /dev/null && alias cp="'"$cp_xcp $cp_r $cp_v $cp_ov $cp_der"' --"|g'
    fi

    unset cp_all cp_xcp cp_v cp_ov cp_xcpq

    prompt="${green}    - Force remove, recursively delete given directories (enable deletion of direction without deleting every file in directory first) and ${bold}always give at least one prompt before removing?${normal}${green}
    - Force remove, ${YELLOW}don't${normal}${green} recursively look for files and give a prompt not always, but if removing 3 or more files/folder?
    - Recursively look without a prompt?${normal}\n"
    prompt2="Rm = [Recur-prompt/none/prompt/recur"
    pre="recur-prompt"
    ansrs="none prompt recur"

    if type rm-prompt &>/dev/null; then
        prompt="${GREEN}    - Alias 'rm' to use 'rm-prompt' which lists all files and directories before removing them ${normal}\n$prompt"
        prompt2="Rm = [Rm-prompt/recur-prompt/none/prompt/recur"
        pre="rm-prompt"
        ansrs="recur-prompt none prompt recur "
    else
        readyn -p "Set rm (remove) to always be verbose?" rm_verb
    fi

    if type gio &>/dev/null; then
        prompt="$prompt${green}    - Don't use 'rm' but use 'gio trash' to trash files (leaving a copy in ${cyan}trash:///${green} after 'removing')${normal}\n"
        prompt2="$prompt2/trash]: "
        ansrs="none prompt recur trash"
    else
        prompt2="$prompt2]: "
    fi

    printf "${CYAN}Set rm (remove) to:\n$prompt"
    reade -Q "GREEN" -i "$pre $ansrs" -p "$prompt2" ansr
    if [[ "$ansr" == "none" ]] && [[ "$rm_verb" == 'n' ]]; then
        sed -i 's|^alias rm="|#alias rm="|g' $genr
    else
        sed -i 's|.*alias cp="cp-trash -rv"|alias cp="cp-trash -rv"|g' $genr
        sed -i 's|.*alias mv="mv-trash -v"|alias mv="mv-trash -v"|g' $genr
    fi

    if type bat &>/dev/null; then
        readyn -n -p "Set 'cat' as alias for 'bat'?" cat
        if [[ "$cat" == "y" ]]; then
            sed -i 's|.*alias cat="bat"|alias cat="bat"|g' $genr
        else
            sed -i 's|^alias cat="bat"|#alias cat="bat"|g' $genr
        fi
    fi
    unset cat

    if type ack &>/dev/null; then
        readyn -n -p "Set 'ack' as alias for 'grep'?" ack_gr
        if [[ "$ack_gr" == "y" ]]; then
            sed -i 's|.*alias grep="ack"|alias ack="ack"|g' $genr
        else
            sed -i 's|^alias grep="ack"|alias grep="grep --color=always"|g' $genr
        fi
    fi
    unset ack_gr

    if type ruby &>/dev/null; then

        rver=$(echo $(ruby --version) | awk '{print $2}' | cut -d. -f-2)'.0'

        type gem &>/dev/null &&
            paths=$(gem environment | awk '/- GEM PATH/{flag=1;next}/- GEM CONFIGURATION/{flag=0}flag' | sed 's|     - ||g' | paste -s -d ':')
        if grep -q "GEM" $ENVVAR; then
            sed -i "s|.export GEM_|export GEM_|g" $ENVVAR
            sed -i "s|export GEM_HOME=.*|export GEM_HOME=$HOME/.gem/ruby/$rver|g" $ENVVAR
            type gem &>/dev/null &&
                sed -i "s|export GEM_PATH=.*|export GEM_PATH=$paths|g" $ENVVAR
            sed -i "s|.export PATH=\$PATH:\$GEM_PATH|export PATH=\$PATH:\$GEM_PATH|g" $ENVVAR
            sed -i 's|export PATH=$PATH:$GEM_PATH.*|export PATH=$PATH:$GEM_PATH:$GEM_HOME/bin|g' $ENVVAR
        else
            printf "export GEM_HOME=$HOME/.gem/ruby/$rver\n" >>$ENVVAR
            type gem &>/dev/null &&
                printf "export GEM_PATH=$paths\n" >>$ENVVAR
            printf "export PATH=\$PATH:\$GEM_PATH:\$GEM_HOME/bin\n" >>$ENVVAR
        fi
    fi

    general_r() {
        sudo cp -f $genr /root/.bash_aliases.d/
        sudo cp -f $genrc /root/.bash_completion.d/
    }
    general() {
        cp -f $genr ~/.bash_aliases.d/
        cp -f $genrc ~/.bash_completion.d/
        yes-no-edit -f general_r -g "$genr $genrc" -p "Install general.sh at /root/?" -i "y" -Q "YELLOW"
    }
    yes-no-edit -f general -g "$genr $genrc" -p "Install general.sh at ~/?" -i "y" -Q "GREEN"
fi

pre='both'
othr='exit intr n'
color='GREEN'
prmpt='[Both/exit/intr/n]: '

# echo "Next $(tput setaf 1)sudo$(tput sgr0) will check for terminate background processes /root/.bashrc' "
if grep -q "trap '! \[ -z \"\$(jobs -p)\" ] && kill -9 \$(jobs -p.*" ~/.bashrc || grep -q "trap '! [ -z \"\$(jobs -p)\" ] && kill -9 \$(jobs -p.*" /root/.bashrc; then
    pre='n'
    othr='both exit intr'
    color='YELLOW'
    prmpt='[N/both/exit/intr]: '
fi

reade -Q "$color" -i "$pre $othr" -p "Send kill signal to background processes when exiting (Ctrl-q) / interrupting (Ctrl-c) for $USER? $prmpt" int_r
if [[ "$int_r" == "both" ]] || [[ "$int_r" == 'exit' ]] || [[ "$int_r" == 'intr' ]]; then
    if [[ "$int_r" == 'both' ]]; then
        sig='INT EXIT'
    elif [[ "$int_r" == 'exit' ]]; then
        sig='EXIT'
    elif [[ "$int_r" == 'intr' ]]; then
        sig='INT'
    fi
    if grep -q "trap '! \[ -z \"\$(jobs -p)\" ] && kill -9 \$(jobs -p.*" ~/.bashrc; then
        sed -i '/trap '\''! \[ -z "$(jobs -p)" \] \&\& kill -9 "$(jobs -p.*/d' ~/.bashrc
    fi
    printf "trap '! [ -z \"\$(jobs -p)\" ] && kill -9 \$(jobs -p | tr \"\\\n\" \" \")' $sig\n" >>~/.bashrc

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
    if [[ "$int_r" == "both" ]] || [[ "$int_r" == 'exit' ]] || [[ "$int_r" == 'intr' ]]; then
        if [[ $int_r == 'both' ]]; then
            sig='INT EXIT'
        elif [[ $int_r == 'exit' ]]; then
            sig='EXIT'
        elif [[ $int_r == 'intr' ]]; then
            sig='INT'
        fi

        if sudo grep -q "trap '! \[ -z \"\$(jobs -p)\" ] && kill -9 \$(jobs -p.*" /root/.bashrc; then
            sudo sed -i '/trap '\''! \[ -z "$(jobs -p)" \] \&\& kill -9 "$(jobs -p.*/d' /root/.bashrc
        fi
        printf "trap '! [ -z \"\$(jobs -p)\" ] && kill -9 \"\$(jobs -p | tr \\\n\"  \" \")' $sig\n" | sudo tee -a /root/.bashrc &>/dev/null
    fi
fi
unset int_r sig

bashc=aliases/.bash_aliases.d/bash.sh
update_sysm=aliases/.bash_aliases.d/update-system.sh
pacmn=aliases/.bash_aliases.d/package_managers.sh
[[ $distro == "Manjaro" ]] && manjaro=aliases/.bash_aliases.d/manjaro.sh
type systemctl &>/dev/null && systemd=aliases/.bash_aliases.d/systemctl.sh
type sudo &>/dev/null && dosu=aliases/.bash_aliases.d/sudo.sh
type git &>/dev/null && gits=aliases/.bash_aliases.d/git.sh
type ssh &>/dev/null && sshs=aliases/.bash_aliases.d/ssh.sh
ps1=aliases/.bash_aliases.d/PS1_colours.sh
variti=aliases/.bash_aliases.d/variety.sh
type python &>/dev/null && pthon=aliases/.bash_aliases.d/python.sh
if ! test -d aliases/.bash_aliases.d/; then
    tmp1=$(mktemp) && curl -o $tmp1 https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/update-system.sh && update_sysm=$tmp1
    tmp=$(mktemp) && curl -o $tmp https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/bash.sh && bash=$tmp
    [[ $distro == "Manjaro" ]] && tmp7=$(mktemp) && curl -o $tmp7 https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/manjaro.sh && manjaro=$tmp7
    tmp4=$(mktemp) && curl -o $tmp4 https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/package_managers.sh && pacmn=$tmp4
    type systemctl &>/dev/null && tmp2=$(mktemp) && curl -o $tmp2 https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/systemctl.sh && systemd=$tmp2
    type sudo &>/dev/null && tpac_insmp3=$(mktemp) && curl -o $tmp3 https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/sudo.sh && dosu=$tmp3
    type git &>/dev/null && tmp10=$(mktemp) && curl -o $tmp10 https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/git.sh && gits=$tmp5
    type ssh &>/dev/null && tmp5=$(mktemp) && curl -o $tmp5 https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/ssh.sh && sshs=$tmp5
    tmp6=$(mktemp) && curl -o $tmp6 https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/ps1.sh && ps1=$tmp6
    tmp8=$(mktemp) && curl -o $tmp8 https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/variety.sh && variti=$tmp8
    type python &>/dev/null && tmp9=$(mktemp) && curl -o $tmp9 https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/python.sh && pthon=$tmp9
fi

bash_r() {
    sudo cp -f $bashc /root/.bash_aliases.d/
}
bash_u() {
    cp -f $bashc ~/.bash_aliases.d/
    yes-no-edit -f bash_r -g "$bashc" -p "Install bash.sh at /root/.bash_aliases.d//?" -i "y" -Q "GREEN"
}
yes-no-edit -f bash_u -g "$bashc" -p "Install bash.sh at ~/.bash_aliases.d/? (a few bash related helper functions)?" -i "y" -Q "GREEN"

update_sysm_r() {
    sudo cp -f $update_sysm /root/.bash_aliases.d/
    sudo sed -i '/SYSTEM_UPDATED="TRUE"/d' /root/.bash_aliases.d/update-system.sh
}
update_sysm() {
    cp -f $update_sysm ~/.bash_aliases.d/
    sed -i '/SYSTEM_UPDATED="TRUE"/d' ~/.bash_aliases.d/update-system.sh
    yes-no-edit -f update_sysm_r -g "$update_sysm" -p "Install update-system.sh at /root/.bash_aliases.d//?" -i "y" -Q "YELLOW"
}
yes-no-edit -f update_sysm -g "$update_sysm" -p "Install update-system.sh at ~/.bash_aliases.d/? (Global system update function)?" -i "y" -Q "GREEN"

packman_r() {
    sudo cp -f $pacmn /root/.bash_aliases.d/
}
packman() {
    cp -f $pacmn ~/.bash_aliases.d/
    yes-no-edit -f packman_r -g "$pacmn" -p "Install package_managers.sh at /root/.bash_aliases.d/?" -i "y" -Q "YELLOW"
}
yes-no-edit -f packman -g "$pacmn" -p "Install package_managers.sh at ~/.bash_aliases.d/ (package manager aliases)? " -i "y" -Q "GREEN"

if [[ "$distro" == "Manjaro" ]]; then
    manj_r() {
        sudo cp -f $manjaro /root/.bash_aliases.d/
    }
    manj() {
        cp -f $manjaro ~/.bash_aliases.d/
        yes-no-edit -f manj_r -g "$manjaro" -p "Install manjaro.sh at /root/.bash_aliases.d/?" -i "y" -Q "YELLOW"
    }
    yes-no-edit -f manj -g "$manjaro" -p "Install manjaro.sh at ~/.bash_aliases.d/ (manjaro specific aliases)? " -i "y" -Q "GREEN"
fi

systemd_r() {
    sudo cp -f $systemd /root/.bash_aliases.d/
}
systemd() {
    cp -f $systemd ~/.bash_aliases.d/
    yes-no-edit -f systemd_r -g "$systemd" -p "Install systemctl.sh at /root/.bash_aliases.d/?" -i "y" -Q "YELLOW"
}
yes-no-edit -f systemd -g "$systemd" -p "Install systemctl.sh at ~/.bash_aliases.d/? (systemctl aliases/functions)?" -i "y" -Q "GREEN"

dosu_r() {
    sudo cp -f $dosu /root/.bash_aliases.d/
}

dosu() {
    cp -f $dosu ~/.bash_aliases.d/
    yes-no-edit -f dosu_r -g "$dosu" -p "Install sudo.sh at /root/.bash_aliases.d/?" -i "y" -Q "YELLOW"
}
yes-no-edit -f dosu -g "$dosu" -p "Install sudo.sh at ~/.bash_aliases.d/ (sudo aliases)?" -i "y" -Q "GREEN"

git_r() {
    sudo cp -f $gits /root/.bash_aliases.d/
}
gith() {
    cp -f $gits ~/.bash_aliases.d/
    yes-no-edit -f git_r -g "$gits" -p "Install git.sh at /root/.bash_aliases.d/?" -i "y" -Q "YELLOW"
}
yes-no-edit -f gith -g "$gits" -p "Install git.sh at ~/.bash_aliases.d/ (git aliases)? " -i "y" -Q "GREEN"

ssh_r() {
    sudo cp -f $sshs /root/.bash_aliases.d/
}
sshh() {
    cp -f $sshs ~/.bash_aliases.d/
    yes-no-edit -f ssh_r -g "$sshs" -p "Install ssh.sh at /root/.bash_aliases.d/?" -i "y" -Q "YELLOW"
}
yes-no-edit -f sshh -g "$sshs" -p "Install ssh.sh at ~/.bash_aliases.d/ (ssh aliases)? " -i "y" -Q "GREEN"

ps1_r() {
    sudo cp -f $ps1 /root/.bash_aliases.d/
}
ps11() {
    cp -f $ps1 ~/.bash_aliases.d/
    yes-no-edit -f ps1_r -g "$ps1" -p "Install PS1_colours.sh at /root/.bash_aliases.d/?" -i "y" -Q "YELLOW"
}
yes-no-edit -f ps11 -g "$ps1" -p "Install PS1_colours.sh at ~/.bash_aliases.d/ (Coloured command prompt)? " -i "y" -Q "GREEN"

if type python &>/dev/null; then
    pthon() {
        cp -f $pthon ~/.bash_aliases.d/
    }
    yes-no-edit -f pthon -g "$pthon" -p "Install python.sh at ~/.bash_aliases.d/ (aliases for a python development)? " -i "y" -Q "GREEN"
fi

# Variety aliases
#
variti_r() {
    sudo cp -f $variti /root/.bash_aliases.d/
}
variti() {
    cp -f $variti ~/.bash_aliases.d/
    yes-no-edit -f variti_r -g "$variti" -p "Install variety.sh at /root/?" -i "y" -Q "YELLOW"
}
yes-no-edit -f variti -g "$variti" -p "Install variety.sh at ~/.bash_aliases.d/ (aliases for a variety of tools)?" -i "y" -Q "GREEN"

source ~/.bashrc &>/dev/null
