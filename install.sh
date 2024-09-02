#!/usr/bin/env bash

if ! test -f aliases/.bash_aliases.d/00-rlwrap_scripts.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/00-rlwrap_scripts.sh)" 
else
    . ./aliases/.bash_aliases.d/00-rlwrap_scripts.sh
fi

if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . checks/check_system.sh
fi

if ! test -f checks/check_envvar.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_envvar.sh)" 
else
    . ./checks/check_envvar.sh
fi

if ! test -f aliases/.bash_aliases.d/update-system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/update-system.sh)" 
else
    . ./aliases/.bash_aliases.d/update-system.sh
fi

update-system

if ! test -f checks/check_rlwrap.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_rlwrap.sh)" 
else
    . ./checks/check_rlwrap.sh
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

if ! test -f checks/check_envvar.sh; then
    eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_envvar.sh)" 
else
    . ./checks/check_envvar.sh
fi

if ! test -f checks/check_completions_dir.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_completions_dir.sh)" 
else
fi
    . ./checks/check_completions_dir.sh


# Environment variables

echo "Next $(tput setaf 1)sudo$(tput sgr0) check for /root/.environment.env' "
if ! test -f ~/.environment.env || ! sudo test -f /root/.environment.env; then
				pathvr=$(pwd)/envvars/.environment.env
				if ! test -f $pathvr; then
								wget -P $TMPDIR/ https://raw.githubusercontent.com/excited-bore/dotfiles/main/envvars/.environment.env
								pathvr=$TMPDIR/.environment.env
				fi

				reade -Q "GREEN" -i "y" -p "Put sample environment.env file in $HOME folder and link it to ~/.bashrc? [Y/n]: " "n" envvars
				if [ "$envvars" == "y" ] || [ -z "$envvars" ]; then
								#Comment out every export in .environment
								sed -i -e '/export/ s/^#*/#/' $pathvr
												
								# Allow if checks
								sed -i 's/^#\[\[/\[\[/' $pathvr
								sed -i 's/^#type/type/' $pathvr
								
								# Comment out FZF stuff
								sed -i 's/  --bind/ #--bind/' $pathvr
								sed -i 's/  --preview-window/ #--preview-window/' $pathvr
								sed -i 's/  --color/ #--color/' $pathvr
        
								cp -fv $pathvr ~/.environment.env
								
								if ! sudo test -f /root/.environment.env; then
													reade -Q "GREEN" -i "y" -p "Also put sample '.environment.env' file in /root folder and link it to /root/.bashrc? [Y/n]: " "n" envvars
													if [ "$envvars" == "y" ] || [ -z "$envvars" ]; then
																	sudo cp -fv $pathvr /root/.environment.env;
													fi	
								fi
								unset envvars	
				fi
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

reade -Q "GREEN" -i "y" -p "Install bash aliases and other config? [Y/n]: " "n" scripts
if [ -z $scripts ] || [ "y" == $scripts ]; then

    if ! test -f checks/check_aliases_dir.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/checks/check_aliases_dir.sh)" 
    else
        ./checks/check_aliases_dir.sh
    fi
    if ! test -f install_aliases.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/install_aliases.sh)" 
    else
        ./install_aliases.sh
    fi
        

fi

source ~/.bashrc


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
    if [ -f /root/.environment.env ]; then
       sudo sed -i 's|#export INPUTRC.*|export INPUTRC=~/.inputrc|g' /root/.environment.env
    fi
    sudo cp -fv $binds1 /root/.keybinds.d/;
    sudo cp -fv $binds2 /root/.keybinds
    sudo cp -fv $binds /root/;
    if sudo test -f /root/.bashrc && ! sudo grep -q '[ -f /root/.keybinds ]' /root/.bashrc; then
         if grep -q '[ -f /root/.bash_aliases ]' /root/.bashrc; then
                sed -i 's|\(\[ -f \/root/.bash_aliases \] \&\& source \/root/.bash_aliases\)|\1\n\[ -f \/root/.keybinds \] \&\& source \/root/.keybinds\n|g' /root/.bashrc
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
         if grep -q '\[ -f ~/.bash_aliases \]' ~/.bashrc; then
                sed -i 's|\(\[ -f \~/.bash_aliases \] \&\& source \~/.bash_aliases\)|\1\n\n\[ -f \~/.keybinds \] \&\& source \~/.keybinds\n|g' ~/.bashrc
         else
                echo '[ -f ~/.keybinds ] && source ~/.keybinds' >> ~/.bashrc
         fi
    fi
    
    if [ -f ~/.environment.env ]; then
       sed -i 's|#export INPUTRC.*|export INPUTRC=~/.inputrc|g' ~/.environment.env
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
reade -Q "$color" -i "$pre" -p "Install moar? (Custom pager/less replacement - awesome default options) $prmpt" "$othr" moar
if [ -z $moar ] || [ "Y" == $moar ] || [ $moar == "y" ]; then
    if ! test -f install_moar.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_moar.sh)" 
    else
        ./install_moar.sh 
    fi
