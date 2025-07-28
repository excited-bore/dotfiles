#!/bin/bash

export SYSTEM_UPDATED="TRUE"

if ! test -f checks/check_all.sh; then
    if type curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        printf "If not downloading/git cloning the scriptfolder, you should at least install 'curl' beforehand when expecting any sort of succesfull result...\n"
        return 1 || exit 1
    fi
else
    . ./checks/check_all.sh
fi

if ! test -f checks/check_aliases_dir.sh; then
    source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_aliases_dir.sh)
else
    . ./checks/check_aliases_dir.sh
fi

#[[ "$(type sudo)" =~ 'aliased' ]] && unalias sudo
#[[ "$(type cp)" =~ 'aliased' ]] &&
#    unalias cp && alias cp='cp -fv'


SCRIPT_DIR=$(get-script-dir)

rlwrpscrpt=aliases/.bash_aliases.d/00-rlwrap_scripts.sh
reade=rlwrap-scripts/reade
readyn=rlwrap-scripts/readyn
yesnoedit=rlwrap-scripts/yes-edit-no
csysm=checks/check_system.sh
if ! test -d checks/; then
    tmp=$(mktemp) && curl -o $tmp https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/00-rlwrap_scripts.sh && rlwrapscrpt=$tmp
    tmp=$(mktemp) && curl -o $tmp https://raw.githubusercontent.com/excited-bore/dotfiles/main/rlwrap-scripts/reade && reade=$tmp
    tmp=$(mktemp) && curl -o $tmp https://raw.githubusercontent.com/excited-bore/dotfiles/main/rlwrap-scripts/readyn && readyn=$tmp
    tmp=$(mktemp) && curl -o $tmp https://raw.githubusercontent.com/excited-bore/dotfiles/main/rlwrap-scripts/yes-edit-no && yesnoedit=$tmp
    tmp=$(mktemp) && curl -o $tmp https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh && csysm=$tmp
fi

reade_r() {
    sudo cp $rlwrpscrpt /root/.bash_aliases.d/
    sudo cp $reade /root/.bash_aliases.d/01-reade.sh
    sudo cp $readyn /root/.bash_aliases.d/02-readyn.sh
    sudo cp $yesnoedit /root/.bash_aliases.d/03-yes-edit-no.sh
}
readeu() {
    cp $rlwrpscrpt ~/.bash_aliases.d/
    cp $reade ~/.bash_aliases.d/01-reade.sh
    cp $readyn ~/.bash_aliases.d/02-readyn.sh
    cp $yesnoedit ~/.bash_aliases.d/03-yes-edit-no.sh
    yes-edit-no -y -Y "YELLOW" -f reade_r -g "$reade $readyn $yesnoedit $rlwrpscrpt" -p "Install reade, readyn and yes-edit-no at /root/.bash_aliases.d/?" 
}
yes-edit-no -y -f readeu -g "$reade $readyn $yesnoedit $rlwrpscrpt" -p "Install reade, readyn, yes-edit-no and rlwrap_scripts at ~/.bash_aliases.d/ (rlwrap/read functions that are used in other aliases)? "

