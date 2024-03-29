#!/bin/bash

if ! test -f checks/check_distro.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_distro.sh)" 
else
    . ./checks/check_distro.sh
fi
if ! test -f checks/check_pathvar.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_pathvar.sh)" 
else
    . ./checks/check_pathvar.sh
fi
if ! test -f checks/check_rlwrap.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_rlwrap.sh)" 
else
    . ./checks/check_rlwrap.sh
fi

if ! test -f aliases/rlwrap_scripts.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/rlwrap_scripts.sh)" 
else
    . ./aliases/rlwrap_scripts.sh
fi

printf "${green}If all necessary files are sourced correctly, this text looks green.\nIf not, something went wrong.\n"
printf "\n${green}Files that get overwritten get backed up and trashed (to prevent clutter).\nRecover using ${cyan}'gio trash --list'${green} and ${cyan}'gio trash --restore' ${normal}\n"


if [ -z "$TMPDIR" ]; then
    TMPDIR=/tmp
fi

if [ ! -e ~/config ] && test -d ~/.config; then
    reade -Q "BLUE" -i "y" -p "Create ~/.config to ~/config symlink? [Y(es)/n(o)]:" "y n" sym1
    if [ -z $sym1 ] || [ "y" == $sym1 ]; then
        ln -s ~/.config ~/config
    fi
fi

if [ ! -e ~/lib_systemd ] && test -d ~/lib/systemd/system; then
    reade -Q "BLUE" -i "y" -p "Create /lib/systemd/system/ to user directory symlink? [Y/n]:" "y n" sym2
    if [ -z $sym2 ] || [ "y" == $sym2 ]; then
        ln -s /lib/systemd/system/ ~/lib_systemd
    fi
fi

if [ ! -e ~/etc_systemd ] && test -d ~/etc/systemd/system; then
    reade -Q "BLUE" -i "y" -p "Create /etc/systemd/system/ to user directory symlink? [Y/n]:" "y n" sym3
    if [ -z $sym3 ] || [ "y" == $sym3 ]; then
        ln -s /etc/systemd/system/ ~/etc_systemd
    fi
fi

if [ ! -f /etc/modprobe.d/nobeep.conf ]; then
    reade -Q "GREEN" -i "y" -p "Remove terminal beep? (blacklist pcspkr) [Y/n]:" "y n" beep
    if [ "$beep" == "y" ] || [ -z "$beep" ]; then
        echo "blacklist pcspkr" | sudo tee /etc/modprobe.d/nobeep.conf
    fi
fi

unset sym1 sym2 sym3 beep

if [ "$distro_base" == "Arch" ]; then
    if ! test -f install_AUR-helper.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_AUR-helper.sh)" 
    else
        . ./install_AUR-helper.sh
    fi 
fi

if ! type flatpak &> /dev/null; then
    printf "%s\n" "${blue}No flatpak detected. (Independent package manager from Red Hat)${normal}"
    reade -Q "GREEN" -i "y" -p "Install? [Y/n]:" "y n" insflpk 
    if [ "y" == "$insflpk" ]; then
        if ! test -f install_flatpak.sh; then
            eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_flatpak.sh)" 
        else
            ./install_flatpak.sh 
        fi 
    fi
fi
unset insflpk

if ! type snap &> /dev/null; then
    printf "%s\n" "${blue}No snap detected. (Independent package manager from Canonical)${normal}"
    reade -Q "GREEN" -i "n" -p "Install? [Y/n]:" "y n" inssnap 
    if [ "y" == "$inssnap" ]; then
        if ! test -f install_snapd.sh; then
            eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_snapd.sh)" 
        else
            ./install_snapd.sh 
        fi 
    fi
fi
unset inssnap

if ! sudo test -f /etc/polkit/49-nopasswd_global.pkla && ! sudo test -f /etc/polkit-1/rules.d/90-nopasswd_global.rules; then
    reade -Q "YELLOW" -i "n" -p "Install polkit files for automatic authentication for passwords? [Y/n]:" "y n" plkit
    if [ "y" == "$plkit" ]; then
        if ! test -f install_polkit_wheel.sh; then
            eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_polkit_wheel.sh)" 
        else
            ./install_polkit_wheel.sh
        fi 
    fi
    unset plkit
fi

# Pathvariables

