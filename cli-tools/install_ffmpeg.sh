# https://www.ffmpeg.org/

hash ffmpeg &> /dev/null && SYSTEM_UPDATED='TRUE'

TOP=$(git rev-parse --show-toplevel)

if ! test -f $TOP/checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . $TOP/checks/check_all.sh
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

if hash ffmpeg &>/dev/null && test -d ~/.aliases.d; then

    ffmpgsh=$TOP/shell/aliases/.aliases.d/ffmpeg.sh

    if ! [ -f $ffmpgsh ]; then
        wget-aria-dir $TMPDIR/ https://raw.githubusercontent.com/excited-bore/dotfiles/main/shell/aliases/.aliases.d/ffmpeg.sh
        ffmpgsh=$TMPDIR/ffmpeg.sh
    fi

    function ins_ffmpg() {
        cp $ffmpgsh ~/.aliases.d/
    }

    yes-edit-no -f ins_ffmpg -g "$ffmpgsh" -p "Install ffmpeg.sh to $HOME/.aliases.d/?" 

    unset ffmpgsh
fi
