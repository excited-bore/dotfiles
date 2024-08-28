#!/usr/bin/env bash

if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . checks/check_system.sh
fi

if ! test -f checks/check_pathvar.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_pathvar.sh)" 
else
    . ./checks/check_pathvar.sh
fi

if ! test -f aliases/.bash_aliases.d/update-system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/update-system.sh)" 
else
    . ./aliases/.bash_aliases.d/update-system.sh
fi

update-system

if ! test -f checks/check_pamac.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_pamac.sh)" 
else
    . ./checks/check_pamac.sh
fi


if ! test -f checks/check_rlwrap.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_rlwrap.sh)" 
else
    . ./checks/check_rlwrap.sh
fi

if ! test -f aliases/.bash_aliases.d/00-rlwrap_scripts.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/00-rlwrap_scripts.sh)" 
else
    . ./aliases/.bash_aliases.d/00-rlwrap_scripts.sh
fi


printf "${green}If all necessary files are sourced correctly, this text looks green.\nIf not, something went wrong.\n"
printf "\n${green}Files that get overwritten get backed up and trashed (to prevent clutter).\nRecover using ${cyan}'gio trash --list'${green} and ${cyan}'gio trash --restore' ${normal}\n"
printf "${green} Will now start with updating system ${normal}\n"


if [ ! -e ~/config ] && test -d ~/.config; then
    reade -Q "BLUE" -i "y" -p "Create ~/.config to ~/config symlink? [Y(es)/n(o)]: " "n" sym1
    if [ -z $sym1 ] || [ "y" == $sym1 ]; then
        ln -s ~/.config ~/config
    fi
fi

if [ ! -e ~/lib_systemd ] && test -d ~/lib/systemd/system; then
    reade -Q "BLUE" -i "y" -p "Create /lib/systemd/system/ to user directory symlink? [Y/n]: " "n" sym2
    if [ -z $sym2 ] || [ "y" == $sym2 ]; then
        ln -s /lib/systemd/system/ ~/lib_systemd
    fi
fi

if [ ! -e ~/etc_systemd ] && test -d ~/etc/systemd/system; then
    reade -Q "BLUE" -i "y" -p "Create /etc/systemd/system/ to user directory symlink? [Y/n]: " "n" sym3
    if [ -z $sym3 ] || [ "y" == $sym3 ]; then
        ln -s /etc/systemd/system/ ~/etc_systemd
    fi
fi

if [ ! -f /etc/modprobe.d/nobeep.conf ]; then
    reade -Q "GREEN" -i "y" -p "Remove terminal beep? (blacklist pcspkr) [Y/n]: " "n" beep
    if [ "$beep" == "y" ] || [ -z "$beep" ]; then
        echo "blacklist pcspkr" | sudo tee /etc/modprobe.d/nobeep.conf
    fi
fi

unset sym1 sym2 sym3 beep


if ! type AppImageLauncher &> /dev/null; then
    printf "${GREEN}If you want to install applications using appimages, there is a helper called 'appimagelauncher'\n"
     reade -Q "GREEN" -i "y" -p "Check if appimage ready and install appimagelauncher? [Y/n]: " "n" appimage_install
     if test $appimage_install == 'y'; then
         if ! test -f ./install_appimagelauncher.sh; then
            eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_appimagelauncher.sh)" 
         else
            ./install_appimagelauncher.sh
         fi
     fi
fi

#if ! type flatpak &> /dev/null; then
   #printf "%s\n" "${blue}No flatpak detected. (Independent package manager from Red Hat)${normal}"
   reade -Q "GREEN" -i "y" -p "Install (or just configure) Flatpak? [Y/n]: " "n" insflpk 
   if [ "y" == "$insflpk" ]; then
       if ! test -f install_flatpak.sh; then
           eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_flatpak.sh)" 
       else
           ./install_flatpak.sh 
       fi 
   fi
#fi
unset insflpk

if ! type snap &> /dev/null; then
    printf "%s\n" "${blue}No snap detected. (Independent package manager from Canonical)${normal}"
    reade -Q "MAGENTA" -i "n" -p "Install? [N/y]: " "y" inssnap 
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
    reade -Q "YELLOW" -i "n" -p "Install polkit files for automatic authentication for passwords? [N/y]: " "y" plkit
    if [ "y" == "$plkit" ]; then
        if ! test -f install_polkit_wheel.sh; then
            eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_polkit_wheel.sh)" 
        else
            ./install_polkit_wheel.sh
        fi 
    fi
    unset plkit