csysm_r() {
    sudo cp $csysm /root/.bash_aliases.d/04-check_system.sh
}
csysm() {
    cp $csysm ~/.bash_aliases.d/04-check_system.sh
    yes-edit-no -y -Y "YELLOW" -f csysm_r -g "$csysm" -p "Install check_system.sh at /root/?" 
}
yes-edit-no -y -f csysm -g "$csysm" -p "Install check_system.sh at ~/.bash_aliases.d/ (do a checkup on what kind of system this is - used for later scripts)?" 

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
    if test -f ~/.environment; then
        sed -i 's|^export TRASH_BIN_LIMIT=|export TRASH_BIN_LIMIT=|g' ~/.environment
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

    if hash eza &>/dev/null; then
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

            sed -i 's|.*alias ls=".*|hash eza \&> /dev/null \&\& alias ls="'"$ezalias"'"|g' $genr
            unset ezalias eza_clr eza_hdr eza_icon
        fi
    fi

    readyn -p "Set ${CYAN}cp${GREEN} alias?" cp_all

    if [[ $cp_all == 'y' ]]; then
        cp_xcp="cp"
        cp_prgs=''
        cp_r=''
        cp_vr=''
        cp_ov=''
        cp_der=''
        if hash cpg &> /dev/null || hash xcp &> /dev/null || command cp --help | grep -qF -- '-g'; then
            if (hash cpg &> /dev/null || command cp --help | grep -qF -- '-g') && hash xcp &> /dev/null; then
                readyn -p "Both '${CYAN}cpg/cp -g${GREEN}' and '${CYAN}xcp${GREEN}' are installed. Use either instead of regular 'cp' for cp with progress bar?" cp_xcpq
                if [[ "$cp_xcpq" == 'y' ]]; then
                    reade -Q 'GREEN' -i 'cpg xcp' -p 'Which one? [Cpg/xcp]: ' cp_xcpq
                    if [[ "$cp_xcpq" == 'cpg' ]]; then
                        if command cp --help | grep -qF -- '-g'; then 
                            cp_xcp='cp -g'
                        elif hash cpg &> /dev/null; then
                            cp_xcp='cpg -g'
                        fi
                    elif [[ "$cp_xcpq" == 'xcp' ]]; then
                        cp_xcp='xcp --glob --progress-bar'
                    fi
                fi
            else
                if command cp --help | grep -qF -- '-g'; then
                    readyn -p "${CYAN}cp -g${GREEN} installed. Use cp -g instead of cp? (add progress bar)" cp_xcpq
                    if [[ "$cp_xcpq" == 'y' ]]; then
                        cp_xcp='cp -g'
                    fi
                elif hash cpg &>/dev/null; then
                    readyn -p "${CYAN}cpg${GREEN} installed. Use cpg instead of cp? (add progress bar)" cp_xcpq
                    if [[ "$cp_xcpq" == 'y' ]]; then
                        cp_xcp='cpg -g'
                    fi
                elif hash xcp &>/dev/null; then
                    readyn -p "${CYAN}xcp${GREEN} installed. Use xcp instead of cp (add progress bar - might conflict with sudo cp if cargo not available for sudo path in /etc/sudoers)?" cp_xcpq
                    if [[ "$cp_xcpq" == 'y' ]]; then
                        cp_xcp='xcp --glob --progress-bar'
                    fi
                fi
            fi
            
            #if [[ "$cp_xcp" == 'xcp --glob' ]] || [[ "$cp_xcp" == 'cpg' ]]; then
            #    readyn -p "Set progress bar?" cp_prgsq
            #    if [[ "$cp_prgsq" == 'y' ]]; then
            #        [[ "$cp_xcp" == 'cpg' ]] && cp_prgs='--progress-bar'
            #    else
            #        [[ "$cp_xcp" == 'xcp --glob' ]] && cp_prgs='--no-progress'
            #    fi
            #fi
             
        fi
        readyn -p "Be recursive? (Recursive means copy everything inside directories without aborting)" cp_rq
        if [[ "$cp_rq" == 'y' ]]; then
            cp_r='--recursive'
            #xcp_r="--recursive"
        fi
       
        cp_ov_opts="always default skip prompt" 
        cp_ov_prmpt="[Always/default/skip/prompt]: " 

        if [[ $cp_xcp == 'xcp --glob' ]]; then
            cp_ov_opts="always default skip" 
            cp_ov_prmpt="[Always/default/skip]: " 
        fi
        
        reade -Q 'GREEN' -i "$cp_ov_opts" -p "Always overwrite already present files, silently skip, prompt for each or never overwrite? $cp_ov_prmpt" cp_ovq
        if [[ $cp_ovq == 'always' ]]; then
            cp_ov='--force'
        elif [[ $cp_ovq == 'skip' ]]; then
            cp_ov='--no-clobber'
            #xcp_ov="--no-clobber"
        elif [[ $cp_ovq == 'prompt' ]]; then
            cp_ov='--interactive'
        fi
        
        readyn -p "Be verbose? (All info about copying process)" cp_vq
        if [[ "$cp_vq" == 'y' ]]; then
            cp_v='--verbose'
            #xcp_v="--verbose"
        fi

        readyn -p "Lookup files/directories of symlinks?" cp_derq
        if [[ $cp_derq == 'y' ]]; then
            cp_der='--dereference'
            #xcp_der="--dereference"
        fi
        
        
        #if hash xcp &> /dev/null && [[ $cp_xcpq == 'y' ]]; then
            #sed -i 's|^alias cp=".*|alias cp="'"$cp_xcp $xcp_r $xcp_v $xcp_ov $xcp_der"' --"|g' $genr 
        #else 
            sed -i 's|^alias cp=".*|alias cp="'"$cp_xcp $cp_prgs $cp_r $cp_v $cp_ov $cp_der"'"|g' $genr
        #fi
        #[[ "$cp_xcp" =~ 'xcp --glob' ]] && sed -i 's|^alias cp=".*|hash xcp \&> /dev/null && alias cp="'"$cp_xcp $cp_r $cp_v $cp_ov $cp_der"' --" \|\| alias cp="cp "'"$cp_r $cp_v $cp_ov $cp_der"' --"|g' $genr || sed -i 's|^alias cp=".*|hash xcp \&> /dev/null && alias cp="'"$cp_xcp $cp_r $cp_v $cp_ov $cp_der"' --"|g'
    fi

    unset cp_all cp_r cp_rq cp_prgsq cp_prgs cp_xcpq cp_xcp cp_v cp_ov cp_xcpq cp_ovq cp_ov_prmpt cp_ov_opts cp_derq cp_der


    readyn -p "Set ${CYAN}mv${GREEN} alias?" mv_all
    if [[ $mv_all == 'y' ]]; then
        mv_mvg="mv"
        mv_prgs=''
        mv_ov='' 
        mv_v=''
        if hash mvg &> /dev/null; then
            readyn -p "'${CYAN}mvg${GREEN}' installed. Use instead of regular 'mv'?" mv_mvgq
            if [[ "$mv_mvgq" == 'y' ]]; then
                mv_mvg='mvg'
                
                readyn -p "Set progress bar?" mv_prgsq
                if [[ "$mv_prgsq" == 'y' ]]; then
                    mv_prgs='--progress-bar'
                fi
            fi
        fi
       
        mv_ov_opts="always default skip prompt" 
        mv_ov_prmpt="[Always/default/skip/prompt]: " 
        
        reade -Q 'GREEN' -i "$mv_ov_opts" -p "Always overwrite already present files, silently skip, prompt for each or never overwrite? $cp_ov_prmpt" mv_ovq
        if [[ $mv_ovq == 'always' ]]; then
            mv_ov='--force'
        elif [[ $mv_ovq == 'skip' ]]; then
            mv_ov='--no-clobber'
            #xcp_ov="--no-clobber"
        elif [[ $mv_ovq == 'prompt' ]]; then
            mv_ov='--interactive'
        fi 

        readyn -p "Be verbose? (All info about copying process)" cp_vq
        if [[ "$cp_vq" == 'y' ]]; then
            mv_v='--verbose'
            #xcp_v="--verbose"
        fi 
    
        sed -i 's|^alias mv=".*|alias mv="'"$mv_mvg $mv_prgs $mv_ov $mv_v"'"|g' $genr
    fi 

    unset mv_all mv_prgsq mv_prgs mv_mvgq mv_mvg mv_v mv_ov mv_vq mv_ovq mv_ov_prmpt mv_ov_opts


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

    if hash gio &>/dev/null; then
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

    if hash bat &>/dev/null; then
        readyn -n -p "Set 'bat' as alias for 'cat'?" cat
        if [[ "$cat" == "y" ]]; then
            sed -i 's|.*alias cat="bat"|alias cat="bat"|g' $genr
        else
            sed -i 's|^alias cat="bat"|#alias cat="bat"|g' $genr
        fi
    fi
    unset cat

    if hash ack &>/dev/null; then
        readyn -n -p "Set 'ack' as alias for 'grep'?" ack_gr
        if [[ "$ack_gr" == "y" ]]; then
            sed -i 's|.*alias grep="ack"|alias ack="ack"|g' $genr
        else
            sed -i 's|^alias grep="ack"|alias grep="grep --color=always"|g' $genr
        fi
    fi
    unset ack_gr

    if hash dust &>/dev/null || hash dua &>/dev/null || hash ncdu &> /dev/null; then
        if hash ncdu &> /dev/null; then
            reade -Q 'GREEN' -i 'dark dark-bg none' -p "${CYAN}ncdu${GREEN} installed. What colorscheme? [Dark/dark-bg/none]: " ncdu_color
            if test -n "$ncdu_color"; then
                sed -i "s/alias ncdu=\"ncdu .*\"/alias ncdu=\"ncdu --color $ncdu_color\"/g" $genr 
            fi
        fi
        if hash dust &> /dev/null || hash dua &> /dev/null || hash ncdu &> /dev/null; then
            if ! hash dua &> /dev/null && ! hash dua &> /dev/null && hash ncdu &> /dev/null; then 
                prmpt="${CYAN}'ncdu'${GREEN}"
                prmpt1=$prmpt
            elif ! hash dust &> /dev/null && hash dua &> /dev/null && ! hash ncdu &> /dev/null; then 
                prmpt="${CYAN}'dua'${GREEN}" 
                prmpt1="${CYAN}'dua interactive'${GREEN}"
            elif hash dust &> /dev/null && ! hash dua &> /dev/null && ! hash ncdu &> /dev/null; then 
                prmpt="${CYAN}'dust'${GREEN}"
            elif hash dust &> /dev/null && hash dua &> /dev/null && ! hash ncdu &> /dev/null; then
                prmpt="or ${CYAN}'dua'${GREEN}, or ${CYAN}'dust'${GREEN}" 
                prmpt1="${CYAN}'dua interactive'${GREEN}" 
                choices="dua dust" 
                prmptp=" [Dua/dust]: " 
            elif hash dust &> /dev/null && hash ncdu &> /dev/null && ! hash dua &> /dev/null; then 
                prmpt="or ${CYAN}'dust'${GREEN}, or ${CYAN}'ncdu'${GREEN}" 
                prmpt1="${CYAN}'ncdu'${GREEN}" 
                choices="dust ncdu" 
                prmptp=" [Dust/ncdu]: " 
            elif hash dua &> /dev/null && hash ncdu &> /dev/null && ! hash dust &> /dev/null; then 
                prmpt="or ${CYAN}'dua'${GREEN}, or ${CYAN}'ncdu'${GREEN}" 
                prmpt1="or ${CYAN}'dua interactive'${GREEN}, or ${CYAN}'ncdu'${GREEN}"
                choices="dua ncdu" 
                prmptp=" [Dua/ncdu]: " 
                choices1=$choices 
                prmptp1=$prmptp 
            elif hash dust &> /dev/null && hash dua &> /dev/null && hash ncdu &> /dev/null; then
                prmpt="or ${CYAN}'dua'${GREEN}, or ${CYAN}'dust'${GREEN}, or ${CYAN}'ncdu'${GREEN}" 
                prmpt1="or ${CYAN}'dua interactive'${GREEN}, or ${CYAN}'ncdu'${GREEN}"
                choices="dua dust ncdu" 
                prmptp=" [Dua/dust/ncdu]: " 
                choices1="dua ncdu" 
                prmptp1="  [Dua/ncdu]: " 
            fi
        fi

        readyn -p "Set $prmpt as alias for 'du'?" du_dust_dua
        if [[ "$du_dust_dua" == "y" ]]; then
            if hash dust &>/dev/null && hash dua &>/dev/null && hash ncdu &> /dev/null; then
                reade -Q 'GREEN' -i "$choices" -p "Which one?$prmptp" dust_dua
                if [[ 'dust' == "$dust_dua" ]]; then
                    which="dust" 
                elif [[ 'dua' == "$dust_dua" ]]; then
                    which='dua'
                elif [[ 'ncdu' == "$dust_dua" ]]; then
                    which='ncdu'
                fi
            elif hash dust &>/dev/null; then 
                which='dust' 
            elif hash dua &>/dev/null; then 
                which='dua' 
            elif hash ncdu &>/dev/null; then 
                which='ncdu' 
            fi
            sed -E -i "s|.alias du=\"|alias du=\"|g; s/alias du=\"(dua|dust|ncdu)\"/alias du=\"$which\"/g" $genr
        else
            sed -E -i 's|^alias du="\((dust|dua|ncdu)\)"|#alias du="\1"|g' $genr
        fi
        
        unset du_dust_dua choices prmptp 
       
        if hash dua &> /dev/null || hash ncdu &> /dev/null; then
            readyn -p "Set $prmpt1 as alias for 'du-tui'?" du_dust_dua
            if [[ "$du_dust_dua" == "y" ]]; then
                if hash dua &>/dev/null && hash ncdu &>/dev/null; then
                    reade -Q 'GREEN' -i "$choices1" -p "Which one?$prmptp1" dust_dua
                    if [[ 'ncdu' == "$dust_dua" ]]; then
                        which="ncdu" 
                    elif [[ 'dua' == "$dust_dua" ]]; then
                        which='dua interactive'
                    fi
                elif hash ncdu &>/dev/null; then 
                    which='ncdu' 
                elif hash dua &>/dev/null; then 
                    which='dua interactive' 
                fi
                if test -n "$which"; then
                    sed -E -i "s|.alias du-tui=\"|alias du-tui=\"|g; s/alias du-tui=\".*/alias du=\"$which\"/g" $genr
                fi
            else
                sed -i 's|^alias du-tui="dua interactive"|#alias du-tui="dua interactive"|g' $genr
                sed -i 's|^alias du-tui="ncdu"|#alias du-tui="ncdu"|g' $genr
            fi
        fi
    fi
    unset du_dust_dua prmpt which dust_dua

    if hash duf &> /dev/null || hash dysk &>/dev/null; then
        if hash duf &> /dev/null && hash dysk &>/dev/null; then
            readyn -p "Set or ${CYAN}duf${GREEN}, or ${CYAN}dysk${GREEN} as alias for 'df'?" dysk_df
            if [[ "$dysk_df" == "y" ]]; then
                reade -Q 'GREEN' -i 'duf dysk' -p 'Which one? [Duf/dysk]: ' duf_dysk 
                if test -n "$duf_dysk"; then
                    sed -E -i "s/.alias=df/alias=df/g; s/alias df='(dysk|duf)'/alias df='"$duf_dysk"'/g" $genr
                fi
            else
                sed -i 's|^alias df="\(dysk|duf\)"|#alias df="\1"|g' $genr
            fi
        
        fi
    elif hash duf &> /dev/null; then
        readyn -p "Set ${CYAN}'duf'${GREEN} as alias for 'df'?" dysk_df
        if [[ "$dysk_df" == "y" ]]; then
            sed -i "s|.alias df=|alias df=|g; s|alias df=.*|alias df='duf'|g" $genr
        else
            sed -i 's|^alias df="\(dysk|duf\)"|#alias df=|g' $genr
        fi
    
    elif hash dysk &> /dev/null; then
        readyn -p "Set ${CYAN}'dysk'${GREEN} as alias for 'df'?" dysk_df
        if [[ "$dysk_df" == "y" ]]; then
            sed -i "s|.alias df=|alias df=|g; s|alias df=.*|alias df='dysk'|g" $genr
        else
            sed -i 's|^alias df="\(dysk|duf\)"|#alias df=|g' $genr
        fi
         
    fi
    unset dysk_df


    if hash aria2c &>/dev/null; then
        readyn -n -p "Set 'aria2c' as alias for 'wget'?" aria_wgt
        if [[ "$aria_wgt" == "y" ]]; then
            sed -i 's|.*alias wget="aria2c"|alias wget="aria2c"|g' $genr
        else
            sed -i 's|^alias wget="aria2c"|alias wget="wget --https-only"|g' $genr
        fi
    fi
    unset aria_wgt


    if hash ruby &>/dev/null; then

        rver=$(echo $(ruby --version) | awk '{print $2}' | cut -d. -f-2)'.0'

        hash gem &>/dev/null &&
            paths=$(gem environment | awk '/- GEM PATH/{flag=1;next}/- GEM CONFIGURATION/{flag=0}flag' | sed 's|     - ||g' | paste -s -d ':')
        if grep -q "GEM" $ENV; then
            sed -i "s|.export GEM_|export GEM_|g" $ENV
            sed -i "s|export GEM_HOME=.*|export GEM_HOME=$HOME/.gem/ruby/$rver|g" $ENV
            hash gem &>/dev/null &&
                sed -i "s|export GEM_PATH=.*|export GEM_PATH=$paths|g" $ENV
            sed -i "s|.export PATH=\$PATH:\$GEM_PATH|export PATH=\$PATH:\$GEM_PATH|g" $ENV
            sed -i 's|export PATH=$PATH:$GEM_PATH.*|export PATH=$PATH:$GEM_PATH:$GEM_HOME/bin|g' $ENV
        else
            printf "export GEM_HOME=$HOME/.gem/ruby/$rver\n" >>$ENV
            hash gem &>/dev/null &&
                printf "export GEM_PATH=$paths\n" >>$ENV
            printf "export PATH=\$PATH:\$GEM_PATH:\$GEM_HOME/bin\n" >>$ENV
        fi
    fi

    general_r() {
        sudo cp $genr /root/.bash_aliases.d/
        sudo cp $genrc /root/.bash_completion.d/
    }
    general() {
        cp $genr ~/.bash_aliases.d/
        cp $genrc ~/.bash_completion.d/
        yes-edit-no -y -Y 'YELLOW' -f general_r -p "Install general.sh at /root/?" -g "$genr $genrc"
    }
    yes-edit-no -p "Install general.sh at ~/?" -f general -g "$genr $genrc"