#if [ ! -f ~/.pathvariables.env ]; then
    pathvr=.pathvariables.env
    if ! test -f .pathvariables.env; then
        wget https://raw.githubusercontent.com/excited-bore/dotfiles/main/.pathvariables.env -P $TMPDIR/
        pathvr=$TMPDIR/.pathvariables.env
    fi
    reade -Q "GREEN" -i "y" -p "Check existence (and create) ~/.pathvariables.env and link it to .bashrc? [Y/n]:" "y n" pathvars
    if [ "$pathvars" == "y" ] || [ -z "$pathvars" ]; then
        
        #Comment out every export in .pathvariables
        sed -i -e '/export/ s/^#*/#/' $pathvr

        # Set tmpdir
        sed 's|#export TMPDIR|export TMPDIR|' -i $pathvr

        # Package Managers
        reade -Q "YELLOW" -i "y" -p "Check and create DIST,DIST_BASE,ARCH,PM and WRAPPER? (distro, distro base, architecture, package manager and pm wrapper) [Y/n]:" "y n" Dists
        if [ "$Dists" == "y" ]; then
           printf "NOT YET IMPLEMENTED\n"
        fi
        
        # TODO: non ugly values
        reade -Q "YELLOW" -i "n" -p "Set LS_COLORS with some predefined values? (WARNING: ugly values) [Y/n]:" "y n" lsclrs
        if [ "$lsclrs" == "y" ] || [ -z "$lsclrs" ]; then
            sed 's/^#export LS_COLORS/export LS_COLORS/' -i $pathvr
        fi
        
        if type nvim &> /dev/null; then
            reade -Q "GREEN" -i "y" -p "Set Neovim as MANPAGER? [Y/n]: " "y n" manvim
            if [ "$manvim" == "y" ]; then
               sed -i 's|.export MANPAGER=.*|export MANPAGER='\''nvim +Man!'\''|g' $pathvr 
            fi
        fi
        
        reade -Q "GREEN" -i "y" -p "Set PAGER? (Page reader) [Y/n]:" "y n" pgr
        if [ "$pgr" == "y" ] || [ -z "$pgr" ]; then
            
            # Uncomment export PAGER=
            sed 's/^#export PAGER=/export PAGER=/' -i $pathvr
            
            pagers="less more"
            prmpt="${green} \tless = Default pager - Basic, archaic but very customizable\n\tmore = Preinstalled other pager - leaves text by default, less customizable (ironically)\n"
            if type most &> /dev/null; then
                pagers="$pagers most"
                prmpt="$prmpt \tmost = Installed pager that is very customizable\n"
            fi
            if type moar &> /dev/null; then
                pagers="$pagers moar"
                prmpt="$prmpt \tmoar = Installed pager with an awesome default configuration\n"
            fi
            printf "$prmpt"
            reade -Q "GREEN" -i "less" -p "PAGER=" "$pagers" pgr2
            pgr2=$(whereis "$pgr2" | awk '{print $2}')
            sed -i 's|export PAGER=.*|export PAGER='$pgr2'|' $pathvr
            if grep -q "less" "$pgr2"; then
                sed -i 's|#export LESS=|export LESS="*"|g' $pathvr
                lss=$(cat .pathvariables.env | grep 'export LESS="*"' | sed 's|export LESS="\(.*\)"|\1|g')
                lss_n=""
                for opt in ${lss}; do
                    opt1=$(echo "$opt" | sed 's|--\(\)|\1|g' | sed 's|\(\)\=.*|\1|g')
                    if (man less | grep -Fq "${opt1}") 2> /dev/null; then
                        lss_n="$lss_n $opt"
                    fi
                done
                sed -i "s|export LESS=.*|export LESS=\" $lss_n\"|g" $pathvr
                unset lss lss_n opt opt1
                #sed -i 's/#export LESSEDIT=/export LESSEDIT=/' .pathvariables.env
            fi
            if grep -q "moar" "$pgr2"; then
                sed -i 's/#export MOAR=/export MOAR=/' $pathvr
            fi

        fi
        unset prmpt

        reade -Q "GREEN" -i "y" -p "Set EDITOR and VISUAL? [Y/n]:" "y n" edtvsl
        if [ "$edtvsl" == "y" ] || [ -z "$edtvsl" ]; then
            editors="nano vi"
            prmpt="${green}\tnano = Default editor - Basic, but userfriendly\n\tvi = Other preinstalled editor - Archaic and non-userfriendly editor\n" 
            if type micro &> /dev/null; then
                editors="$pagers micro"
                prmpt="$prmpt \tMicro = Relatively good out-of-the-box editor - Decent keybindings, yet no customizations\n"
            fi
            if type ne &> /dev/null; then
                editors="$pagers ne"
                prmpt="$prmpt \tNice editor = Relatively good out-of-the-box editor - Decent keybindings, yet no customizations\n"
            fi
            if type vim &> /dev/null; then
                editors="$editors vim"
                prmpt="$prmpt \tVim = The one and only true modal editor - Not userfriendly, but many features (maybe even too many) and greatly customizable\n"
                sed -i "s|#export MYVIMRC=|export MYVIMRC=|g" $pathvr
                sed -i "s|#export MYGVIMRC=|export MYGVIMRC=|g" $pathvr
            fi
            if type nvim &> /dev/null; then                                  
                editors="$editors nvim"
                prmpt="$prmpt \tNeovim = A better vim? - Faster and less buggy then regular vim, even a little userfriendlier\n"
                sed -i "s|#export MYVIMRC=|export MYVIMRC=|g" $pathvr
                sed -i "s|#export MYGVIMRC=|export MYGVIMRC=|g" $pathvr
            fi
            if type emacs &> /dev/null; then
                editors="$editors emacs"
                prmpt="$prmpt \tEmacs = One of the oldest and versatile editors - Modal and featurerich, but overwhelming as well\n"
            fi
            printf "$prmpt"
            reade -Q "GREEN" -i "nano" -p "EDITOR (Terminal)=" "$editors" edtor
            if [ "$edtor" == "emacs" ]; then
                edtor="emacs -nw"
            fi
            edtor=$(whereis "$edtor" | awk '{print $2}')
            sed -i 's|#export EDITOR=.*|export EDITOR='$edtor'|g' $pathvr
            
            # Make .txt file and output file
            touch $TMPDIR/editor-outpt
            # Redirect output to file in subshell (mimeopen gives output but also starts read. This cancels read). In tmp because that gets cleaned up
            (echo "" | mimeopen -a editor-check.sh &> $TMPDIR/editor-outpt)
            compedit=$(cat $TMPDIR/editor-outpt | awk 'NR > 2' | awk '{if (prev_1_line) print prev_1_line; prev_1_line=prev_line} {prev_line=$NF}' | sed 's|[()]||g' | tr -s [:space:] \\n | uniq | tr '\n' ' ')
            frst="$(echo $compedit | awk '{print $1}')"
            reade -Q "GREEN" -i "$frst" -p "VISUAL (GUI editor)=" "$compedit" vsual
            vsual=$(whereis "$vsual" | awk '{print $2}')
            sed -i 's|#export VISUAL=.*|export VISUAL='$vsual'|' $pathvr
        fi
        unset edtvsl compedit frst editors prmpt

        # Set DISPLAY
        addr=$(nmcli device show | grep IP4.ADDR | awk 'NR==1{print $2}'| sed 's|\(.*\)/.*|\1|')
        #reade -Q "GREEN" -i "n" -p "Set DISPLAY to ':$(addr).0'? [Y/n]:" "y n" dsply
        if [[ $- =~ i ]] && [[ -n "$SSH_TTY" ]]; then
            reade -Q "YELLOW" -i "n" -p "Detected shell is SSH. For X11, it's more reliable performance to dissallow shared clipboard (to prevent constant hanging). Set DISPLAY to 'localhost:10.0'? [Y/n]:" "y n" dsply
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
            sed -i 's|#export \(PATH=$PATH:$HOME/.local/bin/flatpak\)|\1|g' $pathvr
        fi
        unset snapvrs

        # TODO do something for flatpak  (XDG_DATA_DIRS)
        # Check if xdg installed
        if type xdg-open &> /dev/null ; then
            prmpt="${green}This will set XDG pathvariables to their respective defaults\n\
            XDG is related to default applications\n\
            Setting these could be usefull when installing certain programs \n\
            Defaults:\n\
            - XDG_CACHE_HOME=$HOME/.cache\n\
            - XDG_CONFIG_HOME=$HOME/.config\n\
            - XDG_CONFIG_DIRS=/etc/xdg\n\
            - XDG_DATA_HOME=$HOME/.local/share\n\
            - XDG_DATA_DIRS=/usr/local/share/:/usr/share\n\
            - XDG_STATE_HOME=$HOME/.local/state\n"
            printf "$prmpt"
            reade -Q "GREEN" -i "y" -p "Set XDG environment? [Y/n]: " "y n" xdgInst
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
            prmpt="${yellow}\tThis will set SYSTEMD pathvariables\n\
            When setting a new pager for systemd or changing logging specifics\n\
            Defaults:\n\
            - SYSTEMD_PAGER=$PAGER\n\
            - SYSTEMD_COLORS=256\n\
            - SYSTEMD_PAGERSECURE=1\n\
            - SYSTEMD_LESS=\"FRXMK\"\n\
            - SYSTEMD_LOG_LEVEL=\"warning\"\n\
            - SYSTEMD_LOG_COLOR=\"true\"\n\
            - SYSTEMD_LOG_TIME=\"true\"\n\
            - SYSTEMD_LOG_LOCATION=\"true\"\n\
            - SYSTEMD_LOG_TID=\"true\"\n\
            - SYSTEMD_LOG_TARGET=\"auto\"\n\
            "
            printf "$prmpt"
            reade -Q "YELLOW" -i "y" -p "Set systemd environment? [Y/n]: " "y n" xdgInst
            if [ -z "$xdgInst" ] || [ "y" == "$xdgInst" ]; then
                sed 's/^#export SYSTEMD_PAGER=\(.*\)/export SYSTEMD_PAGER=\1/' -i $pathvr 
                sed 's/^#export SYSTEMD_PAGERSECURE=\(.*\)/export SYSTEMD_PAGERSECURE=\1/' -i $pathvr
                sed 's/^#export SYSTEMD_COLORS=\(.*\)/export SYSTEMD_COLORS=\1/' -i $pathvr
                sed 's/^#export SYSTEMD_LESS=\(.*\)/export SYSTEMD_LESS=\1/' -i $pathvr    
                sed 's/^#export SYSTEMD_LOG_LEVEL=\(.*\)/export SYSTEMD_LOG_LEVEL=\1/' -i $pathvr
                sed 's/^#export SYSTEMD_LOG_TIME=\(.*\)/export SYSTEMD_LOG_TIME=\1/' -i $pathvr
                sed 's/^#export SYSTEMD_LOG_LOCATION=\(.*\)/export SYSTEMD_LOG_LOCATION=\1/' -i $pathvr
                sed 's/^#export SYSTEMD_LOG_TID=\(.*\)/export SYSTEMD_LOG_TID=\1/' -i $pathvr
                sed 's/^#export SYSTEMD_LOG_TARGET=\(.*\)/export SYSTEMD_LOG_TARGET=\1/' -i $pathvr
            fi
        fi

        pathvariables_r(){ 
             if ! sudo grep -q "~/.pathvariables.env" /root/.bashrc; then
                printf "if [[ -f ~/.pathvariables.env ]]; then\n" | sudo tee -a /root/.bashrc
                printf "  . ~/.pathvariables.env\n" | sudo tee -a /root/.bashrc
                printf "fi\n" | sudo tee -a /root/.bashrc
            fi
            sudo cp -fv $pathvr /root/.pathvariables.env;
        }                                            
        pathvariables(){
            if ! grep -q "~/.pathvariables.env" ~/.bashrc; then
                echo "if [[ -f ~/.pathvariables.env ]]; then" >> ~/.bashrc
                echo "  . ~/.pathvariables.env" >> ~/.bashrc
                echo "fi" >> ~/.bashrc
            fi
            cp -fv $pathvr ~/.pathvariables.env
            yes_edit_no pathvariables_r "$pathvr" "Install .pathvariables.env at /root/?" "edit" "YELLOW"; 
        }
        yes_edit_no pathvariables "$pathvr" "Install .pathvariables.env at ~/? " "edit" "GREEN"
    fi
