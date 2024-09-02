#!/usr/bin/env bash

if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi

if ! test -f checks/check_envvar_aliases_completions_keybinds.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_envvar_aliases_completions_keybinds.sh)" 
else
    . ./checks/check_envvar_aliases_completions_keybinds.sh
fi

if ! type update-system &> /dev/null; then
    if ! test -f aliases/.bash_aliases.d/update-system.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/update-system.sh)" 
    else
        . ./aliases/.bash_aliases.d/update-system.sh
    fi
fi

if test -z $SYSTEM_UPDATED; then
    reade -Q "CYAN" -i "n" -p "Update system? [Y/n]: " "y" updatesysm
    if test $updatesysm == "y"; then
        update-system                     
    fi
fi

if ! type ffmpeg &> /dev/null; then 
    if test $machine == 'Mac' && type brew &> /dev/null; then
        brew install ffmpeg
    elif test $distro == "Arch" || test $distro == "Manjaro"; then
        sudo pacman -S ffmpeg
    elif [ $distro_base == "Debian" ]; then
        sudo apt install ffmpeg 
    fi
fi

if type ffmpeg &> /dev/null; then
							
						ffmpgsh=$(pwd)/aliases/.bash_aliases.d/ffmpeg.sh
						if ! test -f $ffmpgsh; then
										wget -P $TMPDIR/ https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/ffmpeg.sh
										ffmpgsh=$TMPDIR/ffmpeg.sh
						fi

						function ins_ffmpg_r(){
										sudo cp -vf $ffmpgsh /root/.bash_aliases.d/
						}	

						function ins_ffmpg(){
										cp -vf $ffmpgsh ~/.bash_aliases.d/nix.sh
										yes_edit_no ins_ffmpg_r "$ffmpgsh" "Install ffmpeg.sh to /root? (nix bash aliases)" "yes" "GREEN"; 
						}	
						yes_edit_no ins_ffmpg "$ffmpgsh" "Install ffmpeg.sh to $HOME? (nix bash aliases)" "yes" "GREEN"

						unset ffmpgsh	
fi