fi

pre='both'
othr='exit intr n'
color='GREEN'
prmpt='[Both/exit/intr/n]: '

echo "Next $(tput setaf 1)sudo$(tput sgr0) will check for interrupt traps to terminate background processes in /root/.bashrc'"
if grep -q "trap '! \[ -z \"\$(jobs -p)\" ] && kill -9 \$(jobs -p.*" ~/.bashrc || sudo grep -q "trap '! [ -z \"\$(jobs -p)\" ] && kill -9 \$(jobs -p.*" /root/.bashrc; then
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

update_sysm=aliases/.bash_aliases.d/update-system.sh
bashc=aliases/.bash_aliases.d/bash.sh
update_kern=aliases/.bash_aliases.d/update-kernel.sh
pacmn=aliases/.bash_aliases.d/package_managers.sh
rgrp=aliases/.bash_aliases.d/ripgrep-directory.sh
[[ $distro == "Manjaro" ]] && manjaro=aliases/.bash_aliases.d/manjaro.sh
hash systemctl &>/dev/null && systemd=aliases/.bash_aliases.d/systemctl.sh
hash sudo &>/dev/null && dosu=aliases/.bash_aliases.d/sudo.sh
hash git &>/dev/null && gits=aliases/.bash_aliases.d/git.sh
hash ssh &>/dev/null && sshs=aliases/.bash_aliases.d/ssh.sh
ps1=aliases/.bash_aliases.d/PS1_colours.sh
variti=aliases/.bash_aliases.d/variety.sh
hash python &>/dev/null && pthon=aliases/.bash_aliases.d/python.sh
if ! test -d aliases/.bash_aliases.d/; then
    tmp=$(mktemp) && curl -o $tmp https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/bash.sh && bash=$tmp
    tmp1=$(mktemp) && curl -o $tmp1 https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/update-system.sh && update_sysm=$tmp1
    tmp11=$(mktemp) && curl -o $tmp11 https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/update-kernel.sh && update_kern=$tmp11
    rgrp=$(mktemp) && curl -o $rgrp https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/ripgrep-directory.sh 
    tmp3=$(mktemp) && curl -o $tmp4 https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/package_managers.sh && pacmn=$tmp4
    [[ $distro == "Manjaro" ]] && tmp7=$(mktemp) && curl -o $tmp7 https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/manjaro.sh && manjaro=$tmp7
    hash systemctl &>/dev/null && tmp2=$(mktemp) && curl -o $tmp2 https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/systemctl.sh && systemd=$tmp2
    hash sudo &>/dev/null && tmp3=$(mktemp) && curl -o $tmp3 https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/sudo.sh && dosu=$tmp3
    hash git &>/dev/null && tmp10=$(mktemp) && curl -o $tmp10 https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/git.sh && gits=$tmp5
    hash ssh &>/dev/null && tmp5=$(mktemp) && curl -o $tmp5 https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/ssh.sh && sshs=$tmp5
    tmp6=$(mktemp) && curl -o $tmp6 https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/ps1.sh && ps1=$tmp6
    tmp8=$(mktemp) && curl -o $tmp8 https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/variety.sh && variti=$tmp8
    hash python &>/dev/null && tmp9=$(mktemp) && curl -o $tmp9 https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/python.sh && pthon=$tmp9
