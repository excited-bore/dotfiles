# https://www.makedeb.org/

(hash makedeb &> /dev/null || ! [[ "$distro_base" == 'Debian' ]]) && SYSTEM_UPDATED='TRUE'

TOP=$(git rev-parse --show-toplevel)

if ! test -f $TOP/checks/check_all.sh; then
    if hash curl &> /dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . $TOP/checks/check_all.sh
fi

if ! hash makedeb &> /dev/null; then
    bash -ci "$(wget-curl 'https://shlink.makedeb.org/install')"
    # Arm support is broken? Even after building manually on latest alpha, neovim makedeb still throws errors being confused by -march=x86_64??
  
    #if ! hash just &> /dev/null; then
    #    if ! test -f $SCRIPT_DIR/install_just.sh; then
    #        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/install_just.sh)
    #    else
    #        . $SCRIPT_DIR/install_just.sh
    #    fi
    #fi
    
    #tmpd=$(mktemp -d) 
    #git clone 'https://github.com/makedeb/makedeb' $tmpd
    #(cd $tmpd
    #git config variable advice.detachedHead false 
    
    # Set to commit hash for version v16.0.0 
    # git checkout dc8ad0d 
    # Nope.. arm still is not supported
    # Set it to this alpha commit ig
    
    #git checkout 2653879
    #source <(TARGET=apt RELEASE=alpha PKGBUILD/pkgbuild.sh)    
    #eval "$pac_ins_y ${makedepends[@]} ${depends[@]} libapt-pkg-dev"
    
    #make prepare PKGVER="16.0.0" RELEASE="stable" TARGET="apt" CURRENT_VERSION="0"
    #sudo make package TARGET="apt"
     
    #VERSION='16.0.0' RELEASE='alpha' TARGET='apt' BUILD_COMMIT='2653879' just prepare
    #DPKG_ARCHITECTURE=$(dpkg --print-architecture) just build
    #sudo DESTDIR='/usr/local/bin' just package
    #)
fi

# Nevermind, apparently it's a configuration file error
# https://github.com/makedeb/makedeb/issues/263 
#TODO: revisit different armv*number* versions

if [[ "$arch" == 'arm32' ]]; then
    sudo sed -i 's/CARCH=".*"/CARCH="armhf"/ s/CHOST=".*"/CHOST="armv6l-unknown-linux-gnueabihf"/; s/-march=x86-64 -mtune=generic -O2 -pipe/-march=armv6 -mfloat-abi=hard -mfpu=vfp -O2 -pipe -fstack-protector-strong/; s/-fcf-protection//' /etc/makepkg.conf 

elif [[ "$arch" == 'arm64' ]]; then 
    sudo sed -i 's/CARCH=".*"/CARCH="arm64"/; s/CHOST=".*"/CHOST="aarch64-unknown-linux-gnu"/; s/-march=x86-64 -mtune=generic -O2 -pipe/-march=armv8-a -O2 -pipe -fstack-protector-strong/; s/-fcf-protection//' /etc/makepkg.conf 
fi


if ! test -f $TOP/checks/check_completions_dir.sh; then
    source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/checks/check_completions_dir.sh)
else
    . $TOP/checks/check_completions_dir.sh
fi

wget-curl https://raw.githubusercontent.com/makedeb/makedeb/refs/heads/alpha/completions/makedeb.bash > $HOME/.bash_completion.d/makedeb.bash
