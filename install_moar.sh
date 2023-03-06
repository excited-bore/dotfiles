. ./check_distro.sh
. ./install_go.sh

if [ $dist == "Arch" ]; then
    echo "Install using AUR helper (f.ex. yay install moar)"
    exit 1
elif [ $dist == "Manjaro" ]; then
    pamac install moar
    exit 1
elif [ $dist == "Raspbian" || $dist == "Debian" ]; then
    read -p "Apt doesn't have moar (as for now 06/03/2023). Install from binary (default) or quit [B/q]: " answer

    if [ -z $answer ] || [ "B" == $answer ] || [ "b" == $answer ]; then
        if [ $archit == "armv7l" ] || [ $archit == "arm64" ]; then
            archit="arm"
        fi
        if [ $archit == "amd64" ] || [ $archit == "amd32" ]; then
            archit="386"
        fi
        latest=$(curl -sL "https://github.com/walles/moar/tags" | grep "/walles/moar/releases/tag" | perl -pe 's|.*/walles/moar/releases/tag/(.*?)".*|\1|' | uniq | awk 'NR==1{max=$1;print $0; exit;}')                          
        (cd /tmp
        wget "https://github.com/walles/moar/releases/download/$latest/moar-$latest-linux-$archit"                                                                                      
        chmod a+x moar-*-*-*
        sudo mv moar-* /usr/local/bin/moar
        )
        echo "Done!"
        printf "\nDon't forget to put:\n     export MOAR='--statusbar=bold -colors 256'\n     export PAGER=/usr/local/bin/moar\n       export SYSTEMD_PAGER=$PAGER\nin your ~/.bashrc\n"

    fi

fi    
    #./setup_git_build_from_source.sh "y" "" "https://github.com" "neovim/neovim" "stable" "sudo apt update; sudo apt install ninja-build gettext libtool libtool-bin cmake g++ pkg-config unzip curl doxygen" "make CMAKE_BUILD_TYPE=RelWithDebInfo; sudo make install" "sudo make uninstall" "make distclean; make deps" "y"


