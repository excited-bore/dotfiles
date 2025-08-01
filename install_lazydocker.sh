if ! test -f checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ./checks/check_all.sh
fi

DIR=$(get-script-dir)


if ! hash lazydocker &>/dev/null; then
    if [[ $distro_base == "Arch" ]]; then
        if ! test -f $DIR/checks/check_AUR.sh; then
            source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_AUR.sh)
        else
            . $DIR/checks/check_AUR.sh
        fi
        eval "${AUR_ins_y}" lazydocker
    else
        if ! test -f $DIR/aliases/.bash_aliases.d/git.sh; then
            source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/git.sh)
        else
            . $DIR/aliases/.bash_aliases.d/git.sh
        fi
         
        if [[ "$arch" == 'amd32' ]]; then
            archl='x86' 
        elif [[ "$arch" == 'amd64' ]]; then
            archl='x86_64' 
        elif [[ "$arch" == 'arm32' ]]; then
            archl=$(lspcu | awk 'NR==1${print $2}') 
        elif [[ "$arch" == 'arm64' ]]; then
            archl='arm64' 
        fi
       
        get-latest-releases-github https://github.com/jesseduffield/lazydocker $TMPDIR lazydocker_.*_Linux_$archl.tar.gz   
        sudo tar xf $TMPDIR/lazydocker_*_Linux_$archl.tar.gz -C /usr/local/bin 
        sudo chmod 755 /usr/local/bin/lazydocker
        unset archl

        #minver=1.19
        #gover=0
        #hash go &> /dev/null && gover=$(go version | awk '{print $3}' | cut -c 3-)
        #if ! hash go &>/dev/null || (hash go &>/dev/null && awk "BEGIN {exit !($gover < $minver)}" ); then
        #    if ! test -f $DIR/install_go.sh; then
        #        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_go.sh)
        #    else
        #        . $DIR/install_go.sh
        #    fi
        #fi
        #go install github.com/jesseduffield/lazydocker@latest
        #unset minver gover 
    fi
    if hash lazydocker &>/dev/null; then
        lazydocker --version
    fi
fi