fi

pre='y'
othr='n'
color='GREEN'
prmpt='[Y/n]: '
echo "Next $(tput setaf 1)sudo$(tput sgr0) check for /root/.pathvariables.env' "
if test -f ~/.pathvariables.env && sudo test -f /root/.pathvariables.env; then
    pre='n' 
    othr='y'
    color='YELLOW'
    prmpt='[N/y]: '
fi 

reade -Q "$color" -i "$pre" -p "Check existence/create .pathvariables.env and link it to .bashrc in $HOME/ and /root/? $prmpt" "$othr" pathvars
if [ "$pathvars" == "y" ] || [ -z "$pathvars" ]; then
    ./install_pathvars.sh $pathvars 
fi


# Shell-keybinds

binds=keybinds/.inputrc
binds1=keybinds/.keybinds.d/keybinds.bash
binds2=keybinds/.keybinds
if ! test -f keybinds/.inputrc; then
    wget -P $TMPDIR/ https://raw.githubusercontent.com/excited-bore/dotfiles/main/keybinds/.inputrc
    wget -P $TMPDIR/ https://raw.githubusercontent.com/excited-bore/dotfiles/main/keybinds/.keybinds.d/keybinds.bash 
    wget -P $TMPDIR/ https://raw.githubusercontent.com/excited-bore/dotfiles/main/keybinds/.keybinds 
    
    binds=$TMPDIR/.inputrc
    binds1=$TMPDIR/keybinds.bash
    binds2=$TMPDIR/.keybinds
fi

if ! test -f /etc/inputrc; then
    sed -i 's/^$include \/etc\/inputrc/#$include \/etc\/inputrc/g' $binds
fi

shell-keybinds_r(){ 
    if [ -f /root/.pathvariables.env ]; then
       sudo sed -i 's|#export INPUTRC.*|export INPUTRC=~/.inputrc|g' /root/.pathvariables.env
    fi
    sudo cp -fv $binds1 /root/.keybinds.d/;
    sudo cp -fv $binds2 /root/.keybinds
    sudo cp -fv $binds /root/;
    if sudo test -f /root/.bashrc && ! sudo grep -q '[ -f /root/.keybinds ]' /root/.bashrc; then
         if grep -q '[ -f /root/.pathvariables.env ]' /root/.bashrc; then
                sed -i 's|\(\[ -f \/root/.pathvariables.env \] \&\& source \/root/.pathvariables.env\)|\1\n\[ -f \/root/.keybinds \] \&\& source \/root/.keybinds\n|g' /root/.bashrc
         else
               printf '[ -f ~/.keybinds ] && source ~/.keybinds' | sudo tee -a /root/.bashrc &> /dev/null
         fi
    fi
    # X based settings is generally not for root and will throw errors 
    if sudo grep -q '^setxkbmap' /root/.keybinds.d/keybinds.bash; then
        sudo sed -i 's|setxkbmap|#setxkbmap|g' /root/.keybinds.d/keybinds.bash
    fi
}

shell-keybinds() {
    if ! test -f ./checks/check_keybinds.sh; then
         eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_keybinds.sh)" 
    else
        . ./checks/check_keybinds.sh
    fi
    
    reade -Q "GREEN" -i "y" -p "Enable vi-mode instead of emacs mode (might cause issues with pasteing)? [Y/n]: " "n" vimde
    if [ "$vimde" == "y" ]; then
        sed -i "s|.set editing-mode .*|set editing-mode vi|g" $binds
    fi
    reade -Q "GREEN" -i "y" -p "Enable visual que for vi/emacs toggle? (Displayed as '(ins)/(cmd) - (emacs)') [Y/n]: " "n" vivisual
    if [ "$vivisual" == "y" ]; then
        sed -i "s|.set show-mode-in-prompt .*|set show-mode-in-prompt on|g" $binds
    fi
    reade -Q "GREEN" -i "y" -p "Set caps to escape? (Might cause X11 errors with SSH) [Y/n]: " "n" xtrm
    if [ "$xtrm" != "y" ] && ! [ -z "$xtrm" ]; then
        sed -i "s|setxkbmap |#setxkbmap |g" $binds
    fi
    cp -fv $binds1 ~/.keybinds.d/
    cp -fv $binds2 ~/.keybinds 
    cp -fv $binds ~/
    if test -f ~/.bashrc && ! grep -q '\[ -f ~/.keybinds \]' ~/.bashrc; then
         if grep -q '\[ -f ~/.pathvariables.env \]' ~/.bashrc; then
                sed -i 's|\(\[ -f \~/.pathvariables.env \] \&\& source \~/.pathvariables.env\)|\1\n\n\[ -f \~/.keybinds \] \&\& source \~/.keybinds\n|g' ~/.bashrc
         else
                echo '[ -f ~/.keybinds ] && source ~/.keybinds' >> ~/.bashrc
         fi
    fi
    
    if [ -f ~/.pathvariables.env ]; then
       sed -i 's|#export INPUTRC.*|export INPUTRC=~/.inputrc|g' ~/.pathvariables.env
    fi
    unset vimde vivisual xterm
    yes_edit_no shell-keybinds_r "$binds $binds2 $binds1" "Install .inputrc and keybinds.bash at /root/ and /root/.keybinds.d/?" "edit" "YELLOW"; 
}
yes_edit_no shell-keybinds "$binds $binds2 $binds1" "Install .inputrc and keybinds.bash at ~/ and ~/.keybinds.d/? (keybinds configuration)" "edit" "YELLOW"

