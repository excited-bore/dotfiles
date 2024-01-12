. ./readline/rlwrap_scripts.sh
. ./checks/check_distro.sh
. ./checks/check_rlwrap.sh

if [ -z "$TMPDIR" ]; then
    TMPDIR=/tmp
fi

if [ ! -e ~/config ]; then
    reade -Q "BLUE" -i "y" -p "Create ~/.config to ~/config symlink? [Y(es)/n(o)]:" "y n" sym1
    if [ -z $sym1 ] || [ "y" == $sym1 ] && [ ! -e ~/config ]; then
        ln -s ~/.config ~/config
    fi
fi

if [ ! -e ~/lib_systemd ]; then
    reade -Q "BLUE" -i "y" -p "Create /lib/systemd/system/ to user directory symlink? [Y/n]:" "y n" sym2
    if [ -z $sym2 ] || [ "y" == $sym2 ] && [ ! -e ~/lib_systemd ]; then
        ln -s /lib/systemd/system/ ~/lib_systemd
    fi
fi

if [ ! -e ~/etc_systemd ]; then
    reade -Q "BLUE" -i "y" -p "Create /etc/systemd/system/ to user directory symlink? [Y/n]:" "y n" sym3
    if [ -z $sym3 ] || [ "y" == $sym3 ] && [ ! -e ~/etc_systemd ]; then
        ln -s /etc/systemd/system/ ~/etc_systemd
    fi
fi

if [ "$distro_base" == "Arch" ]; then
   ./install_AUR-helper.sh 
fi

if [ ! -x "$(command -v flatpak)" ]; then
    printf "%s\n" "${blue}No flatpak detected. (Independent package manager from Red Hat){normal}"
    reade -Q "GREEN" -i "y" -p "Install? [Y/n]:" "y n" insflpk 
    if [ "y" == "$insflpk" ]; then
       ./install_flatpak.sh 
    fi
fi
unset insflpk

if [ ! -x "$(command -v snap)" ]; then
    printf "%s\n" "${blue}No snap detected. (Independent package manager from Canonical){normal}"
    reade -Q "YELLOW" -i "n" -p "Install? [Y/n]:" "y n" inssnap 
    if [ "y" == "$insflpk" ]; then
       ./install_snapd.sh 
    fi
fi
unset inssnap

# Pathvariables