fi

bash_r() {
    sudo cp $bashc /root/.bash_aliases.d/
}
bash_u() {
    cp $bashc ~/.bash_aliases.d/
    yes-edit-no -f bash_r -g "$bashc" -p "Install bash.sh at /root/.bash_aliases.d/?" 
}
yes-edit-no -f bash_u -g "$bashc" -p "Install bash.sh at ~/.bash_aliases.d/? (a few bash related helper functions)?"

update_sysm_r() {
    sudo cp $update_sysm /root/.bash_aliases.d/
    sudo sed -i '/SYSTEM_UPDATED="TRUE"/d' /root/.bash_aliases.d/update-system.sh
    sudo cp $update_kern /root/.bash_aliases.d/
}

update_sysm() {
    cp  $update_sysm ~/.bash_aliases.d/
    sed -i '/SYSTEM_UPDATED="TRUE"/d' ~/.bash_aliases.d/update-system.sh
    cp  $update_kern ~/.bash_aliases.d/

    if [[ $distro_base == 'Debian' ]]; then
        
        if ! hash mainline &>/dev/null; then
            printf "${CYAN}mainline${normal} is not installed (GUI and cmd tool for managing installation of (newer) kernel versions)\n"
            readyn -p "Install mainline?" mainl_ins
            if [[ $mainl_ins == 'y' ]]; then
                if test -z "$(apt list --installed software-properties-common 2>/dev/null | awk 'NR>1{print;}')"; then
                    sudo apt install -y software-properties-common
                fi 
                sudo add-apt-repository ppa:cappelikan/ppa 
                eval "${pac_up}" 
                sudo apt install -y mainline
            fi
            unset mainl_ins
        fi
    fi
    
    if ! hash xmllint &>/dev/null; then
        printf "${CYAN}xmllint${normal} is not installed (cmd tool for lint xml/html - used in helper script for checking on latest LTS kernel)\n"
        readyn -p "Install xmllint?" xml_ins
        if [[ $xml_ins == 'y' ]]; then
            if [[ "$distro_base" == 'Debian' ]]; then
                sudo apt install -y libxml2-utils
            elif [[ "$distro_base" == 'Arch' ]]; then
                sudo pacman -Su --noconfirm libxml2 
            fi
        fi
        unset xml_ins
    fi
    yes-edit-no -Y "YELLOW" -f update_sysm_r -g "$update_sysm" -p "Install update-system.sh and update-kernel.sh at /root/.bash_aliases.d//?" 
}
yes-edit-no -f update_sysm -g "$update_sysm $update_kern" -p "Install update-system.sh and update-kernel.sh at ~/.bash_aliases.d/? (Global system update function)?"