# Xresources

xterm=xterm/.Xresources
if ! test -f xterm/.Xresources; then
    wget -P $TMPDIR/ https://raw.githubusercontent.com/excited-bore/dotfiles/main/xterm/.Xresources
    xterm=$TMPDIR/.Xresources
fi

xresources_r(){
    sudo cp -fv $xterm /root/.Xresources;
    }
xresources() {
    cp -fv $xterm ~/.Xresources;
    yes_edit_no xresources_r "$xterm" "Install .Xresources at /root/?" "edit" "RED"; }
yes_edit_no xresources "$xterm" "Install .Xresources at ~/? (Xterm configuration)" "edit" "YELLOW"

# Bash Preexec
if ! test -f ~/.bash_preexec || ! test -f /root/.bash_preexec; then
    reade -Q "GREEN" -i "y" -p "Install pre-execution hooks for bash in ~/.bash_preexec? [Y/n]: " "n" bash_preexec
    if [ -z "$bash_preexec" ] || [ "y" == "$bash_preexec" ]; then
        if ! test -f install_bash_preexec.sh; then
            eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_bash_preexec.sh)" 
        else
            ./install_bash_preexec.sh
        fi 
    fi
    unset bash_preexec
fi

if ! test -f checks/check_completions_dir.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_completions_dir.sh)" 
else
    . ./checks/check_completions_dir.sh
fi


# Bash alias completions
if ! test -f ~/.bash_completion.d/complete_alias || ! test -f /root/.bash_completion.d/complete_alias; then
    reade -Q "GREEN" -i "y" -p "Install bash completions for aliases in ~/.bash_completion.d? [Y/n]: " "n" compl
    if [ -z "$compl" ] || [ "y" == "$compl" ]; then
        if ! test -f install_bashalias_completions.sh; then
            eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_bashalias_completions.sh)" 
        else
            ./install_bashalias_completions.sh
        fi 
    fi
    unset compl
fi

# Python completions
if ! type activate-global-python-argcomplete &> /dev/null; then
    reade -Q "GREEN" -i "y" -p "Install python completions in ~/.bash_completion.d? [Y/n]: " "n" pycomp
    if [ -z $pycomp ] || [ "y" == $pycomp ]; then
        if ! test -f install_python_completions.sh; then
            eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_python_completions.sh)" 
        else
            ./install_python_completions.sh
        fi
    fi
    unset pycomp
fi

# Nvim (Editor)
pre='y'
othr='n'
color='GREEN'
prmpt='[Y/n]: '
if type nvim &> /dev/null; then
    pre='n' 
    othr='y'
    color='YELLOW'
    prmpt='[N/y]: '
fi
reade -Q "$color" -i "$pre" -p "Install Neovim? (Terminal editor) $prmpt" "$othr" nvm
if [ "y" == "$nvm" ]; then
    if ! test -f install_nvim.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_nvim.sh)" 
    else
        ./install_nvim.sh
    fi
fi
unset pre color othr nvm


# Kitty (Terminal emulator)
pre='y'
othr='n'
color='GREEN'
prmpt='[Y/n]: '
if type kitty &> /dev/null; then
    pre='n' 
    othr='y'
    color='YELLOW'
    prmpt='[N/y]: '
