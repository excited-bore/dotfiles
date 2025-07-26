if ! test -f checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ./checks/check_all.sh
fi

if [[ "$distro_base" == 'Debian' ]]; then
    if ! hash makedeb &> /dev/null; then
	if ! test -f install_makedeb.sh; then
	    source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_makedeb.sh)
	else
	    ./install_makedeb.sh
	fi
    fi
    tmpd=$(mktemp -d)
    eval "${pac_ins_y} freeglut3-dev libxcb-image0-dev libwayland-dev"
    git clone 'https://mpr.makedeb.org/ueberzugpp' $tmpd
    (cd $tmpd/
    if ! grep -q "DENABLE_OPENCV=OFF" PKGBUILD; then
        sed -i 's/\(-DENABLE_OPENGL=ON \\\)/\1\n\t-DENABLE_OPENCV=OFF \\/' PKGBUILD
    fi
    makedeb -si)
fi
