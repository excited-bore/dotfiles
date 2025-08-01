# https://www.makedeb.org/

if ! test -f checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ./checks/check_all.sh
fi

SCRIPT_DIR=$(get-script-dir)

if ! hash makedeb &> /dev/null; then
    # These instructions don't seem to work for arm architectures
    # bash -ci "$(wget -qO - 'https://shlink.makedeb.org/install')"
    # just building it seems more reliable
    
    #if ! hash just &> /dev/null; then
    #    if ! test -f $SCRIPT_DIR/install_just.sh; then
    #        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/install_just.sh)
    #    else
    #        . $SCRIPT_DIR/install_just.sh
    #    fi
    #fi
    tmpd=$(mktemp -d) 
    git clone 'https://github.com/makedeb/makedeb' $tmpd
    (cd $tmpd
    # Set to commit hash for version v16.0.0 
    git checkout dc8ad0d 
    source <(TARGET=apt RELEASE=alpha PKGBUILD/pkgbuild.sh)    
    eval "$pac_ins_y ${makedepends[@]} ${depends[@]}"
    make prepare PKGVER="16.0.0" RELEASE="stable" TARGET="apt" CURRENT_VERSION="0"
    sudo make package TARGET="apt"
     
    #VERSION='16.0.0' RELEASE='alpha' TARGET='mpr' BUILD_COMMIT='2653879' just prepare
    #DPKG_ARCHITECTURE=$(dpkg --print-architecture) just build
    #DESTDIR='/usr/local/bin' just package
    )
fi

if ! test -f $SCRIPT_DIR/checks/check_aliases_dir.sh; then
    source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/checks/check_aliases_dir.sh)
else
    . $SCRIPT_DIR/checks/check_aliases_dir.sh
fi

wget-curl https://raw.githubusercontent.com/makedeb/makedeb/refs/heads/alpha/completions/makedeb.bash > $HOME/.bash_aliases.d/makedeb.bash