packman_r() {
    sudo cp $pacmn /root/.bash_aliases.d/
}
packman() {
    cp $pacmn ~/.bash_aliases.d/
    yes-edit-no -Y 'YELLOW' -f packman_r -g "$pacmn" -p "Install package_managers.sh at /root/.bash_aliases.d/?"
}
yes-edit-no -f packman -g "$pacmn" -p "Install package_managers.sh at ~/.bash_aliases.d/ (package manager aliases)?" 

rgrep_r() {
    sudo cp $rgrp /root/.bash_aliases.d/
}
rgrep() {
    cp $rgrp ~/.bash_aliases.d/
    yes-edit-no -Y 'YELLOW' -f rgrep_r -g "$rgrp" -p "Install ripgrep-directory.sh at /root/.bash_aliases.d/?"
}
yes-edit-no -f rgrep -g "$rgrp" -p "Install ripgrep-directory.sh at ~/.bash_aliases.d/ (search files through pattern in directory)?" 


if [[ "$distro" == "Manjaro" ]]; then
    manj_r() {
        sudo cp $manjaro /root/.bash_aliases.d/
    }
    manj() {
        cp $manjaro ~/.bash_aliases.d/
        yes-edit-no -Y 'YELLOW' -f manj_r -g "$manjaro" -p "Install manjaro.sh at /root/.bash_aliases.d/?"
    }
    yes-edit-no -f manj -g "$manjaro" -p "Install manjaro.sh at ~/.bash_aliases.d/ (manjaro specific aliases)?"
