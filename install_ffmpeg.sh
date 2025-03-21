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
    readyn -Y "CYAN" -p "Update system?" updatesysm
    if test $updatesysm == "y"; then
        update-system                     
    fi
fi

if ! type ffmpeg &> /dev/null; then 
    if test $machine == 'Mac' && type brew &> /dev/null; then
        brew install ffmpeg
    elif test $distro == "Arch" || test $distro == "Manjaro"; then
        eval "$pac_ins ffmpeg"
    elif [ $distro_base == "Debian" ]; then
        eval "$pac_ins ffmpeg "
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
        yes-no-edit -f ins_ffmpg_r -g "$ffmpgsh" -p "Install ffmpeg.sh to /root? (nix bash aliases)" -i "y" -Q "GREEN"; 
    }	

    yes-no-edit -f ins_ffmpg -g "$ffmpgsh" -p "Install ffmpeg.sh to $HOME? (nix bash aliases)" -i "y" -Q "GREEN"

    unset ffmpgsh	
fi
