 # !/bin/bash

if ! test -f checks/check_system.sh.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi

if ! test -f checks/check_pathvar.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_pathvar.sh)" 
else
    . ./checks/check_pathvar.sh
fi

if ! type update_system &> /dev/null; then
    if ! test -f update_system.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/update_system.sh)" 
    else
        . ./update_system.sh
    fi
fi

if test -z $SYSTEM_UPDATED; then
    reade -Q "CYAN" -i "n" -p "Update system? [Y/n]: " "y n" updatesysm
    if test $updatesysm == "y"; then
        update_system                     
    fi
fi

if ! test -f aliases/.bash_aliases.d/rlwrap_scripts.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/rlwrap_scripts.sh)" 
else
    . ./aliases/.bash_aliases.d/rlwrap_scripts.sh
fi

# Fzf (Fuzzy Finder)

 git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
 ~/.fzf/install
 # Bash completion issue with fzf fix
 # https://github.com/cykerway/complete-alias/issues/46
 
if grep -q "[ -f ~/.bash_aliases ]" ~/.bashrc; then
    sed -i 's|\[ -f \~/.fzf.bash \] \&\& source \~/.fzf.bash||g' ~/.bashrc
    sed -i 's|\(\[ -f ~/.bash_aliases \] && source ~/.bash_aliases\)|\[ -f \~/.fzf.bash \] \&\& source \~/.fzf.bash\n\n\1\n|g' ~/.bashrc
elif grep -q "[ -f ~/.keybinds ]" ~/.bashrc; then
    sed -i 's|\[ -f \~/.fzf.bash \] \&\& source \~/.fzf.bash||g' ~/.bashrc
    sed -i 's|\[ -f ~/.keybinds ] && source ~/.keybinds\)|\1\[ -f \~/.fzf.bash \] \&\& source \~/.fzf.bash\n\n|g' ~/.bashrc
elif grep -q "[ -f ~/.bash_completion ]" ~/.bashrc; then
    sed -i 's|\[ -f \~/.fzf.bash \] \&\& source \~/.fzf.bash||g' ~/.bashrc
    sed -i 's|\[ -f ~/.bash_completion ] && source ~/.bash_completion\)|\1\[ -f \~/.fzf.bash \] \&\& source \~/.fzf.bash\n\n|g' ~/.bashrc
fi
if grep -q "complete -F _complete_alias" ~/.bashrc; then
    sed -i '/complete -F _complete_alias "${!BASH_ALIASES\[@\]}"/d' ~/.bashrc
    sed -i 's|\(\[ -f \~/.fzf.bash \] \&\& source \~/.fzf.bash\)|\1\n\ncomplete -F _complete_alias "${!BASH_ALIASES\[@\]}"\n|g' ~/.bashrc
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
 #. ~/.bashrc

if [ ! -f ~/.fzf_history ]; then
    touch ~/.fzf_history 
fi

fnd="find"

# TODO: Make better check: https://github.com/sharkdp/fd
if type fd-find &> /dev/null || type fd &> /dev/null; then
    reade -Q "GREEN" -i "y" -p "Install fd and use for fzf? (Faster find) [Y/n]: " "y n" fdr
     if [ -z $fdr ] || [ "Y" == $fdr ] || [ $fdr == "y" ]; then
        if ! test -f install_fd.sh; then
            eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_fd.sh)" 
        else
            ./install_fd.sh
        fi 
     fi
     fnd="fd"
else
    fnd="fd"
fi

echo "${green}Fzf uses 'find'. Set default find options for fzf to:${normal}"
reade -Q "GREEN" -i "y" -p "    Search globally instead of in current folder? [Y/n]: " "y n" fndgbl
reade -Q "GREEN" -i "y" -p "    Search only files? [Y/n]: " "y n" fndfle
reade -Q "GREEN" -i "y" -p "    Include hidden files? [Y/n]: " "y n" fndhiddn
if [ $fnd == "find" ]; then
   test "$fndgbl" == "y" && fnd="find /"
   test "$fndfle" == "y" && fnd="$fnd -type f"
   test "$fndhiddn" == "y" && fnd="$fnd -iname \".*\""
else
   test "$fndgbl" == "y" && fnd="fd --search-path /"
   test "$fndfle" == "y" && fnd="$fnd --type f"
   test "$fndhiddn" == "y" && fnd="$fnd --hidden"
