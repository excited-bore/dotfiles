hash less &> /dev/null && SYSTEM_UPDATED='TRUE'

if ! test -f ../checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ../checks/check_all.sh
fi


#if ! test -f install_xmllint.sh; then
#    source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_xmllint.sh)
#else
#    . ./install_xmllint.sh
#fi

# We at minimum need the 630 version for the '--no-vbell' option for people with epilepsy
if ! hash less &> /dev/null || (hash less &> /dev/null && version-higher '633' "$(command less -V | awk 'NR==1{print $2}')"); then
    if hash less &> /dev/null; then
        eval "$pac_rm_y less" 
    fi

    if [[ "$distro_base" == 'Debian' ]]; then   
    	if ! test -f pkgmngrs/install_ppa.sh; then
            source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/pkgmngrs/install_ppa.sh)
            
        else
            . pkgmngrs/install_ppa.sh
        fi
        
        eval "$pac_ins_y debhelper-compat devscripts build-essential fakeroot libncurses-dev" 

   	# from https://launchpad.net/ubuntu/+source/less 

   	tmpd=$(mktemp -d $TMPDIR/less-688-1-XXXXXX) 
   	(cd $tmpd
   	wget-aria-dir $tmpd https://launchpadlibrarian.net/786750047/less_668-1.dsc
   	wget-aria-dir $tmpd https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/less/668-1/less_668.orig.tar.gz
   	wget-aria-dir $tmpd https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/less/668-1/less_668.orig.tar.gz.asc
   	wget-aria-dir $tmpd https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/less/668-1/less_668-1.debian.tar.xz 
   	dpkg-source -x less_668-1.dsc 
   	cd less-668 
   	debuild -us -uc 
   	cd .. 
        if [[ "$arch" == '386' || "$arch" == 'amd32'  || "$arch" == 'amd64' ]]; then
            sudo dpkg -i less_668-1_amd64.deb 
        elif [[ "$arch" =~ 'arm' ]]; then 
            sudo dpkg -i less_668-1_$arch.deb
        fi
   	) 
   	#latest="$(curl -fsSL https://greenwoodsoftware.com/less/download.html | xmllint --html --xpath '//a' - | grep '.tar' | head -n 1 | cut -d\" -f-2 | cut -d\" -f2)"
   	#tdir=$(mktemp -d)
   	#wget-aria-dir $tdir/ https://greenwoodsoftware.com/less/$latest
   	#(cd $tdir
   	#tar xf $tdir/$latest
   	#latest=$(echo $latest | cut -d. -f1)
   	#cd $latest
   	#./configure
   	#make
   	#make check
   	#printf "Next ${RED}sudo${normal} will install ${CYAN}'less'${normal} in ${cyan}'/usr/local/bin'${normal}\n"
   	#sudo make install
   	#)
   	#readyn -p "Also install in ${CYAN}'/usr/bin'${GREEN}? (Since there's no less binary in /usr/bin, some programs might default to more instead..)" tousrbn
   	#if [[ "$tousrbn" == 'y' ]]; then
   	#    sudo cp /usr/local/bin/less /usr/bin
   	#fi
   	#unset latest tdir tousrbn 
    fi
fi