#fi

# Shell-keybinds

#if grep -q 'bind -x '\''"\\C-s": ctrl-s'\''' ~/keybinds.bash && ! grep -q '#bind -x '\''"\\C-s": ctrl-s'\''' ~/keybinds.bash; then
#    sed -i 's|bind -x '\''"\\C-s": ctrl-s'\''|#bind -x '\''"\\C-s": ctrl-s'\''|g' ~/keybinds.bash
#    sed -i 's|bind -x '\''"\\eOR": ctrl-s'\''|#bind -x '\''"\\eOR": ctrl-s'\''|g' ~/keybinds.bash
#fi

shell-keybinds_r(){ 
    if [ -f /root/.pathvariables.env ]; then
       sudo sed -i 's|#export INPUTRC|export INPUTRC|g' /root/.pathvariables.env
    fi
    sudo cp -fv keybinds/keybinds.bash /root/.keybinds.d/;
    sudo cp -fv keybinds/.inputrc /root/ ;

    # X based settings is generally not for root and will throw errors 
    if sudo grep -q '^setxkbmap' /root/.keybinds.d/keybinds.bash; then
        sudo sed -i 's|setxkbmap|#setxkbmap|g' /root/.keybinds.d/keybinds.bash
    fi
}
shell-keybinds() {
    
    if ! test -f checks/check_keybinds.sh; then
         eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_keybinds.sh)" 
    else
        . ./checks/check_keybinds.sh
    fi
    binds=keybinds/.inputrc
    binds1=keybinds/keybinds.bash
    if ! test -f keybinds/.inputrc; then
        wget https://raw.githubusercontent.com/excited-bore/dotfiles/main/keybinds/.inputrc -P $TMPDIR/
        binds=$TMPDIR/.inputrc
        binds1=$TMPDIR/keybinds.bash
    fi
    reade -Q "GREEN" -i "y" -p "Enable vi-mode instead of emacs mode? [Y/n]: " "y n" vimde
    if [ "$vimde" == "y" ]; then
        sed -i "s|.set editing-mode .*|set editing-mode vi|g" $binds
    fi
    reade -Q "GREEN" -i "y" -p "Enable visual que for vi/emacs toggle? (Displayed as '(ins)/(cmd)/(emacs)') [Y/n]: " "y n" vivisual
    if [ "$vivisual" == "y" ]; then
        sed -i "s|.set show-mode-in-prompt .*|set show-mode-in-prompt on|g" $binds
    fi
    reade -Q "GREEN" -i "y" -p "Set caps to escape? (Might cause X11 errors with SSH) [Y/n]: " "y n" xtrm
    if [ "$xtrm" != "y" ] && ! [ -z "$xtrm" ]; then
        sed -i "s|setxkbmap |#setxkbmap |g" $binds
    fi
    cp -fv $binds1 ~/.keybinds.d/
    cp -fv $binds ~/
    if [ -f ~/.pathvariables.env ]; then
       sed -i 's|#export INPUTRC|export INPUTRC|g' ~/.pathvariables.env
    fi
    unset vimde vivisual xterm
    yes_edit_no shell-keybinds_r "keybinds/.inputrc keybinds/keybinds.bash" "Install .inputrc and keybinds.bash at /root/ and /root/.keybinds.d/?" "edit" "YELLOW"; 
}
yes_edit_no shell-keybinds "keybinds/.inputrc keybinds/keybinds.bash" "Install .inputrc and keybinds.bash at ~/ and ~/.keybinds.d/? (keybinds configuration)" "edit" "YELLOW"

