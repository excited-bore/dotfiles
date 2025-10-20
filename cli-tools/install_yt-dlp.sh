# https://github.com/yt-dlp/yt-dlp

hash yt-dlp &> /dev/null && SYSTEM_UPDATED='TRUE' 

TOP=$(git rev-parse --show-toplevel)

if ! [[ -f $TOP/checks/check_all.sh ]]; then
    if hash curl &> /dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . $TOP/checks/check_all.sh
fi

if ! hash yt-dlp &> /dev/null; then
    if ! hash pipx &>/dev/null; then
        if [[ $machine == 'Mac' ]] && hash brew &> /dev/null; then
            brew install pipx
        elif [[ $distro_base == "Arch" ]]; then
            eval "${pac_ins_y}" python-pipx
        elif [[ $distro_base == "Debian" ]]; then
            eval "${pac_ins_y}" pipx
        fi
    fi
    pipx install yt-dlp
fi

if ! hash ffmpeg &> /dev/null; then
    readyn -p 'Install ffmpeg (usefull for video/audio conversion)?' ffmpeg
    if [[ $ffmpeg == 'y' ]]; then
        if ! [[ -f $TOP/cli-tools/install_ffmpeg.sh ]]; then
            source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/cli-tools/install_ffmpeg.sh)
        else
            . $TOP/cli-tools/install_ffmpeg.sh
        fi
    fi
fi

if test -d ~/.aliases.d; then
    ytbe=$TOP/shell/aliases/.aliases.d/youtube.sh
    if ! [[ -d $TOP/shell/aliases/.aliases.d/ ]]; then
        wget-aria-dir $TMPDIR/ https://raw.githubusercontent.com/excited-bore/dotfiles/main/shell/aliases/.aliases.d/youtube.sh
        ytbe=$TMPDIR/youtube.sh
    fi

    ytbe() {
        cp "$ytbe" ~/.aliases.d/
    }
    yes-edit-no -f ytbe -g "$ytbe" -p "Install yt-dlp (youtube cli download) and youtube.sh at ~/.aliases.d/ (yt-dlp aliases)?"
fi