fi 

reade -Q "$color" -i "$pre" -p "Install Kitty? (Terminal emulator) $prmpt" "$othr" kittn
if [ "y" == "$kittn" ]; then
    if ! test -f install_kitty.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_kitty.sh)" 
    else
        ./install_kitty.sh
    fi
fi
unset pre color othr kittn


# Moar (Custom pager instead of less)
pre='y'
othr='n'
color='GREEN'
prmpt='[Y/n]: '
if type moar &> /dev/null; then
    pre='n' 
    othr='y'
    color='YELLOW'
    prmpt='[N/y]: '
fi 
reade -Q "$color" -i "$pre" -p "Install moar? (Custom pager with userfriendly default options - less replacement) $prmpt" "$othr" moar
if [ -z $moar ] || [ "Y" == $moar ] || [ $moar == "y" ]; then
    if ! test -f install_moar.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_moar.sh)" 
    else
        ./install_moar.sh 
    fi
fi
unset pre color othr moar

# Fzf (Fuzzy Finder)
pre='y'
othr='n'
color='GREEN'
prmpt='[Y/n]: '
if type fzf &> /dev/null && type rg &> /dev/null; then
    pre='n' 
    othr='y'
    color='YELLOW'
    prmpt='[N/y]: '
fi 
reade -Q "$color" -i "$pre" -p "Install fzf? (Fuzzy file/folder finder - keybinding yes for upgraded Ctrl-R/reverse-search, fzf filenames on Ctrl+T and fzf-version of 'cd' on Alt-C + Custom script: Ctrl-f becomes system-wide file opener) $prmpt" "$othr" findr
if [ "y" == "$findr" ]; then
    if ! test -f install_fzf.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_fzf.sh)" 
    else
        ./install_fzf.sh
    fi
fi
unset pre color othr findr

# Git
pre='y'
othr='n'
color='GREEN'
prmpt='[Y/n]: '
if type git &> /dev/null && test -f ~/.gitconfig; then
    pre='n' 
    othr='y'
    color='YELLOW'
    prmpt='[N/y]: '
fi 
reade -Q "$color" -i "$pre" -p "Install Git and configure? (Project managing tool) $prmpt" "$othr" git_ins
if [ "y" == "$git_ins" ]; then
    if ! test -f install_git.sh; then
        ins_git=$(mktemp)
        wget -O $ins_git https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_git.sh   
        chmod u+x "$ins_git"
        eval "$ins_git" 'global'
    else
        ./install_git.sh 'global'
    fi
fi
unset pre color othr git_ins

# Lazygit
pre='y'
othr='n'
color='GREEN'
prmpt='[Y/n]: '
if type lazygit &> /dev/null; then
    pre='n' 
    othr='y'
    color='YELLOW'
    prmpt='[N/y]: '
fi 
reade -Q "$color" -i "$pre" -p "Install lazygit? $prmpt" "$othr" git_ins
if [ "y" == "$git_ins" ]; then
    if ! test -f install_lazygit.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_lazygit.sh)" 
    elaylse
        ./install_lazygit.sh
    fi
fi
unset pre color othr git_ins

# Osc
#reade -Q "GREEN" -i "y" -p "Install Osc52 clipboard? (Universal clipboard tool / works natively over ssh) [Y/n]: " "n" osc
#if [ -z $osc ] || [ "Y" == $osc ] || [ $osc == "y" ]; then
#    ./install_osc.sh 
#fi
#unset osc


# Ranger (File explorer)
pre='y'
othr='n'
color='GREEN'
prmpt='[Y/n]: '
if type ranger &> /dev/null; then
    pre='n' 
    othr='y'
    color='YELLOW'
    prmpt='[N/y]: '
fi 
reade -Q "$color" -i "$pre" -p "Install Ranger? (Terminal file explorer) $prmpt" "$othr" rngr
if [ "y" == "$rngr" ]; then
    if ! test -f install_ranger.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_ranger.sh)" 
    else
        ./install_ranger.sh
    fi
fi
unset pre color othr rngr

# Tmux (File explorer)
pre='y'
othr='n'
color='GREEN'
prmpt='[Y/n]: '
if type tmux &> /dev/null; then
    pre='n' 
    othr='y'
    color='YELLOW'
    prmpt='[N/y]: '