# Xresources

xterm=xterm/.Xresources
if ! test -f keybinds/.inputrc; then
    wget https://raw.githubusercontent.com/excited-bore/dotfiles/main/xterm/.Xresources -P $TMPDIR/
    xterm=$TMPDIR/.Xresources
fi

xresources_r(){
    sudo cp -fv $xterm /root/.Xresources;
    }
xresources() {
    cp -fv $xterm ~/.Xresources;
    yes_edit_no xresources_r "$xterm" "Install .Xresources at /root/.bash_aliases.d/?" "edit" "RED"; }
yes_edit_no xresources "$xterm" "Install .Xresources at ~/.bash_aliases.d/? (keybinds config)" "edit" "YELLOW"
    

if ! test -f checks/check_completions_dir.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_completions_dir.sh)" 
else
    . ./checks/check_completions_dir.sh
fi


# Bash alias completions
reade -Q "GREEN" -i "y" -p "Install bash completions for aliases in ~/.bash_completion.d? [Y/n]:" "y n" compl
if [ -z $compl ] || [ "y" == $compl ]; then
    if ! test -f install_bashalias_completions.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_bashalias_completions.sh)" 
    else
        ./install_bashalias_completions.sh
    fi 
fi
unset compl

# Python completions
reade -Q "GREEN" -i "y" -p "Install python completions in ~/.bash_completion.d? [Y/n]:" "y n" pycomp
if [ -z $pycomp ] || [ "y" == $pycomp ]; then
    if ! test -f install_python_completions.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_python_completions.sh)" 
    else
        ./install_python_completions.sh
    fi
