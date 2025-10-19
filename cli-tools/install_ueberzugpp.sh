# https://github.com/jstkdng/ueberzugpp

hash ueberzugpp &> /dev/null && SYSTEM_UPDATED='TRUE'

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

if [[ "$distro_base" == 'Arch' ]] && hash ueberzug &> /dev/null; then
   eval "$pac_rm_y ueberzug" 
fi

if [[ "$distro_base" == 'Debian' ]]; then
    if ! hash makedeb &> /dev/null; then
        if ! test -f $TOP/cli-tools/pkgmngrs/install_makedeb.sh; then
            source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/pkgmngrs/install_makedeb.sh)
        else
           . $TOP/cli-tools/pkgmngrs/install_makedeb.sh
        fi
    fi
    tmpd=$(mktemp -d)
    eval "${pac_ins_y} git freeglut3-dev libxcb-image0-dev libwayland-dev"
    git clone 'https://mpr.makedeb.org/ueberzugpp' $tmpd
    (cd $tmpd/
    if ! grep -q "DENABLE_OPENCV=OFF" PKGBUILD; then
        sed -i 's/\(-DENABLE_OPENGL=ON \\\)/\1\n\t-DENABLE_OPENCV=OFF \\/' PKGBUILD
    fi
    makedeb -si)
else
    eval "${pac_ins_y} ueberzugpp"
fi