fi 
reade -Q "$color" -i "$pre" -p "Install Tmux? (Terminal multiplexer) $prmpt" "$othr" tmx
if [ "y" == "$tmx" ]; then
    if ! test -f install_tmux.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_tmux.sh)" 
    else
        ./install_tmux.sh
    fi
fi
unset pre color othr tmx

# Bat
pre='y'
othr='n'
color='GREEN'
prmpt='[Y/n]: '
if type bat &> /dev/null; then
    pre='n' 
    othr='y'
    color='YELLOW'
    prmpt='[N/y]: '
fi 

reade -Q "$color" -i "$pre" -p "Install Bat? (Cat clone with syntax highlighting) $prmpt" "$othr" bat
if [ -z $bat ] || [ "Y" == $bat ] || [ $bat == "y" ]; then
    if ! test -f install_bat.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_bat.sh)" 
    else
        ./install_bat.sh 
    fi
fi
unset bat


# Neofetch
if ! type neofetch &> /dev/null && ! type fastfetch &> /dev/null && ! type screenfetch &> /dev/null; then
    reade -Q "GREEN" -i "y" -p "Install neofetch/fastfetch/screenFetch)? (Terminal taskmanager - system information tool) [Y/n]:" "n" tojump
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
if ! type bashtop &> /dev/null && ! type bpytop &> /dev/null && ! type btop &> /dev/null; then
    reade -Q "GREEN" -i "y" -p "Install bashtop? (Python based improved top/htop) [Y/n]: " "n" tojump
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
    reade -Q "GREEN" -i "y" -p "Install autojump? (jump to folders using 'bookmarks' - j_ ) [Y/n]: " "n" tojump
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
    reade -Q "GREEN" -i "y" -p "Install Starship? (Snazzy looking prompt) [Y/n]: " "n" strshp
    if [ $strshp == "y" ]; then
        if ! test -f install_starship.sh; then
            eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_starship.sh)" 
        else
            ./install_starship.sh 
        fi
    fi
    unset strshp
fi

# Srm (Secure remove)
if ! type srm &> /dev/null; then
    reade -Q "GREEN" -i "y" -p "Install srm? (Secure remove) [Y/n]: " "n" kittn
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
    reade -Q "GREEN" -i "y" -p "Install testdisk? (File recovery tool) [Y/n]: " "n" kittn
    if [ "y" == "$kittn" ]; then
        if ! test -f install_testdisk.sh; then
            eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_testdisk.sh)" 
        else
            ./install_testdisk.sh
        fi
    fi
    unset kittn
fi

# Nmap
if ! type nmap &> /dev/null; then
    reade -Q "GREEN" -i "y" -p "Install nmap? (Network port scanning tool) [Y/n]: " "n" tojump
    if [ "$tojump" == "y" ]; then
        if ! test -f install_nmap.sh; then
            eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_nmap.sh)" 
        else
            ./install_nmap.sh
        fi
    fi
    unset tojump
fi

# Yt-dlp
if ! type yt-dlp &> /dev/null; then
    reade -Q "GREEN" -i "y" -p "Install yt-dlp? (youtube video downloader) [Y/n]: " "n" tojump
    if [ "$tojump" == "y" ]; then
        if ! test -f install_yt-dlp.sh; then
            eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_yt-dlp.sh)" 
        else
            ./install_yt-dlp.sh
        fi
    fi
    unset tojump
fi

