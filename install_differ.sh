# https://github.com/dandavison/delta
# https://github.com/so-fancy/diff-so-fancy
# https://github.com/walles/riff
# https://github.com/ymattw/ydiff
# https://github.com/mookid/diffr
# https://github.com/daveewart/colordiff
# https://github.com/Wilfred/difftastic
# https://github.com/czusual/p4merge
# https://github.com/KDE/kdiff3

SYSTEM_UPDATED='TRUE'

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

wrapprs='delta diff-so-fancy riff ydiff diffr colordiff'
cmds='difftastic nvim'
guis='kdiff3 p4merge vscode'

reade -Q "GREEN" -i "delta difftastic diff-so-fancy riff ydiff diffr colordiff" -p "Which to install? [Delta/difftastic/diff-so-fancy/riff/ydiff/diffr/colordiff]: " pager

if [[ $pager == "bat" ]]; then
    if ! [[ -f $TOP/cli-tools/install_bat.sh ]]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/install_bat.sh)
    else
        . $TOP/cli-tools/install_bat.sh
    fi

elif [[ $pager == "riff" ]]; then
    if ! [[ -f $TOP/cli-tools/pkgmngrs/install_cargo.sh ]]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/pkgmngrs/install_cargo.sh)
    else
        . $TOP/cli-tools/pkgmngrs/install_cargo.sh
    fi
    cargo install --locked riffdiff

elif [[ $pager == "difftastic" ]]; then
    if ! [[ -f $TOP/cli-tools/pkgmngrs/install_cargo.sh ]]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/pkgmngrs/install_cargo.sh)
    else
        . $TOP/cli-tools/pkgmngrs/install_cargo.sh
    fi
    cargo install --locked difftastic

elif [[ $pager == "diffr" ]]; then
    if ! [[ -f $TOP/cli-tools/pkgmngrs/install_cargo.sh ]]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/pkgmngrs/install_cargo.sh)
    else
        . $TOP/cli-tools/pkgmngrs/install_cargo.sh
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
        if ! hash pipx &> /dev/null && ! [[ -f $TOP/cli-tools/pkgmngrs/install_pipx.sh ]]; then
            source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/pkgmngrs/install_pipx.sh)
        elif ! hash pipx &> /dev/null; then
            . $TOP/cli-tools/pkgmngrs/install_pipx.sh
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
        if ! [[ -f $TOP/shell/aliases/.aliases.d/git.sh ]]; then
            source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/shell/aliases/.aliases.d/git.sh)
        else
            . $TOP/shell/aliases/.aliases.d/git.sh
        fi
        get-latest-releases-github 'https://github.com/dandavison/delta/releases' "$TMPDIR" 'git-delta_.*_amd64.deb' 
        sudo dpkg -i $TMPDIR/git-delta_*_amd64.deb 
    elif [[ $pager == "ydiff" ]]; then
        if ! hash pipx &> /dev/null; then 
            if ! [[ -f $TOP/cli-tools/pkgmngrs/install_pipx.sh ]]; then
                source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/pkgmngrs/install_pipx.sh)
            else
                . $TOP/cli-tools/pkgmngrs/install_pipx.sh
            fi
        fi
        pipx install ydiff
    fi
fi