fi
unset pre color othr moar


# Nano (Editor)
pre='y'
othr='n'
color='GREEN'
prmpt='[Y/n]: '
if type nano &> /dev/null; then
    pre='n' 
    othr='y'
    color='YELLOW'
    prmpt='[N/y]: '
fi
reade -Q "$color" -i "$pre" -p "Install nano + config? (Simple terminal editor) $prmpt" "$othr" nno
if [ "y" == "$nno" ]; then
    if ! test -f install_nano.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_nano.sh)" 
    else
        ./install_nano.sh
    fi
fi
unset pre color othr nno


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
reade -Q "$color" -i "$pre" -p "Install neovim + config? (Complex terminal editor) $prmpt" "$othr" nvm
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
    else
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
unset pre color othr prmpt tmx

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
unset pre color othr prmpt 


# Neofetch
pre='y'
othr='n'
color='GREEN'
prmpt='[Y/n]: '
if type neofetch &> /dev/null || type fastfetch &> /dev/null || type screenfetch &> /dev/null; then
    pre='n' 
    othr='y'
    color='YELLOW'
    prmpt='[N/y]: '
fi 

reade -Q "$color" -i "$pre" -p "Install neofetch/fastfetch/screenFetch)? (Terminal taskmanager - system information tool) $prmpt" "$othr" tojump
if [ "$tojump" == "y" ]; then
    if ! test -f install_neofetch.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_neofetch.sh)" 
    else
        ./install_neofetch.sh
    fi
fi
unset tojump
unset pre color othr prmpt 


# Bashtop
pre='y'
othr='n'
color='GREEN'
prmpt='[Y/n]: '
if type bashtop &> /dev/null || type bpytop &> /dev/null || type btop &> /dev/null; then
    pre='n' 
    othr='y'
    color='YELLOW'
    prmpt='[N/y]: '
fi 

reade -Q "$color" -i "$pre" -p "Install bashtop? (Python based improved top/htop) $prmpt" "$othr" tojump
if [ "$tojump" == "y" ]; then
    if ! test -f install_bashtop.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_bashtop.sh)" 
    else
        ./install_bashtop.sh
    fi
fi
unset tojump
unset pre color othr prmpt 


# Autojump
pre='y'
othr='n'
color='GREEN'
prmpt='[Y/n]: '
if type autojump &> /dev/null; then
    pre='n' 
    othr='y'
    color='YELLOW'
    prmpt='[N/y]: '
fi 
#if ! type autojump &> /dev/null; then
    reade -Q "$color" -i "$pre" -p "Install autojump? (jump to folders using 'bookmarks' - j_ ) $prmpt" "$othr" tojump
    if [ "$tojump" == "y" ]; then
        if ! test -f install_autojump.sh; then
            eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_autojump.sh)" 
        else
            ./install_autojump.sh
        fi
    fi
    unset tojump
    unset pre color othr prmpt 
#fi

# Starship
pre='y'
othr='n'
color='GREEN'
prmpt='[Y/n]: '
if type starship &> /dev/null; then
    pre='n' 
    othr='y'
    color='YELLOW'
    prmpt='[N/y]: '
fi 

reade -Q "$color" -i "$pre" -p "Install Starship? (Snazzy looking prompt) $prmpt" "$othr" strshp
if [ $strshp == "y" ]; then
    if ! test -f install_starship.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_starship.sh)" 
    else
        ./install_starship.sh 
    fi
fi
unset strshp
unset pre color othr prmpt 

# Ffmpeg
pre='y'
othr='n'
color='GREEN'
prmpt='[Y/n]: '
if type ffmpeg &> /dev/null; then
    pre='n' 
    othr='y'
    color='YELLOW'
    prmpt='[N/y]: '
fi 
#if ! type yt-dlp &> /dev/null; then
reade -Q "$color" -i "$pre" -p "Install ffmpeg? (video/audio/image file converter) $prmpt" "$othr" ffmpg
if [ "$ffmpg" == "y" ]; then
				if ! test -f install_ffmpeg.sh; then
								eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_ffmpeg.sh)" 
				else
								./install_ffmpeg.sh
				fi
