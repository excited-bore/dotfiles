if ! [ -f checks/check_all.sh ]; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ./checks/check_all.sh
fi

SCRIPT_DIR=$(get-script-dir)

if ! [ -f checks/check_envvar_aliases_completions_keybinds.sh ]; then
    source <(wget-curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_envvar_aliases_completions_keybinds.sh)
else
    . ./checks/check_envvar_aliases_completions_keybinds.sh
fi

if ! hash ffmpeg &>/dev/null; then
    if [[ $machine == 'Mac' ]] && hash brew &>/dev/null; then
        brew install ffmpeg
    elif [[ $distro_base == "Arch" ]]; then
        eval "${pac_ins_y}" ffmpeg
    elif [[ $distro_base == "Debian" ]]; then
        eval "${pac_ins_y}" ffmpeg
    fi
fi

if hash ffmpeg &>/dev/null; then

    ffmpgsh=$SCRIPT_DIR/aliases/.aliases.d/ffmpeg.sh

    if ! [ -f $ffmpgsh ]; then
        wget-aria-dir $TMPDIR/ https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.aliases.d/ffmpeg.sh
        ffmpgsh=$TMPDIR/ffmpeg.sh
    fi

    function ins_ffmpg_r() {
        sudo cp $ffmpgsh /root/.aliases.d/
    }

    function ins_ffmpg() {
        cp $ffmpgsh ~/.aliases.d/
        yes-edit-no -Y 'YELLOW' -f ins_ffmpg_r -g "$ffmpgsh" -p "Install ffmpeg.sh to /root/.aliases.d/?"
    }

    yes-edit-no -f ins_ffmpg -g "$ffmpgsh" -p "Install ffmpeg.sh to $HOME/.aliases.d/?" 

    unset ffmpgsh
fi
