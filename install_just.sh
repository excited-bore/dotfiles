# https://github.com/casey/just

if ! test -f checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ./checks/check_all.sh
fi

if ! hash just &> /dev/null; then
    if ! hash cargo &> /dev/null; then
        if ! test -f install_cargo.sh; then
            source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_cargo.sh)
        else 
            . ./install_cargo.sh
        fi
    fi
    
    cargo install just 
    
    if ! [[ $? == 0 ]] || ! hash cargo &> /dev/null; then
        if ! test -f aliases/.bash_aliases.d/git.sh; then
            source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/git.sh)
        else 
            . aliases/.bash_aliases.d/git.sh
        fi
     
        if [[ "$arch" == '386' || "$arch" == 'amd32' || "$arch" == 'amd64' ]]; then
            archj='x86_64-unknown-linux-musl'
        elif [[ "$arch" == 'arm64' ]]; then  
            archj='aarch64-unknown-linux-musl' 
        elif [[ "$arch" == 'armv7' ]]; then  
            archj='armv7-unknown-linux-musleabihf' 
        elif [[ "$arch" =~ arm ]]; then  
            archj='arm-unknown-linux-musleabihf' 
        fi
        tmpd=$(mktemp -d) 
        get-latest-releases-github https://github.com/casey/just $tmpd $archj 
        sudo tar -xf $tmpd/just-*-$archj.tar.gz -C /usr/local/bin    
        sudo chmod 755 /usr/local/bin/just 
    fi
fi