reade -Q "GREEN" -i "y" -p "Check existence (and create) ~/.pathvariables.sh and link it to .bashrc? [Y/n]:" "y n" pathvars
if [ "$pathvars" == "y" ] || [ -z "$pathvars" ]; then

    # First comment out every export
    sed -e '/export/ s/^#*/#/' -i pathvars/.pathvariables.sh
    
    # Then set TMPDIR but don't ask if user would want another directory because that breaks stuff
    sed 's|#export TMPDIR|export TMPDIR|' -i pathvars/.pathvariables.sh

    # Then iterate through all predefined pathvars
    
    # Package Managers
    reade -Q "GREEN" -i "y" -p "Check and create DIST,DIST_BASE,ARCH,PM and WRAPPER? (distro, distro base, architecture, package manager and pm wrapper) [Y/n]:" "y n" Dists
    if [ "$Dists" == "y" ]; then
       printf "NOT YET IMPLEMENTED\n"
    fi
    
    # TODO: non ugly values
    reade -Q "GREEN" -i "n" -p "Set LS_COLORS with some predefined values? (WARNING: ugly values) [Y/n]:" "y n" lsclrs
    if [ "$lsclrs" == "y" ] || [ -z "$lsclrs" ]; then
        sed 's/^#export LS_COLORS/export LS_COLORS/' -i pathvars/.pathvariables.sh
    fi
    
    reade -Q "GREEN" -i "y" -p "Set PAGER? (Page reader) [Y/n]:" "y n" pgr
    if [ "$pgr" == "y" ] || [ -z "$pgr" ]; then
        
        # Uncomment export PAGER=
        sed 's/^#export PAGER=/export PAGER=/' -i pathvars/.pathvariables.sh
        
        pagers="less more"
        prmpt="${green} \tless = Default pager - Oldest and most customizable\n\
        more = Preinstalled other pager - leaves text by default, less customizable (ironically)\n"
        if [ -x "$(command -v most)" ]; then
            pagers="$pagers most"
            prmpt="$prmpt \tmost = Installed pager\n"
        fi
        if [ -x "$(command -v moar)" ]; then
            pagers="$pagers moar"
            prmpt="$prmpt \tmoar = Installed pager\n"
        fi
        printf "$prmpt"
        reade -Q "GREEN" -i "less" -p "PAGER=" "$pagers" pgr2
        pgr2=$(whereis "$pgr2" | awk '{print $2}')
        sed -i 's|export PAGER=.*|export PAGER='$pgr2'|' pathvars/.pathvariables.sh
        if grep -q "less" "$pgr2"; then
            sed -i 's/#export LESS=/export LESS=/' pathvars/.pathvariables.sh
            #sed -i 's/#export LESSEDIT=/export LESSEDIT=/' pathvars/.pathvariables.sh
        fi
        if grep -q "moar" "$pgr2"; then
            sed -i 's/#export MOAR=/export MOAR=/' pathvars/.pathvariables.sh
        fi

    fi
    unset prmpt

    reade -Q "GREEN" -i "y" -p "Set EDITOR and VISUAL? [Y/n]:" "y n" edtvsl
    if [ "$edtvsl" == "y" ] || [ -z "$edtvsl" ]; then
        editors="nano vi"
        prmpt="${green} \tnano = Default editor - Basic, but userfriendly\n\
        vi = Other preinstalled editor - Least userfriendly and archaic editor\n" 
        if [ -x "$(command -v micro)" ]; then
            editors="$pagers micro"
            prmpt="$prmpt \tMicro = Relatively good out-of-the-box editor - Decent keybindings, yet no customizations\n"
        fi
        if [ -x "$(command -v ne)" ]; then
            editors="$pagers ne"
            prmpt="$prmpt \tNice editor = Relatively good out-of-the-box editor - Decent keybindings, yet no customizations\n"
        fi
        if [ -x "$(command -v vim)" ]; then
            editors="$editors vim"
            prmpt="$prmpt \tVim = The one and only true modal editor - Not userfriendly, but many features (maybe even too many) and greatly customizable\n"
            sed -i "s|#export MYVIMRC=|export MYVIMRC=|g" pathvars/.pathvariables.sh
            sed -i "s|#export MYGVIMRC=|export MYGVIMRC=|g" pathvars/.pathvariables.sh
        fi
        if [ -x "$(command -v nvim)" ]; then                                  
            editors="$editors nvim"
            prmpt="$prmpt \tNeovim = A better vim? - Faster and less buggy then regular vim, even a little userfriendlier\n"
            sed -i "s|#export MYVIMRC=|export MYVIMRC=|g" pathvars/.pathvariables.sh
            sed -i "s|#export MYGVIMRC=|export MYGVIMRC=|g" pathvars/.pathvariables.sh
        fi
        if [ -x "$(command -v emacs)" ]; then
            editors="$editors emacs"
            prmpt="$prmpt \tEmacs = One of the oldest and versatile editors - Modal and featurerich, but overwhelming as well\n"
        fi
        printf "$prmpt"
        reade -Q "GREEN" -i "nano" -p "EDITOR (Terminal)=" "$editors" edtor
        if [ "$edtor" == "emacs" ]; then
            edtor="emacs -nw"
        fi
        edtor=$(whereis "$edtor" | awk '{print $2}')
        sed -i 's|#export EDITOR=.*|export EDITOR='$edtor'|g' pathvars/.pathvariables.sh
        
        # Make .txt file and output file
        touch $TMPDIR/editor-outpt
        # Redirect output to file in subshell (mimeopen gives output but also starts read. This cancels read). In tmp because that gets cleaned up
        (echo "" | mimeopen -a editor-check.sh &> $TMPDIR/editor-outpt)
        compedit=$(cat $TMPDIR/editor-outpt | awk 'NR > 2' | awk '{if (prev_1_line) print prev_1_line; prev_1_line=prev_line} {prev_line=$NF}' | sed 's|[()]||g' | tr -s [:space:] \\n | uniq | tr '\n' ' ')
        frst="$(echo $compedit | awk '{print $1}')"
        reade -Q "GREEN" -i "$frst" -p "VISUAL (GUI editor)=" "$compedit" vsual
        vsual=$(whereis "$vsual" | awk '{print $2}')
        sed -i 's|#export VISUAL=.*|export VISUAL='$vsual'|' pathvars/.pathvariables.sh
    fi
    unset edtvsl compedit frst editors prmpt

    # Set DISPLAY
    reade -Q "YELLOW" -i "n" -p "Set DISPLAY to ':0.0'? [Y/n]:" "y n" dsply
    if [ "$dsply" == "y" ] || [ -z "$dsply" ]; then
        sed -i 's|#export DISPLAY=.*|export DISPLAY=":0.0"|' pathvars/.pathvariables.sh
    fi
    unset dsply

    if [ -x "$(command -v snap)" ]; then
        reade -Q "GREEN" -i "y" -p "Add snap dirs to path? [Y/n]:" "y n" snapvrs 
        if [ "$snapvrs" == "y" ]; then
            sed -i 's|#export PATH="/bin|export PATH="/bin|' pathvars/.pathvariables.sh 
        fi
    fi
    unset snapvrs
    

    # TODO do something for flatpak  (XDG_DATA_DIRS)
    # Check if xdg installed
    if [ -x "$(command -v xdg-open)" ]; then
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
            sed 's/^#export XDG_CACHE_HOME=\(.*\)/export XDG_CACHE_HOME=\1/' -i pathvars/.pathvariables.sh 
            sed 's/^#export XDG_CONFIG_HOME=\(.*\)/export XDG_CONFIG_HOME=\1/' -i pathvars/.pathvariables.sh
            sed 's/^#export XDG_CONFIG_DIRS=\(.*\)/export XDG_CONFIG_DIRS=\1/' -i pathvars/.pathvariables.sh
            sed 's/^#export XDG_DATA_HOME=\(.*\)/export XDG_DATA_HOME=\1/' -i pathvars/.pathvariables.sh    
            sed 's/^#export XDG_DATA_DIRS=\(.*\)/export XDG_DATA_DIRS=\1/' -i pathvars/.pathvariables.sh
            sed 's/^#export XDG_STATE_HOME=\(.*\)/export XDG_STATE_HOME=\1/' -i pathvars/.pathvariables.sh
            sed 's/^#export XDG_RUNTIME_DIR=\(.*\)/export XDG_RUNTIME_DIR=\1/' -i pathvars/.pathvariables.sh
        fi
    fi
    unset xdgInst
    
    if [ -x "$(command -v flatpak)" ]; then
        reade -Q "GREEN" -i "y" -p "Add flatpak dirs to path? (XDG_DATA_DIRS) [Y/n]:" "y n" flpkvrs 
        if [ "$flpkvrs" == "y" ]; then
            sed 's/^#export XDG_DATA_DIRS=\(.*\)/export XDG_DATA_DIRS=\1/' -i pathvars/.pathvariables.sh
            sed -i 's|#export FLATPAK=|export FLATPAK=|'  pathvars/.pathvariables.sh 
        fi
    fi
    unset flpkvrs


    # TODO: check around for other systemdvars 
    # Check if systemd installed
    if [ -x "$(command -v systemctl)" ]; then
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
            sed 's/^#export SYSTEMD_PAGER=\(.*\)/export SYSTEMD_PAGER=\1/' -i pathvars/.pathvariables.sh 
            sed 's/^#export SYSTEMD_PAGERSECURE=\(.*\)/export SYSTEMD_PAGERSECURE=\1/' -i pathvars/.pathvariables.sh
            sed 's/^#export SYSTEMD_COLORS=\(.*\)/export SYSTEMD_COLORS=\1/' -i pathvars/.pathvariables.sh
            sed 's/^#export SYSTEMD_LESS=\(.*\)/export SYSTEMD_LESS=\1/' -i pathvars/.pathvariables.sh    
            sed 's/^#export SYSTEMD_LOG_LEVEL=\(.*\)/export SYSTEMD_LOG_LEVEL=\1/' -i pathvars/.pathvariables.sh
            sed 's/^#export SYSTEMD_LOG_TIME=\(.*\)/export SYSTEMD_LOG_TIME=\1/' -i pathvars/.pathvariables.sh
            sed 's/^#export SYSTEMD_LOG_LOCATION=\(.*\)/export SYSTEMD_LOG_LOCATION=\1/' -i pathvars/.pathvariables.sh
            sed 's/^#export SYSTEMD_LOG_TID=\(.*\)/export SYSTEMD_LOG_TID=\1/' -i pathvars/.pathvariables.sh
            sed 's/^#export SYSTEMD_LOG_TARGET=\(.*\)/export SYSTEMD_LOG_TARGET=\1/' -i pathvars/.pathvariables.sh
        fi
    fi

    pathvariables_r(){ 
         if ! sudo grep -q "~/.pathvariables.sh" /root/.bashrc; then
            printf "if [[ -f ~/.pathvariables.sh ]]; then\n" | sudo tee -a /root/.bashrc
            printf "  . ~/.pathvariables.sh\n" | sudo tee -a /root/.bashrc
            printf "fi\n" | sudo tee -a /root/.bashrc
        fi
        sudo cp -fv pathvars/.pathvariables.sh /root/.pathvariables.sh;
    }                                            
    pathvariables(){
        if ! grep -q "~/.pathvariables.sh" ~/.bashrc; then
            echo "if [[ -f ~/.pathvariables.sh ]]; then" >> ~/.bashrc
            echo "  . ~/.pathvariables.sh" >> ~/.bashrc
            echo "fi" >> ~/.bashrc
        fi
        cp -fv pathvars/.pathvariables.sh ~/.pathvariables.sh
        yes_edit_no pathvariables_r "pathvars/.pathvariables.sh" "Install .pathvariables.sh at /root/?" "edit" "YELLOW"; 
    }
    yes_edit_no pathvariables "pathvars/.pathvariables.sh" "Install .pathvariables.sh at ~/? " "edit" "GREEN"