reade -Q "GREEN" -i "y" -p "Install bash aliases and other config? [Y/n]: " "n" scripts
if [ -z $scripts ] || [ "y" == $scripts ]; then

    if ! test -f checks/check_aliases_dir.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/checks/check_aliases_dir.sh)" 
    else
        ./checks/check_aliases_dir.sh
    fi
    
    genr=aliases/.bash_aliases.d/general.sh
    if ! test -f aliases/.bash_aliases.d/general.sh; then
        wget -P $TMPDIR/ https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/general.sh 
        genr=$TMPDIR/general.sh
    fi
    
    reade -Q "GREEN" -i "y" -p "Install general.sh at ~/? (aliases related to general actions - cd/mv/cp/rm + completion script replacement for 'read -e') [Y/n]: " "n" ansr         
    
    if test $ansr == "y"; then
        if test -f ~/.pathvariables.env; then
            sed -i 's|^export TRASH_BIN_LIMIT=|export TRASH_BIN_LIMIT=|g' ~/.pathvariables.env
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
        reade -Q "YELLOW" -i "n" -p "Set 'gio trash' alias for rm? [N/y]: " "y" ansr 
        if [ "$ansr" != "y" ]; then
            sed -i 's|^alias rm="gio trash"|#alias rm="gio trash"|g' $genr
        else
            sed -i 's|.*alias rm="gio trash"|alias rm="gio trash"|g' $genr
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
            yes_edit_no general_r "$genr" "Install general.sh at /root/?" "yes" "GREEN"; }
        yes_edit_no general "$genr" "Install general.sh at ~/?" "edit" "GREEN"
    fi

    update_sysm=aliases/.bash_aliases.d/update-system.sh
    systemd=aliases/.bash_aliases.d/systemctl.sh
    dosu=aliases/.bash_aliases.d/sudo.sh
    pacmn=aliases/.bash_aliases.d/package_managers.sh
    sshs=aliases/.bash_aliases.d/ssh.sh
    ps1=aliases/.bash_aliases.d/PS1_colours.sh
    manjaro=aliases/.bash_aliases.d/manjaro.sh
    variti=aliases/.bash_aliases.d/variety.sh
    pthon=aliases/.bash_aliases.d/python.sh
    if ! test -d aliases/.bash_aliases.d/; then
        wget -P $TMPDIR/ https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/update-system.sh 
        update_sysm=$TMPDIR/update-system.sh
        wget -P $TMPDIR/ https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/systemctl.sh 
        systemd=$TMPDIR/systemctl.sh
        wget -P $TMPDIR/  https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/sudo.sh 
        dosu=$TMPDIR/sudo.sh
        wget -P $TMPDIR/ https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/package_managers.sh 
        pacmn=$TMPDIR/package_managers.sh
        wget -P $TMPDIR/ https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/ssh.sh 
        sshs=$TMPDIR/ssh.sh
        wget -P $TMPDIR/ https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/ps1.sh 
        ps1=$TMPDIR/ps1.sh
        wget -P $TMPDIR/ https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/manjaro.sh 
        manjaro=$TMPDIR/manjaro.sh
        wget -P $TMPDIR/ https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/variety.sh 
        variti=$TMPDIR/variety.sh
        wget -P $TMPDIR/ https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/python.sh 
        pthon=$TMPDIR/python.sh
    fi 

    update_sysm_r(){ 
        sudo cp -fv $update_sysm /root/.bash_aliases.d/;
        sudo sed -i '/SYSTEM_UPDATED="TRUE"/d' /root/.bash_aliases.d/update-system.sh
    }
    update_sysm(){
        cp -fv $update_sysm ~/.bash_aliases.d/
        sed -i '/SYSTEM_UPDATED="TRUE"/d' ~/.bash_aliases.d/update-system.sh
        yes_edit_no update_sysm_r "$update_sysm" "Install update-system.sh at /root/?" "yes" "GREEN";
    }
    yes_edit_no update_sysm "$update_sysm" "Install update-system.sh at ~/.bash_aliases.d/? (Global system update function)?" "edit" "GREEN"

    systemd_r(){ 
        sudo cp -fv $systemd /root/.bash_aliases.d/;
    }
    systemd(){
        cp -fv $systemd ~/.bash_aliases.d/
        yes_edit_no systemd_r "$systemd" "Install systemctl.sh at /root/?" "yes" "GREEN"; }
    yes_edit_no systemd "$systemd" "Install systemctl.sh at ~/.bash_aliases.d/? (systemctl aliases/functions)?" "edit" "GREEN"
        

    dosu_r(){ 
        sudo cp -fv $dosu /root/.bash_aliases.d/ ;
    }    

    dosu(){ 
        cp -fv $dosu ~/.bash_aliases.d/;
        yes_edit_no dosu_r "$dosu" "Install sudo.sh at /root/?" "yes" "GREEN"; }
    yes_edit_no dosu "$dosu" "Install sudo.sh at ~/.bash_aliases.d/ (sudo aliases)?" "edit" "GREEN"


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
    yes_edit_no pthon "$pthon" "Install python.sh at ~/.bash_aliases.d/ (aliases for a python development)? " "edit" "GREEN" 

fi

source ~/.bashrc

echo "${cyan}${bold}Source .bashrc 'source ~/.bashrc' and you can check all aliases with 'alias'";
alias -p;
echo "${green}${bold}Done!"