fi
unset ffmpg
unset pre color othr prmpt 



# Nmap
pre='y'
othr='n'
color='GREEN'
prmpt='[Y/n]: '
if ! type nmap &> /dev/null; then
    pre='n' 
    othr='y'
    color='YELLOW'
    prmpt='[N/y]: '
fi 
#
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
    unset pre color othr prmpt 
fi

# Netstat
pre='y'
othr='n'
color='GREEN'
prmpt='[Y/n]: '
if type netstat &> /dev/null; then
    pre='n' 
    othr='y'
    color='YELLOW'
    prmpt='[N/y]: '
fi 

reade -Q "GREEN" -i "y" -p "Install netstat? (Also port scanning tool) [Y/n]: " "n" tojump
if [ "$tojump" == "y" ]; then
    if ! test -f install_netstat.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_netstat.sh)" 
    else
        ./install_netstat.sh
    fi
fi
unset tojump
unset pre color othr prmpt 


# Testdisk (File recovery tool)
pre='y'
othr='n'
color='GREEN'
prmpt='[Y/n]: '
if type testdisk &> /dev/null; then
    pre='n' 
    othr='y'
    color='YELLOW'
    prmpt='[N/y]: '
fi 

reade -Q "$color" -i "$pre" -p "Install testdisk? (File recovery tool) $prmpt" "$othr" kittn
if [ "y" == "$kittn" ]; then
    if ! test -f install_testdisk.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_testdisk.sh)" 
    else
        ./install_testdisk.sh
    fi
fi
unset kittn
unset pre color othr prmpt 

# Exiftool (Metadata wiper)
pre='y'
othr='n'
color='GREEN'
prmpt='[Y/n]: '
if type exiftool &> /dev/null; then
    pre='n' 
    othr='y'
    color='YELLOW'
    prmpt='[N/y]: '
fi 

reade -Q "$color" -i "$pre" -p "Install exiftool? (Metadata wiper for files) $prmpt" "$othr" moar
if [ -z $moar ] || [ "Y" == $moar ] || [ $moar == "y" ]; then
    if ! test -f install_exiftool.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_exiftool.sh)" 
    else
        ./install_exiftool.sh 
    fi
fi
unset pre color othr prmpt moar


# Yt-dlp
pre='y'
othr='n'
color='GREEN'
prmpt='[Y/n]: '
if type yt-dlp &> /dev/null; then
    pre='n' 
    othr='y'
    color='YELLOW'
    prmpt='[N/y]: '
fi 
#if ! type yt-dlp &> /dev/null; then
    reade -Q "$color" -i "$pre" -p "Install yt-dlp? (youtube video downloader) $prmpt" "$othr" tojump
    if [ "$tojump" == "y" ]; then
        if ! test -f install_yt-dlp.sh; then
            eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_yt-dlp.sh)" 
        else
            ./install_yt-dlp.sh
        fi
    fi
    unset tojump
    unset pre color othr prmpt 
#fi

pre='y'
othr='n'
color='GREEN'
prmpt='[Y/n]: '
echo "Next $(tput setaf 1)sudo$(tput sgr0) check for /root/.environment.env' "
if test -f ~/.environment.env && sudo test -f /root/.environment.env; then
    pre='n' 
    othr='y'
    color='YELLOW'
    prmpt='[N/y]: '
fi 

reade -Q "$color" -i "$pre" -p "Check existence/create .environment.env and link it to .bashrc in $HOME/ and /root/? $prmpt" "$othr" envvars
if [ "$envvars" == "y" ] || [ -z "$envvars" ]; then
    if ! test -f install_envvars.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_envvars.sh)" 
    else
        ./install_envvars.sh  
    fi 
fi

echo "Next $(tput setaf 1)sudo$(tput sgr0) will check whether root account is enabled"
if ! test $(sudo passwd -S | awk '{print $2}') == 'L'; then
    printf "${CYAN}One more thing before finishing off${normal}: the ${RED}root${normal} account is still enabled.\n${RED1}This can be considered a security risk!!${normal}\n"
    reade -Q 'YELLOW' -i 'y' -p 'Disable root account? (Enable again by giving up a password with \\"sudo passwd root\\") [Y/n]: ' 'n' root_dis
    if test $root_dis == 'y'; then
       sudo passwd -l root 
    fi
    unset root_dis
fi

echo "${cyan}${bold}Source .bashrc 'source ~/.bashrc' and you can check all aliases with 'alias'";
alias -p;
echo "${green}${bold}Done!"