fi
unset fndgbl fndfle fndhiddn

# TODO: Make better check: https://github.com/sharkdp/fd
if type fd-find &> /dev/null || type fd &> /dev/null; then
    echo "${green}Fd can read from global gitignore file${normal}"
    reade -Q "GREEN" -i "y" -p "Generate global gitignore? [Y/n]: " "y n" fndgbl
    if [ $fndgbl == 'y' ]; then
        if ! test -f install_gitignore.sh; then
            b=$(mktemp)
            curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_gitignore.sh | tee "$b" &> /dev/null
            chmod u+x "$b"
            eval "$b" "global"
            unset b
        else
            ./install_gitignore.sh "global"
        fi 
    fi
fi

if [ $PATHVAR == ~/.pathvariables.env ] ; then
    sed -i 's|#export FZF_DEFAULT_COMMAND|export FZF_DEFAULT_COMMAND|g' $PATHVAR
    sed -i "s|export FZF_DEFAULT_COMMAND=.*|export FZF_DEFAULT_COMMAND=\"$fnd\"|g" $PATHVAR
    sed -i 's|#export FZF_CTRL_T_COMMAND|export FZF_CTRL_T_COMMAND|g' $PATHVAR
    sed -i 's|#export FZF_CTRL_R_OPTS|export FZF_CTRL_R_OPTS|g' $PATHVAR
    sed -i 's|#export FZF_BIND_TYPES|export FZF_BIND_TYPES|g' $PATHVAR
elif ! grep -q "export FZF_DEFAULT_COMMAND" $PATHVAR; then
    printf "\n# FZF\nexport FZF_DEFAULT_COMMAND=\"$fnd\"\nexport FZF_CTRL_T_COMMAND='$FZF_DEFAULT_COMMAND'" >> $PATHVAR
fi

echo "Next $(tput setaf 1)sudo$(tput sgr0) will FZF pathvariables in /root/.pathvariables.env' "


if [ $PATHVAR_R == /root/.pathvariables.env ] ; then
    sudo sed -i 's|#export FZF_DEFAULT_COMMAND|export FZF_DEFAULT_COMMAND |g' $PATHVAR_R
    sudo sed -i "s|export FZF_DEFAULT_COMMAND=.*|export FZF_DEFAULT_COMMAND=\"$fnd\"|g" $PATHVAR_R
    sudo sed -i 's|#export FZF_CTRL_T_COMMAND|export FZF_CTRL_T_COMMAND|g' $PATHVAR_R
    sudo sed -i 's|#export FZF_CTRL_R_OPTS|export FZF_CTRL_R_OPTS|g' $PATHVAR_R
    sudo sed -i 's|#export FZF_BIND_TYPES|export FZF_BIND_TYPES|g' $PATHVAR_R
elif ! sudo grep -q "export FZF_DEFAULT_COMMAND" $PATHVAR_R; then
    printf "\n# FZF\nexport FZF_DEFAULT_COMMAND=\"$fnd\"\nexport FZF_CTRL_T_COMMAND='$FZF_DEFAULT_COMMAND'" | sudo tee -a $PATHVAR_R