fi
unset pycomp


# Osc
#reade -Q "GREEN" -i "y" -p "Install Osc52 clipboard? (Universal clipboard tool / works natively over ssh) [Y/n]: " "y n" osc
#if [ -z $osc ] || [ "Y" == $osc ] || [ $osc == "y" ]; then
#    ./install_osc.sh 
#fi
#unset osc

# Bat
reade -Q "GREEN" -i "y" -p "Install Bat? (Cat clone with syntax highlighting) [Y/n]: " "y n" bat
if [ -z $bat ] || [ "Y" == $bat ] || [ $bat == "y" ]; then
    if ! test -f install_bat.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_bat.sh)" 
    else
        ./install_bat.sh 
    fi
fi
unset bat

# Fzf (Fuzzy Finder)
reade -Q "GREEN" -i "y" -p "Install fzf? (Fuzzy file/folder finder - keybinding yes for upgraded Ctrl-R/reverse-search, fzf filenames on Ctrl+T and fzf-version of 'cd' on Alt-C + Custom script: Ctrl-f becomes system-wide file opener) [Y/n]: " "y n" findr
if [ "y" == "$findr" ]; then
    if ! test -f install_fzf.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_fzf.sh)" 
    else
        ./install_fzf.sh
    fi
fi
unset findr

