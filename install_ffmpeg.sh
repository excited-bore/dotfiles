#!/usr/bin/env bash

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

get-script-dir SCRIPT_DIR

if ! test -f checks/check_envvar_aliases_completions_keybinds.sh; then
    eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_envvar_aliases_completions_keybinds.sh)"
else
    . ./checks/check_envvar_aliases_completions_keybinds.sh
fi

if ! type ffmpeg &>/dev/null; then
    if [[ $machine == 'Mac' ]] && type brew &>/dev/null; then
        brew install ffmpeg
    elif [[ $distro_base == "Arch" ]]; then
        eval "${pac_ins}" ffmpeg
    elif [[ $distro_base == "Debian" ]]; then
        eval "${pac_ins}" ffmpeg
    fi
fi

if type ffmpeg &>/dev/null; then

    ffmpgsh=$(pwd)/aliases/.bash_aliases.d/ffmpeg.sh

    if ! test -f $ffmpgsh; then
        wget -P $TMPDIR/ https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/ffmpeg.sh
        ffmpgsh=$TMPDIR/ffmpeg.sh
    fi

    function ins_ffmpg_r() {
        sudo cp -vf $ffmpgsh /root/.bash_aliases.d/
    }

    function ins_ffmpg() {
        cp -vf $ffmpgsh ~/.bash_aliases.d/nix.sh
        yes-no-edit -f ins_ffmpg_r -g "$ffmpgsh" -p "Install ffmpeg.sh to /root? (nix bash aliases)" -i "y" -Q "GREEN"
    }

    yes-no-edit -f ins_ffmpg -g "$ffmpgsh" -p "Install ffmpeg.sh to $HOME? (nix bash aliases)" -i "y" -Q "GREEN"

    unset ffmpgsh
fi