fi
 
 # TODO: Check export for ripgrep
 # TODO: Do more with ripgrep
 reade -Q "GREEN" -i "y" -p "Install ripgrep? (Recursive grep, opens possibility for line by line fzf ) [Y/n]: " "y n" rpgrp
 if [ -z $rpgrp ] || [ "Y" == $rpgrp ] || [ $rpgrp == "y" ]; then
    if ! test -f install_ripgrep.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_ripgrep.sh)" 
    else
        ./install_ripgrep.sh
    fi
    if [ $PATHVAR == ~/.pathvariables.env ] ; then
        sed -i 's|#export RG_PREFIX|export RG_PREFIX|g' $PATHVAR
    elif ! grep -q "export RG_PREFIX" $PATHVAR; then
        printf "\n# RIPGREP\nexport RG_PREFIX='rg --column --line-number --no-heading --color=always --smart-case \"" >> $PATHVAR &> /dev/null
    fi
    if [ $PATHVAR_R == /root/.pathvariables.env ] ; then
        sudo sed -i 's|#export RG_PREFIX|export RG_PREFIX|g' $PATHVAR_R
    elif ! sudo grep -q "export RG_PREFIX" $PATHVAR_R; then
         printf "\n# RIPGREP\nexport RG_PREFIX='rg --column --line-number --no-heading --color=always --smart-case \"" | sudo tee -a $PATHVAR_R
    fi
    
    reade -Q "GREEN" -i "y" -p "Add shortcut for ripgrep files in dir? (Ctrl-g) [Y/n]:" "y n" rpgrpdir
    if [ -z $rpgrp ] || [ "Y" == $rpgrp ] || [ $rpgrp == "y" ]; then
        if ! test -f fzf/ripgrep-directory.sh; then
            wget -O ~/.bash_aliases.d/ripgrep-directory.sh https://raw.githubusercontent.com/excited-bore/dotfiles/main/fzf/ripgrep-directory.sh
        else
            cp -fv fzf/ripgrep-directory.sh ~/.bash_aliases.d/
        fi
        #if ! grep -q "ripgrep-dir" ~/.fzf/shell/key-bindings.bash; then 
        #    # TODO Fix this
        #    echo "source ~/.bash_aliases.d/ripgrep-directory.sh" >> ~/.fzf/shell/key-bindings.bash
        #    echo "#  Ctrl-g gives a ripgrep function overview" >> ~/.fzf/shell/key-bindings.bash
        #    echo 'bind -x '\''"\C-g": "ripgrep-dir"'\''' >> ~/.fzf/shell/key-bindings.bash
        #fi
    fi
 fi
 unset rpgrp rpgrpdir

if type kitty &> /dev/null; then
    reade -Q "GREEN" -i "y" -p "Add shortcut for fzf-autocompletion? (CTRL-Tab) [Y/n]:" "y n" comp_key
    if [ "$comp_key" == "y" ]; then
        if ! test -f .keybinds.d/keybinds.bash && ! grep -q "(Kitty)" ~/.fzf/shell/key-bindings.bash; then
            printf "\n# (Kitty) Ctrl-tab for fzf autocompletion" >> ~/.fzf/shell/key-bindings.bash
            printf "\nbind '\"\\\e[9;5u\": \" **\\\t\"'" >> ~/.fzf/shell/key-bindings.bash
       fi
     fi
fi
 unset comp_key