# Neofetch
if ! type neofetch &> /dev/null; then
    reade -Q "GREEN" -i "y" -p "Install neofetch? (System information tool) [Y/n]:" "y n" tojump
    if [ "$tojump" == "y" ]; then
        if ! test -f install_neofetch.sh; then
            eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_neofetch.sh)" 
        else
            ./install_neofetch.sh
        fi
    fi
    unset tojump
fi

# Bashtop
if ! type bashtop &> /dev/null; then
    reade -Q "GREEN" -i "y" -p "Install bashtop? (Python based improved top/htop) [Y/n]:" "y n" tojump
    if [ "$tojump" == "y" ]; then
        if ! test -f install_bashtop.sh; then
            eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_bashtop.sh)" 
        else
            ./install_bashtop.sh
        fi
    fi
    unset tojump
fi

# Autojump
if ! type autojump &> /dev/null; then
    reade -Q "GREEN" -i "y" -p "Install autojump? (jump to folders using 'bookmarks' - j_ ) [Y/n]:" "y n" tojump
    if [ "$tojump" == "y" ]; then
        if ! test -f install_autojump.sh; then
            eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_autojump.sh)" 
        else
            ./install_autojump.sh
        fi
    fi
    unset tojump
fi

# Starship
if ! type starship &> /dev/null; then
    reade -Q "GREEN" -i "y" -p "Install Starship? (Snazzy looking prompt) [Y/n]: " "y n" strshp
    if [ $strshp == "y" ]; then
        if ! test -f install_starship.sh; then
            eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_starship.sh)" 
        else
            ./install_starship.sh 
        fi
    fi
    unset strshp
fi


# Moar (Custom pager instead of less)
reade -Q "GREEN" -i "y" -p "Install moar? (Custom pager instead of less with linenumbers) [Y/n]: " "y n" moar
if [ -z $moar ] || [ "Y" == $moar ] || [ $moar == "y" ]; then
    if ! test -f install_moar.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_moar.sh)" 
    else
        ./install_moar.sh 
    fi
fi
unset moar

# Nvim (Editor)
reade -Q "GREEN" -i "y" -p "Install Neovim? (Terminal editor) [Y/n]: " "y n" nvm
if [ "y" == "$nvm" ]; then
    if ! test -f install_nvim.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_nvim.sh)" 
    else
        ./install_nvim.sh
    fi
fi
unset nvm

# Git
if ! test -f install_git.sh; then
    eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_git.sh)" 
else
    ./install_git.sh
fi


# Ranger (File explorer)
reade -Q "GREEN" -i "y" -p "Install Ranger? (Terminal file explorer) [Y/n]: " "y n" rngr
if [ "y" == "$rngr" ]; then
    if ! test -f install_ranger.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_ranger.sh)" 
    else
        ./install_ranger.sh
    fi
fi
unset rngr

# Tmux (File explorer)
reade -Q "GREEN" -i "y" -p "Install tmux? (Terminal multiplexer) [Y/n]: " "y n" tmx
if [ "y" == "$tmx" ]; then
    if ! test -f install_tmux.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_tmux.sh)" 
    else
        ./install_tmux.sh
    fi
fi
unset tmx

# Kitty (Terminal emulator)
reade -Q "GREEN" -i "y" -p "Install Kitty? (Terminal emulator) [Y/n]: " "y n" kittn
if [ "y" == "$kittn" ]; then
    if ! test -f install_kitty.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_kitty.sh)" 
    else
        ./install_kitty.sh
    fi
fi
unset kittn