fi

systemd_r() {
    sudo cp $systemd /root/.bash_aliases.d/
}
systemd() {
    cp $systemd ~/.bash_aliases.d/
    yes-edit-no -Y 'YELLOW' -f systemd_r -g "$systemd" -p "Install systemctl.sh at /root/.bash_aliases.d/?"
}
yes-edit-no -f systemd -g "$systemd" -p "Install systemctl.sh at ~/.bash_aliases.d/? (systemctl aliases/functions)?"

dosu_r() {
    sudo cp $dosu /root/.bash_aliases.d/
}

dosu() {
    cp $dosu ~/.bash_aliases.d/
    yes-edit-no -Y 'YELLOW' -f dosu_r -g "$dosu" -p "Install sudo.sh at /root/.bash_aliases.d/?"
}
yes-edit-no -f dosu -g "$dosu" -p "Install sudo.sh at ~/.bash_aliases.d/ (sudo aliases)?"

git_r() {
    sudo cp $gits /root/.bash_aliases.d/
}
gith() {
    cp $gits ~/.bash_aliases.d/
    yes-edit-no -Y 'YELLOW' -f git_r -g "$gits" -p "Install git.sh at /root/.bash_aliases.d/?"
}
yes-edit-no -f gith -g "$gits" -p "Install git.sh at ~/.bash_aliases.d/ (git aliases)?" 