fi
    
reade -Q "GREEN" -i "y" -p "Check existence (and create) ~/.bash_aliases.d/ and link it to .bashrc? (other .sh files will be placed here) [Y/n]:" "y n" scripts
if [ -z $scripts ] || [ "y" == $scripts ]; then

    if [ ! -d ~/.bash_aliases.d/ ]; then
        mkdir ~/.bash_aliases.d/
    fi

    if ! grep -q "~/.bash_aliases.d" ~/.bashrc; then

        echo "if [[ -d ~/.bash_aliases.d/ ]]; then" >> ~/.bashrc
        echo "  for alias in ~/.bash_aliases.d/*.sh; do" >> ~/.bashrc
        echo "      . \"\$alias\" " >> ~/.bashrc
        echo "  done" >> ~/.bashrc
        echo "fi" >> ~/.bashrc
    fi
    
    cp -fv checks/check_distro.sh ~/.bash_aliases.d/check_distro.sh
    cp -fv readline/rlwrap_scripts.sh ~/.bash_aliases.d/rlwrap_scripts.sh


    reade -Q "YELLOW" -i "y" -p "Create /root/.bash_aliases.d/ and link it to /root/.bashrc? [Y/n]:" "y n" rscripts
    if [ -z $rscripts ] || [ "y" == $rscripts ]; then

        if ! sudo test -d /root/.bash_aliases.d/ ; then
            sudo mkdir /root/.bash_aliases.d/
        fi

        if ! sudo grep -q "~/.bash_aliases.d" /root/.bashrc; then
            printf "\nif [[ -d ~/.bash_aliases.d/ ]]; then\n  for alias in ~/.bash_aliases.d/*.sh; do\n      . \"\$alias\" \n  done\nfi" | sudo tee -a /root/.bashrc > /dev/null
        fi
        
        sudo cp -fv checks/check_distro.sh /root/.bash_aliases.d/check_distro.sh
        sudo cp -fv readline/rlwrap_scripts.sh /root/.bash_aliases.d/rlwrap_scripts.sh 
    fi
    
    # Xresources
    
    xresources_r(){
        sudo cp -fv xterm/.Xresources /root/.Xresources;
        #sudo cp -fv xterm/xterm.sh /root/.bash_aliases.d/xterm.sh;
        }
    xresources(){
        reade -Q "YELLOW" -i "n" -p "Set caps to escape? (xterm.sh - Might cause errors about display) [Y/n]: " "y n" xtrm
        if [ ! "$xtrm" == "y" ] && [ ! -z "$xtrm" ]; then
            sed -i "s|setxkbmap |#setxkbmap |g" aliases/xterm.sh
        fi
        cp -fv xterm/.Xresources ~/.Xresources;
        cp -fv xterm/xterm.sh ~/.bash_aliases.d/xterm.sh;
        yes_edit_no xresources_r "xterm/.Xresources xterm/xterm.sh" "Install .Xresources at /root/.bash_aliases.d/?" "edit" "RED"; }
    yes_edit_no xresources "xterm/.Xresources xterm/xterm.sh" "Install .Xresources and xterm.sh at ~/.bash_aliases.d/? (readline config)" "edit" "YELLOW"

    # Readline
    
    inputrc_r(){ 
        sudo cp -fv readline/.inputrc /root/.inputrc; 
        if [ -f /root/.pathvariables.sh ]; then
           sed -i 's|#export INPUTRC|export INPUTRC|g' /root/.pathvariables.sh
        fi
    }
    inputrc() {
        cp -fv readline/.inputrc ~/
        if [ -f ~/.pathvariables.sh ]; then
           sed -i 's|#export INPUTRC|export INPUTRC|g' ~/.pathvariables.sh
        fi
        yes_edit_no inputrc_r "readline/.inputrc" "Install .inputrc at /root/?" "edit" "GREEN"; }
    yes_edit_no inputrc "readline/.inputrc" "Install .inputrc at ~/? (readline config)" "edit" "GREEN"
    
    # Shell-keybindings
    
    #if grep -q 'bind -x '\''"\\C-s": ctrl-s'\''' aliases/shell_keybindings.sh && ! grep -q '#bind -x '\''"\\C-s": ctrl-s'\''' aliases/shell_keybindings.sh; then
    #    sed -i 's|bind -x '\''"\\C-s": ctrl-s'\''|#bind -x '\''"\\C-s": ctrl-s'\''|g' aliases/shell_keybindings.sh
    #    sed -i 's|bind -x '\''"\\eOR": ctrl-s'\''|#bind -x '\''"\\eOR": ctrl-s'\''|g' aliases/shell_keybindings.sh
    #fi

    if grep -q 'bind -x '\''"\\201": ranger'\''' readline/shell_keybindings.sh; then
        sed -i 's|bind -x '\''"\\201": ranger'\''|#bind -x '\''"\\201": ranger'\''|g' readline/shell_keybindings.sh
        sed -i 's|bind '\''"\\eOQ":|#bind '\''"\\eOQ":|g' readline/shell_keybindings.sh
    fi

    shell-keybindings_r(){ sudo cp -fv aliases/shell_keybindings.sh /root/.bash_aliases.d/; }
    shell-keybindings() {
        cp -fv aliases/shell_keybindings.sh ~/.bash_aliases.d/
        yes_edit_no shell-keybindings_r "aliases/shell_keybindings.sh" "Install .bash_aliases.d/shell_keybindings.sh at /root/?" "edit" "RED"; }
    yes_edit_no shell-keybindings "aliases/shell_keybindings.sh" "Install .bash_aliases.d/shell-keybindings.sh at ~/? (bind commands)" "edit" "YELLOW"


    reade -Q "GREEN" -i "y" -p "Install bash completions for aliases in ~/.bash_completion.d? [Y/n]:" "y n" compl
    if [ -z $compl ] || [ "y" == $compl ]; then
        ./install_bash_alias_completions.sh
    fi
    
    if [ ! -f ~/.bash_completion.d/_python-argcomplete ]; then
        reade -Q "GREEN" -i "y" -p "Install python completions in ~/.bash_completion.d? [Y/n]:" "y n" pycomp
        if [ -z $pycomp ] || [ "y" == $pycomp ]; then
            . ./install_pythonCompletions_bash.sh
        fi
    fi
    
    # Moar (Custom pager instead of less)
    if [ ! -x "$(command -v moar)" ]; then
        reade -Q "GREEN" -i "y" -p "Install moar? (Custom pager instead of less with linenumbers) [Y/n]: " "y n" moar
        if [ -z $moar ] || [ "Y" == $moar ] || [ $moar == "y" ]; then
            . ./install_moar.sh 
            reade -Q "GREEN" -i "y" -p "Set moar default pager for $USER? [Y/n]: " "y n" moar_usr
            if [ -z "$moar_usr" ] || [ "y" == "$moar_usr" ] || [ "Y" == "$moar_usr" ]; then
                sed -i "s/#export MOAR=/export MOAR=/g" pathvars/.pathvariables.sh 
                sed -i "s|#export PAGER=.*|export PAGER=/usr/local/bin/moar|g" pathvars/.pathvariables.sh
                #sed -i "s/#export SYSTEMD_PAGER=/export SYSTEMD_PAGER=/g" pathvars/.pathvariables.sh
                sed -i "s/#export SYSTEMD_PAGERSECURE=/export SYSTEMD_PAGERSECURE=/g" pathvars/.pathvariables.sh

            fi
            
            reade -Q "YELLOW" -i "y" -p "Set moar default pager for root? [Y/n]: " "y n" moar_root
            if [ -z "$moar_root" ] || [ "y" == "$moar_root" ] || [ "Y" == "$moar_root" ]; then
                sudo sed -i "s/#export MOAR=/export MOAR=/g" /root/.pathvars/.pathvariables.sh 
                sudo sed -i "s/#export PAGER=/export PAGER=/g" /root/pathvars/.pathvariables.sh
                #sudo sed -i "s/#export SYSTEMD_PAGER=/export SYSTEMD_PAGER=/g" /root/pathvars/.pathvariables.sh
                sudo sed -i "s/#export SYSTEMD_PAGERSECURE=/export SYSTEMD_PAGERSECURE=/g" /root/pathvars/.pathvariables.sh

            fi
        fi
    fi

    
    # Nvim (Editor)
    reade -Q "GREEN" -i "y" -p "Install Neovim? (Terminal editor) [Y/n]: " "y n" nvm
    if [ "y" == "$nvm" ]; then
        . ./install_nvim.sh
    fi
    unset nvm

    # Kitty (Terminal emulator)
    reade -Q "GREEN" -i "y" -p "Install Kitty? (Terminal emulator) [Y/n]: " "y n" kittn
    if [ "y" == "$kittn" ]; then
        . ./install_kitty.sh
    fi
    unset kittn

    # Ranger (File explorer)
    reade -Q "GREEN" -i "y" -p "Install Ranger? (Terminal file explorer) [Y/n]: " "y n" rngr
    if [ "y" == "$rngr" ]; then
        . ./install_ranger.sh
    fi
    unset rngr
    
    # Ranger (File explorer)
    reade -Q "GREEN" -i "y" -p "Install tmux? (Terminal multiplexer) [Y/n]: " "y n" tmx
    if [ "y" == "$tmx" ]; then
        . ./install_tmux.sh
    fi
    unset tmx

    # Fzf (Fuzzy Finder)
    reade -Q "GREEN" -i "y" -p "Install fzf? (Fuzzy file/folder finder - keybinding yes for upgraded Ctrl-R/reverse-search, fzf filenames on Ctrl+T and fzf-version of 'cd' on Alt-C + Custom script: Ctrl-f becomes system-wide file opener) [Y/n]: " "y n" findr
    if [ "y" == "$findr" ]; then
        . ./install_fzf.sh
    fi
    unset findr
    
    
    bash_yes_r(){ sudo cp -fv aliases/bash.sh /root/.bash_aliases.d/; }
    bash_yes() {
        cp -fv aliases/bash.sh ~/.bash_aliases.d/;
        yes_edit_no bash_yes_r "aliases/bash.sh" "Install bash.sh at /root/?" "yes" "YELLOW"; }
    yes_edit_no bash_yes "aliases/bash.sh" "Install bash.sh at ~/? (bash specific aliases)?" "yes" "GREEN";


    general_r(){ sudo cp -fv aliases/general.sh /root/.bash_aliases.d/;}
    general(){
        cp -fv aliases/general.sh ~/.bash_aliases.d/
        yes_edit_no general_r "aliases/general.sh" "Install general.sh at /root/?" "yes" "GREEN"; }
    yes_edit_no general "aliases/general.sh" "Install general.sh at ~/? (general terminal related aliases) " "yes" "YELLOW"


    systemd_r(){ sudo cp -fv aliases/systemctl.sh /root/.bash_aliases.d/;}
    systemd(){
        cp -fv aliases/systemctl.sh ~/.bash_aliases.d/
        yes_edit_no systemd_r "aliases/systemctl.sh" "Install systemctl.sh at /root/?" "yes" "GREEN"; }
    yes_edit_no systemd "aliases/systemctl.sh" "Install systemctl.sh? ~/.bash_aliases.d/ (systemctl aliases/functions)?" "edit" "GREEN"
        

    dosu_r(){ sudo cp -fv aliases/sudo.sh /root/.bash_aliases.d/ ;}    

    dosu(){ 
        cp -fv aliases/sudo.sh ~/.bash_aliases.d/;
        yes_edit_no dosu_r "aliases/sudo.sh" "Install sudo.sh at /root/?" "yes" "GREEN"; }
    yes_edit_no dosu "aliases/sudo.sh" "Install sudo.sh at ~/.bash_aliases.d/ (sudo aliases)? " "edit" "GREEN"


    packman_r(){ sudo cp -fv aliases/package_managers.sh /root/.bash_aliases.d/; }
    packman(){
        cp -fv aliases/package_managers.sh ~/.bash_aliases.d/
        yes_edit_no packman_r "aliases/package_managers.sh" "Install package_managers.sh at /root/?" "edit" "YELLOW" 
    }
    yes_edit_no packman "aliases/package_managers.sh" "Install package_managers.sh at ~/.bash_aliases.d/ (package manager aliases)? " "edit" "GREEN"
    
    ssh_r(){ sudo cp -fv aliases/ssh.sh /root/.bash_aliases.d/; }
    sshh(){
        cp -fv aliases/ssh.sh ~/.bash_aliases.d/
        yes_edit_no ssh_r "aliases/ssh.sh" "Install ssh.sh at /root/?" "edit" "YELLOW" 
    }
    yes_edit_no sshh "aliases/ssh.sh" "Install ssh.sh at ~/.bash_aliases.d/ (ssh aliases)? " "edit" "GREEN"


    #git_r(){ sudo cp -fv aliases/git.sh /root/.bash_aliases.d/; }
    gitt(){
        if [ ! -x "$(command -v git)" ]; then
            if [ $distro == "Arch" ] || [ $distro_base == "Arch" ]; then
                yes | sudo pacman -Su git
            elif [ $distro == "Debian" ] || [ $distro_base == "Debian" ]; then
                yes | sudo apt update
                yes | sudo apt install git
            fi
        fi

        cp -fv aliases/git.sh ~/.bash_aliases.d/
        
        if [[ ! $(git config --list | grep 'name') ]]; then
            reade -Q "GREEN" -i "y" -p "Configure git name? [Y/n]: " "y n" gitname
            if [ "y" == $gitname ]; then        
                reade -Q "CYAN" -p "Name: " name
                if [ ! -z $name ]; then
                    git config --global user.name "$name"
                fi
            fi
        fi
        
        if [[ ! $(git config --list | grep 'email') ]]; then
            reade -Q "GREEN" -i "y" -p "Configure git email? [Y/n]: " "y n" gitmail ;
            if [ "y" == $gitmail ]; then
                reade -Q "CYAN" -p "Email: " mail ;
                if [ ! -z $mail ]; then
                    git config --global user.email "$mail" ;
                fi
            fi
        fi

         if [[ ! $(git config --list | grep 'merge.tool') ]]; then
            reade -Q "GREEN" -i "y" -p "Configure git mergetool? [Y/n]: " "y n" gitmerge ;
            if [ "y" == $gitmerge ]; then
                git mergetool --tool-help &> $TMPDIR/gitresults
                amnt=$(cat $TMPDIR/gitresults | tail -n+2 | sed '0,/^$/d' | wc -l)
                #amnt=$((++amnt))
                rslt=$(cat $TMPDIR/gitresults | tail -n+2 | head -n-"$amnt" | awk '{print $1}')
                git mergetool --tool-help
                reade -Q "CYAN" -p "Mergetool: " "$(git mergetool --tool-help)" "$rslt" merge ;
                if [ ! -z $merge ]; then
                    git config --global diff.tool "$merge" ;
                    git config --global diff.guitool "$merge" ;
                    git config --global merge.tool "$merge" ;
                    git config --global merge.guitool "$merge" ;
                fi
            fi
        fi
        
        reade -Q "GREEN" -i "y" -p "Check git config? [Y/n]: " "y n" gitcnf ;
        if [ "y" == $gitcnf ]; then
            git config --global -e 
        fi

        reade -Q "GREEN" -i "y" -p "Check and create global gitignore? (~/.config/git/ignore) [Y/n]: " "y n" gitign 
        if [ "y" == "$gitign" ]; then
           ./install_gitignore.sh
        
        fi

        if [ ! -x "$(command -v copy-to)" ]; then
            reade -Q "GREEN" -i "y" -p "Install copy-to? [Y/n]: " "y n" cpcnf;
            if [ "y" == $cpcnf ] || [ -z $cpcnf ]; then
                ./install_copy-conf.sh
            fi
        fi
        #yes_edit_no git_r "aliases/git.sh" "Install git.sh at /root/?" "no" "RED" 
    }
    yes_edit_no gitt "aliases/git.sh" "Install git.sh at ~/.bash_aliases.d/ (git aliases)? " "yes" "GREEN"
    
    ps1_r(){ sudo cp -fv aliases/PS1_colours.sh /root/.bash_aliases.d/; }
    ps11(){
        cp -fv aliases/PS1_colours.sh ~/.bash_aliases.d/
        yes_edit_no ps1_r "aliases/PS1_colours.sh" "Install PS1_colours.sh at /root/?" "yes" "GREEN" 
    }
    yes_edit_no ps11 "aliases/PS1_colours.sh" "Install PS1_colours.sh at ~/.bash_aliases.d/ (Coloured command prompt)? " "yes" "GREEN"
    
    if [ $distro == "Manjaro" ] ; then
        manj_r(){ sudo cp -fv aliases/manjaro.sh /root/.bash_aliases.d/; }
        manj(){
            cp -fv aliases/manjaro.sh ~/.bash_aliases.d/
            yes_edit_no manj_r "aliases/manjaro.sh" "Install manjaro.sh at /root/?" "yes" "GREEN" 
        }
        yes_edit_no manj "aliases/manjaro.sh" "Install manjaro.sh at ~/.bash_aliases.d/ (manjaro specific aliases)? " "yes" "GREEN"
    fi
    
    # Variety aliases 
    # 
    variti_r(){ sudo cp -fv aliases/variety.sh /root/.bash_aliases.d/; }
    variti(){
        cp -fv aliases/variety.sh ~/.bash_aliases.d/
        yes_edit_no variti_r "aliases/variety.sh" "Install variety.sh at /root/?" "no" "YELLOW" 
    }
    yes_edit_no variti "aliases/variety.sh" "Install variety.sh at ~/.bash_aliases.d/ (aliases for a variety of tools)? " "edit" "GREEN" 
    
    # Youtube
    #
    ytbe_r(){ sudo cp -fv aliases/youtube.sh /root/.bash_aliases.d/;}
    ytbe(){
        . ./checks/check_youtube.sh
        cp -fv aliases/youtube.sh ~/.bash_aliases.d/
        yes_edit_no ytbe_r "aliases/youtube.sh" "Install youtube.sh at /root/?" "no" "YELLOW"; 
    }
    yes_edit_no ytbe "aliases/youtube.sh" "Install yt-dlp (youtube cli download) and youtube.sh at ~/.bash_aliases.d/ (yt-dlp aliases)?" "yes" "GREEN"
fi

. ~/.bashrc         