# Srm (Secure remove)
if ! type srm &> /dev/null; then
    reade -Q "GREEN" -i "y" -p "Install srm? (Secure remove) [Y/n]: " "y n" kittn
    if [ "y" == "$kittn" ]; then
        if ! test -f install_srm.sh; then
            eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_srm.sh)" 
        else
            ./install_srm.sh
        fi
    fi
    unset kittn
fi

# Testdisk (File recovery tool)
if ! type testdisk &> /dev/null; then
    reade -Q "GREEN" -i "y" -p "Install testdisk? (File recovery tool) [Y/n]: " "y n" kittn
    if [ "y" == "$kittn" ]; then
        if ! test -f install_testdisk.sh; then
            eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_testdisk.sh)" 
        else
            ./install_testdisk.sh
        fi
    fi
    unset kittn
fi

reade -Q "GREEN" -i "y" -p "Install bash aliases and other config? [Y/n]:" "y n" scripts
if [ -z $scripts ] || [ "y" == $scripts ]; then

    if ! test -f checks/check_aliases_dir.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/checks/check_aliases_dir.sh)" 
    else
        ./checks/check_aliases_dir.sh
    fi
    
    genr=aliases/general.sh
    if ! test -f aliases/general.sh; then
        wget https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/general.sh -P $TMPDIR/
        genr=$TMPDIR/general.sh
    fi

    general_r(){ 
        if ! test -f checks/check_aliases_dir.sh; then
            eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/checks/check_aliases_dir.sh)" 
        else
            ./checks/check_aliases_dir.sh
        fi
        sudo cp -fv $genr /root/.bash_aliases.d/;
    }
    general(){
        if test -f ~/.pathvariables.env; then
            sed -i 's|^export TRASH_BIN_LIMIT=|export TRASH_BIN_LIMIT=|g' ~/.pathvariables.env
        fi
        local ansr
        reade -Q "GREEN" -i "y" -p "Set cp/mv (when overwriting) to backup files? (will also trash backups):" "y n" ansr         
        if [ "$ansr" != "y" ]; then
            sed -i 's|alias cp="cp-trash -rv"|#alias cp="cp-trash -rv"|g' $genr
            sed -i 's|alias mv="mv-trash -v"|#alias mv="mv-trash -v"|g' $genr
        fi
        unset ansr
        reade -Q "YELLOW" -i "n" -p "Set 'gio trash' alias for rm? [Y/n]:" "y n" ansr 
        if [ "$ansr" != "y" ]; then
            sed -i 's|alias rm="trash"|#alias rm="trash"|g' $genr
        fi
        if type bat &> /dev/null; then
            reade -Q "GREEN" -i "y" -p "Set 'cat' as alias for 'bat'? [Y/n]" "y n" cat
            if [ "$cat" != "y" ]; then
                sed -i 's|alias cat="bat"|#alias cat="bat"|g' $genr
            fi
        fi
        unset cat
        cp -fv $genr ~/.bash_aliases.d/
        yes_edit_no general_r "$genr" "Install general.sh at /root/?" "yes" "GREEN"; }
    yes_edit_no general "$genr" "Install general.sh at ~/? (aliases related to general actions - cd/mv/cp/rm + completion script replacement for 'read -e') " "yes" "YELLOW"
    
    systemd=aliases/systemctl.sh
    dosu=aliases/sudo.sh
    pacmn=aliases/package_managers.sh
    sshs=aliases/ssh.sh
    ps1=aliases/ps1.sh
    manjaro=aliases/manjaro.sh
    variti=aliases/variety.sh
    pthon=aliases/python.sh
    ytbe=aliases/youtube.sh
    if ! test -d aliases/; then
        wget https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/systemctl.sh -P $TMPDIR/
        systemd=$TMPDIR/systemctl.sh
        wget https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/sudo.sh -P $TMPDIR/
        dosu=$TMPDIR/sudo.sh
        wget https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/package_managers.sh -P $TMPDIR/
        pacmn=$TMPDIR/package_managers.sh
        wget https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/ssh.sh -P $TMPDIR/
        sshs=$TMPDIR/ssh.sh
        wget https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/ps1.sh -P $TMPDIR/
        ps1=$TMPDIR/ps1.sh
        wget https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/manjaro.sh -P $TMPDIR/
        manjaro=$TMPDIR/manjaro.sh
        wget https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/variety.sh -P $TMPDIR/
        variti=$TMPDIR/variety.sh
        wget https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/python.sh -P $TMPDIR/
        pthon=$TMPDIR/python.sh
        wget https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/youtube.sh -P $TMPDIR/
        ytbe=$TMPDIR/youtube.sh
    fi 

    systemd_r(){ 
        sudo cp -fv $systemd /root/.bash_aliases.d/;
    }
    systemd(){
        cp -fv $systemd ~/.bash_aliases.d/
        yes_edit_no systemd_r "$systemd" "Install systemctl.sh at /root/?" "yes" "GREEN"; }
    yes_edit_no systemd "$systemd" "Install systemctl.sh? ~/.bash_aliases.d/ (systemctl aliases/functions)?" "edit" "GREEN"
        

    dosu_r(){ 
        sudo cp -fv $dosu /root/.bash_aliases.d/ ;
    }    

    dosu(){ 
        cp -fv $dosu ~/.bash_aliases.d/;
        yes_edit_no dosu_r "$dosu" "Install sudo.sh at /root/?" "yes" "GREEN"; }
    yes_edit_no dosu "$dosu" "Install sudo.sh at ~/.bash_aliases.d/ (sudo aliases)? " "edit" "GREEN"


    packman_r(){ 
        sudo cp -fv $pacmn /root/.bash_aliases.d/
    }
    packman(){
        cp -fv $pacmn ~/.bash_aliases.d/
        yes_edit_no packman_r "$pacmn" "Install package_managers.sh at /root/?" "edit" "YELLOW" 
    }
    yes_edit_no packman "$pacmn" "Install package_managers.sh at ~/.bash_aliases.d/ (package manager aliases)? " "edit" "GREEN"
    
    ssh_r(){ 
        sudo cp -fv $sshs /root/.bash_aliases.d/; 
    }
    sshh(){
        cp -fv $sshs ~/.bash_aliases.d/
        yes_edit_no ssh_r "$sshs" "Install ssh.sh at /root/?" "edit" "YELLOW" 
    }
    yes_edit_no sshh "$sshs" "Install ssh.sh at ~/.bash_aliases.d/ (ssh aliases)? " "edit" "GREEN"


    ps1_r(){ 
        sudo cp -fv $ps1 /root/.bash_aliases.d/; 
    }
    ps11(){
        cp -fv $ps1 ~/.bash_aliases.d/
        yes_edit_no ps1_r "$ps1" "Install PS1_colours.sh at /root/?" "yes" "GREEN" 
    }
    yes_edit_no ps11 "$ps1" "Install PS1_colours.sh at ~/.bash_aliases.d/ (Coloured command prompt)? " "yes" "GREEN"
    
    if [ $distro == "Manjaro" ] ; then
        manj_r(){ 
            sudo cp -fv $manjaro /root/.bash_aliases.d/; 
        }
        manj(){
            cp -fv $manjaro ~/.bash_aliases.d/
            yes_edit_no manj_r "$manjaro" "Install manjaro.sh at /root/?" "yes" "GREEN" 
        }
        yes_edit_no manj "$manjaro" "Install manjaro.sh at ~/.bash_aliases.d/ (manjaro specific aliases)? " "yes" "GREEN"
    fi
    
    # Variety aliases 
    # 
    variti_r(){ 
        sudo cp -fv $variti /root/.bash_aliases.d/; 
    }
    variti(){
        cp -fv $variti ~/.bash_aliases.d/
        yes_edit_no variti_r "$variti" "Install variety.sh at /root/?" "no" "YELLOW" 
    }
    yes_edit_no variti "$variti" "Install variety.sh at ~/.bash_aliases.d/ (aliases for a variety of tools)? " "edit" "GREEN" 
    
    pthon(){
        cp -fv $pthon ~/.bash_aliases.d/
    }
    yes_edit_no variti "$pthon" "Install python.sh at ~/.bash_aliases.d/ (aliases for a python development)? " "edit" "GREEN" 


    # Youtube
    #

    ytbe(){
        if ! test -f checks/check_youtube.sh; then
            eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/checks/check_youtube.sh)" 
        else
            ./checks/check_youtube.sh
        fi
        cp -fv $ytbe ~/.bash_aliases.d/
    }
    yes_edit_no ytbe "$ytbe" "Install yt-dlp (youtube cli download) and youtube.sh at ~/.bash_aliases.d/ (yt-dlp aliases)?" "yes" "GREEN"
fi

source ~/.bashrc

echo "${cyan}${bold}You can check all aliases with 'alias'"
alias -p
echo "${green}${bold}Done!"