ssh_r() {
    sudo cp $sshs /root/.bash_aliases.d/
}
sshh() {
    cp $sshs ~/.bash_aliases.d/
    yes-edit-no -Y 'YELLOW' -f ssh_r -g "$sshs" -p "Install ssh.sh at /root/.bash_aliases.d/?" 
}
yes-edit-no -f sshh -g "$sshs" -p "Install ssh.sh at ~/.bash_aliases.d/ (ssh aliases)?" 

ps1_r() {
    sudo cp $ps1 /root/.bash_aliases.d/
}
ps11() {
    cp $ps1 ~/.bash_aliases.d/
    yes-edit-no -Y 'YELLOW' -f ps1_r -g "$ps1" -p "Install PS1_colours.sh at /root/.bash_aliases.d/?" 
}
yes-edit-no -f ps11 -g "$ps1" -p "Install PS1_colours.sh at ~/.bash_aliases.d/ (Coloured command prompt)?" 

if hash python &>/dev/null; then
    pthon() {
        cp $pthon ~/.bash_aliases.d/
    }
    yes-edit-no -f pthon -g "$pthon" -p "Install python.sh at ~/.bash_aliases.d/ (aliases for a python development)?"
fi

# Variety aliases
#
variti_r() {
    sudo cp $variti /root/.bash_aliases.d/
}
variti() {
    cp $variti ~/.bash_aliases.d/
    yes-edit-no -Y 'YELLOW' -f variti_r -g "$variti" -p "Install variety.sh at /root/?"
}
yes-edit-no -f variti -g "$variti" -p "Install variety.sh at ~/.bash_aliases.d/ (aliases for a variety of tools)?"

# Check one last time if ~/.bash_preexec - for both $USER and root - is the last line in their ~/.bash_profile and ~/.bashrc

if ! test -f ./checks/check_bash_source_order.sh; then
    if hash curl &>/dev/null; then
        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_bash_source_order.sh)
    else
        printf "If not downloading/git cloning the scriptfolder, you should at least install 'curl' beforehand when expecting any sort of succesfull result...\n"
        return 1 || exit 1
    fi
else
    . ./checks/check_bash_source_order.sh
fi

test -n "$BASH_VERSION" && source ~/.bashrc &>/dev/null
test -n "$ZSH_VERSION" && source ~/.zshrc &>/dev/null
