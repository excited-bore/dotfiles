# https://github.com/dandavison/delta
# https://github.com/so-fancy/diff-so-fancy
# https://github.com/walles/riff
# https://github.com/ymattw/ydiff
# https://github.com/mookid/diffr
# https://github.com/daveewart/colordiff
# https://github.com/Wilfred/difftastic
# https://github.com/czusual/p4merge
# https://github.com/KDE/kdiff3

if ! test -f checks/check_all.sh; then
    if hash curl &> /dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ./checks/check_all.sh
fi

SCRIPT_DIR=$(get-script-dir)

wrapprs='delta diff-so-fancy riff ydiff diffr colordiff'
cmds='difftastic nvim'
guis='kdiff3 p4merge vscode'

reade -Q "GREEN" -i "delta difftastic diff-so-fancy riff ydiff diffr colordiff" -p "Which to install? [Delta/difftastic/diff-so-fancy/riff/ydiff/diffr/colordiff]: " pager

if [[ $pager == "bat" ]]; then
    if ! test -f install_bat.sh; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_bat.sh)
    else
        . ./install_bat.sh
    fi

elif [[ $pager == "riff" ]]; then
    if ! test -f install_cargo.sh; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_cargo.sh)
    else
        . ./install_cargo.sh
    fi
    cargo install --locked riffdiff

elif [[ $pager == "difftastic" ]]; then
    if ! test -f install_cargo.sh; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_cargo.sh)
    else
        . ./install_cargo.sh
    fi
    cargo install --locked difftastic

elif [[ $pager == "diffr" ]]; then
    if ! test -f install_cargo.sh; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_cargo.sh)
    else
        . ./install_cargo.sh
    fi
    cargo install --locked diffr
fi

if [[ "$distro_base" == "Arch" ]]; then
    if [[ $pager == "diff-so-fancy" ]]; then
        eval "$pac_ins_y diff-so-fancy"
    elif [[ $pager == "colordiff" ]]; then
        eval "$pac_ins_y colordiff"
    elif [[ $pager == "delta" ]]; then
        eval "$pac_ins_y git-delta"
    elif [[ $pager == "ydiff" ]]; then
        if ! hash pipx &> /dev/null && ! test -f install_pipx.sh; then
            source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_pipx.sh)
        elif ! hash pipx &> /dev/null; then
            . ./install_pipx.sh
        fi
        pipx install ydiff
    fi
elif [[ "$distro_base" == "Debian" ]]; then
    if [[ $pager == "diff-so-fancy" ]]; then
        eval "$pac_ins_y npm"
        sudo npm -g install diff-so-fancy
    elif [[ $pager == "colordiff" ]]; then
        eval "$pac_ins_y colordiff"
    elif [[ $pager == "delta" ]]; then
        if ! test -f aliases/.aliases.d/git.sh; then
            source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.aliases.d/git.sh)
        else
            . ./aliases/.aliases.d/git.sh
        fi
        get-latest-releases-github 'https://github.com/dandavison/delta/releases' "$TMPDIR" 'git-delta_.*_amd64.deb' 
        sudo dpkg -i $TMPDIR/git-delta_*_amd64.deb 
    elif [[ $pager == "ydiff" ]]; then
        if ! hash pipx &> /dev/null && ! test -f install_pipx.sh; then
            source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_pipx.sh)
        elif ! hash pipx &> /dev/null; then
            . ./install_pipx.sh
        fi
        pipx install ydiff
    fi
fi