if test -f ~/.fzf.bash ; then
#    if test -f ~/keybinds.d/.keybinds.bash && grep -q -w "bind '\"\\\C-z\": vi-undo'" ~/.keybinds.d/keybinds.bash; then
#        sed -i 's|\(\\C-y\\ey\\C-x\\C-x\)\\C-f|\1|g' ~/.fzf/shell/key-bindings.bash
#        sed -i 's|\\C-z|\\ep|g' ~/.fzf/shell/key-bindings.bash
#        #sed -i  's|bind -m emacs-standard '\''"\C-z"|#bind -m emacs-standard '\''"\C-z"|g' ~/.fzf/shell/key-bindings.bash
#        #sed -i  's|bind -m vi-command '\''"\C-z"|#bind -m vi-command '\''"\C-z"|g' ~/.fzf/shell/key-bindings.bash
#        #sed -i  's|bind -m vi-insert '\''"\C-z"|#bind -m vi-insert '\''"\C-z"|g' ~/.fzf/shell/key-bindings.bash
#    fi
    
    reade -Q "GREEN" -i "y" -p "Use rifle (file opener from 'ranger') to open found files and dirs with Ctrl-T filesearch shortcut? [Y/n]:" "y n" fzf_t
    if [ "$fzf_t" == "y" ] || [ -z "$fzf_t" ] ; then
        if ! type rifle &> /dev/null; then
            sudo wget -P /usr/bin/ https://raw.githubusercontent.com/ranger/ranger/master/ranger/ext/rifle.py 
            sudo mv -v /usr/bin/rifle.py /usr/bin/rifle
            sudo chmod +x /usr/bin/rifle
        fi
        if ! test -f ranger/rifle.conf; then
            wget -O ~/.config/ranger/rifle.conf https://raw.githubusercontent.com/excited-bore/dotfiles/main/ranger/rifle.conf  
            wget -O ~/.bash_aliases.d/keybinds_rifle.sh https://raw.githubusercontent.com/excited-bore/dotfiles/main/fzf/keybinds_rifle.sh
        else
            mkdir -p ~/.config/ranger
            cp -fv ranger/rifle.conf ~/.config/ranger/
            cp -fv fzf/keybinds_rifle.sh ~/.bash_aliases.d/
        fi
        if ! grep -q "keybinds_rifle.sh" ~/.fzf/shell/key-bindings.bash; then
            sed -i "s|\(# Required to refresh the prompt after fzf\)|. ~\/.bash_aliases.d\/keybinds_rifle.sh\n\1|" ~/.fzf/shell/key-bindings.bash;
            sed -i "s|: fzf-file-widget|: fzf_rifle|g" ~/.fzf/shell/key-bindings.bash;
        fi
    fi
    unset fzf_t

    reade -Q "GREEN" -i "y" -p "Install bat? (File previews/thumbnails for riflesearch) [Y/n]: " "y n" bat
    if [ "$bat" == "y" ]; then
        if ! test -f install_bat.sh; then
            eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_bat.sh)" 
        else
            ./install_bat.sh
        fi
    fi
    unset bat 

    #TODO: keybinds-rifle sh still has ffmpegthumbnailer part (could use sed check)
    reade -Q "GREEN" -i "y" -p "Install ffmpegthumbnailer? (Video thumbnails for riflesearch) [Y/n]: " "y n" ffmpg
    if [ "$ffmpg" == "y" ]; then
        if ! test -f install_ffmpegthumbnailer.sh; then
            eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_ffmpegthumbnailer.sh)" 
        else
            ./install_ffmpegthumbnailer.sh
        fi 
    fi
    unset ffmpg

    reade -Q "GREEN" -i "y" -p "Change shortcut for riflesearch from Ctrl-T to Ctrl-F? (Fzf and paste in console) [Y/n]:" "y n" fzf_t
    if [ "$fzf_t" == "y" ] || [ -z "$fzf_t" ] ; then 
        sed -i 's|# CTRL-T|# CTRL-F|g' ~/.fzf/shell/key-bindings.bash
        sed -i 's|bind -m emacs-standard '\''"\\C-t": |bind -m emacs-standard '\''"\\C-f": |g' ~/.fzf/shell/key-bindings.bash
        sed -i 's|bind -m vi-command '\''"\\C-t": |bind -m vi-command '\''"\\C-f": |g' ~/.fzf/shell/key-bindings.bash
        sed -i 's|bind -m vi-insert '\''"\\C-t": |bind -m vi-insert '\''"\\C-f": |g' ~/.fzf/shell/key-bindings.bash
        sed -i 's|bind -m emacs-standard -x '\''"\\C-t": |bind -m emacs-standard -x '\''"\\C-f": |g' ~/.fzf/shell/key-bindings.bash
        sed -i 's|bind -m vi-command -x '\''"\\C-t": |bind -m vi-command -x '\''"\\C-f": |g' ~/.fzf/shell/key-bindings.bash
        sed -i 's|bind -m vi-insert -x '\''"\\C-t": |bind -m vi-insert -x '\''"\\C-f": |g' ~/.fzf/shell/key-bindings.bash
    fi

    reade -Q "GREEN" -i "y" -p "Add shortcut F3 for fzf rifle? [Y/n]:" "y n" fzf_t
    if [ "$fzf_t" == "y" ] || [ -z "$fzf_t" ] ; then
        if ! grep -q 'bind -x '\''"\\eOR": "fzf_rifle"'\''' ~/.fzf/shell/key-bindings.bash ;  then              
            
            sed -i 's|\(# CTRL-S\)|# F3 - Rifle search\n  bind -x '\''"\\eOR\": "fzf_rifle"'\''\n\n  \1|g' ~/.fzf/shell/key-bindings.bash
        fi
    fi

    if ! type xclip &> /dev/null; then 
        reade -Q "GREEN" -i "y" -p "Install xclip? (Clipboard tool for Ctrl-R/Reverse history shortcut) [Y/n]: " "y n" xclip
        if [ "$xclip" == "y" ]; then
            if ! test -f install_xclip.sh; then
                eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_xclip.sh)" 
            else
                ./install_xclip.sh
            fi
        fi
        if [ $PATHVAR == ~/.pathvariables.env ] ; then
            sed -i 's|#export FZF_CTRL_R_OPTS=|export FZF_CTRL_R_OPTS=|g' $PATHVAR
        elif ! grep -q "export FZF_CTRL_R_OPTS=" $PATHVAR; then
            printf "\nexport FZF_CTRL_R_OPTS=\" --preview 'echo {}' --preview-window up:3:hidden:wrap --bind 'ctrl-t:toggle-preview' --bind 'alt-c:execute-silent(echo -n {2..} | xclip -i -sel c)+abort' --color header:italic --header 'Press ALT-C to copy command into clipboard'\"" >> $PATHVAR &> /dev/null
        fi
        if [ $PATHVAR_R == /root/.pathvariables.env ] ; then
            sudo sed -i 's|#export FZF_CTRL_R_OPTS==|export FZF_CTRL_R_OPTS=|g' $PATHVAR_R
        elif ! sudo grep -q "export FZF_CTRL_R_OPTS" $PATHVAR_R; then
            printf "\nexport FZF_CTRL_R_OPTS=\" --preview 'echo {}' --preview-window up:3:hidden:wrap --bind 'ctrl-t:toggle-preview' --bind 'alt-c:execute-silent(echo -n {2..} | xclip -i -sel c)+abort' --color header:italic --header 'Press ALT-C to copy command into clipboard'\"" | sudo tee -a $PATHVAR_R
        fi 
    fi
    unset xclip

    
    reade -Q "GREEN" -i "y" -p "Install tree? (Builtin cd shortcut gets a nice directory tree preview ) [Y/n]: " "y n" tree
    if [ "$tree" == "y" ]; then
        if ! test -f install_tree.sh; then
            eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_tree.sh)" 
        else
            ./install_tree.sh
        fi
        if [ $PATHVAR == ~/.pathvariables.env ] ; then
            sed -i 's|#export FZF_ALT_C_OPTS=|export FZF_ALT_C_OPTS=|g' $PATHVAR
        elif ! grep -q "export FZF_ALT_C_OPTS" $PATHVAR; then
            printf "\nexport FZF_ALT_C_OPTS=\"--preview 'tree -C {}\"" >> $PATHVAR
        fi
        if [ $PATHVAR_R == /root/.pathvariables.env ] ; then
            sudo sed -i 's|#export FZF_ALT_C_OPTS=|export FZF_ALT_C_OPTS=|g' $PATHVAR_R
        elif ! sudo grep -q "export FZF_ALT_C_OPTS" $PATHVAR_R; then
            printf "\nexport FZF_ALT_C_OPTS=\"--preview 'tree -C {}\"" | sudo tee -a $PATHVAR_R
        fi 
    fi
    unset tree

   # reade -Q "GREEN" -i "y" -p "Change Alt-C shortcut to Ctrl-S for fzf cd? [Y/n]:" "y n" fzf_t
   # if [ "$fzf_t" == "y" ] || [ -z "$fzf_t" ]; then 
   #     sed -i 's|# ALT-C - cd into the selected directory|# CTRL-S - cd into the selected directory|g' ~/.fzf/shell/key-bindings.bash
   #     sed -i 's|\\ec|\\C-s|g'  ~/.fzf/shell/key-bindings.bash
   #     #sed -i 's|bind -m emacs-standard '\''"\\ec"|bind -m emacs-standard '\''"\\es"|g'  ~/.fzf/shell/key-bindings.bash
   #     #sed -i 's|bind -m vi-command '\''"\\ec"|bind -m vi-command '\''"\\es"|g' ~/.fzf/shell/key-bindings.bash
   #     #sed -i 's|bind -m vi-insert  '\''"\\ec"|bind -m vi-insert  '\''"\\es"|g' ~/.fzf/shell/key-bindings.bash
   # fi
    unset fzf_t;
    
    
    if ! test -f ~/.bash_aliases.d/docker-fzf.sh; then
        reade -Q "GREEN" -i "y" -p "Install fzf-docker (fzf aliases for docker)? [Y/n]:" "y n" fzf_d
        if [ "$fzf_d" == "y" ] || [ -z "$fzf_d" ]; then 
            if ! test -f checks/check_aliases_dir.sh; then
                eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/checks/check_aliases_dir.sh)" 
            else
                ./checks/check_aliases_dir.sh
            fi
            wget -O ~/.bash_aliases.d/docker-fzf.sh https://raw.githubusercontent.com/MartinRamm/fzf-docker/master/docker-fzf 
        fi
    fi
    unset fzf_t;
 fi
