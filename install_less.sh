if ! test -f checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ./checks/check_all.sh
fi

if ! test -f install_xmllint.sh; then
    source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_xmllint.sh)
else
    . ./install_xmllint.sh
fi



# We at minimum need the 630 version for the '--no-vbell' option for people with epilepsy
if ! hash less &> /dev/null || (hash less &> /dev/null && version-higher '633' "$(command less -V | awk 'NR==1{print $2}')"); then
    if hash less &> /dev/null; then
        eval "$pac_rm_y less" 
    fi
    latest="$(curl -fsSL https://greenwoodsoftware.com/less/download.html | xmllint --html --xpath '//a' - | grep '.tar' | head -n 1 | cut -d\" -f-2 | cut -d\" -f2)"
    tdir=$(mktemp -d)
    wget-aria-dir $tdir/ https://greenwoodsoftware.com/less/$latest
    (cd $tdir
    tar xf $tdir/$latest
    latest=$(echo $latest | cut -d. -f1)
    cd $latest
    ./configure
    make
    make check
    printf "Next ${RED}sudo${normal} will install ${CYAN}'less'${normal} in ${cyan}'/usr/local/bin'${normal}\n"
    sudo make install
    )
    readyn -p "Also install in ${CYAN}'/usr/bin'${GREEN}? (Since there's no less binary in /usr/bin, some programs might default to more instead..)" tousrbn
    if [[ "$tousrbn" == 'y' ]]; then
        sudo cp /usr/local/bin/less /usr/bin
    fi
    unset latest tdir tousrbn 
fi
