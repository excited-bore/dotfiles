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

SCRIPT_DIR=$(get-script-dir)

if ! test -f checks/check_aliases_dir.sh; then
    source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/checks/check_aliases_dir.sh)
else
    . ./checks/check_aliases_dir.sh
fi

if ! type yt-dlp &>/dev/null; then
    if ! test pipx &>/dev/null; then
        if [[ $machine == 'Mac' ]] && type brew &>/dev/null; then
            brew install pipx
        elif [[ $distro_base == "Arch" ]]; then
            eval "${pac_ins}" python-pipx
        elif [[ $distro_base == "Debian" ]]; then
            eval "${pac_ins}" pipx
        fi
    fi
    pipx install yt-dlp
fi

if ! type ffmpeg &>/dev/null; then
    readyn -p 'Install ffmpeg (usefull for video/audio conversion)?' ffmpeg
    if [[ $ffmpeg == 'y' ]]; then
        if ! test -f install_ffmpeg.sh; then
            source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/install_ffmpeg.sh)
        else
            . ./install_ffmpeg.sh
        fi
    fi
fi

ytbe=aliases/.bash_aliases.d/youtube.sh
if ! test -d aliases/.bash_aliases.d/; then
    wget-aria-dir $TMPDIR/ https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/youtube.sh
    ytbe=$TMPDIR/youtube.sh
fi

ytbe() {
    cp "$ytbe" ~/.bash_aliases.d/
}
yes-edit-no -f ytbe -g "$ytbe" -p "Install yt-dlp (youtube cli download) and youtube.sh at ~/.bash_aliases.d/ (yt-dlp aliases)?"
