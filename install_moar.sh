 #DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. ./checks/check_distro.sh

if [ $distro == "Manjaro" ]; then
    yes | pamac update
    yes | pamac install moar
else
    read -p "Install moar from binary (default) or quit [Y/n]: " answer

    if [ -z $answer ] || [ "Y" == $answer ] || [ "y" == $answer ]; then
        if [ $architecture == "armv7l" ] || [ $architecture == "arm64" ]; then
            architecture="arm"
        fi
        if [ $architecture == "amd64" ] || [ $architecture == "amd32" ]; then
            architecture="386"
        fi
        latest=$(curl -sL "https://github.com/walles/moar/tags" | grep "/walles/moar/releases/tag" | perl -pe 's|.*/walles/moar/releases/tag/(.*?)".*|\1|' | uniq | awk 'NR==1{max=$1;print $0; exit;}')                          
        (cd /tmp
        wget "https://github.com/walles/moar/releases/download/$latest/moar-$latest-linux-$architecture"
        chmod a+x moar-*-*-*
        sudo mv moar-* /usr/local/bin/moar
        )
        echo "Done!"

    fi
    printf "\nDon't forget to put:\n     export MOAR='--statusbar=bold -colors 256'\n     export PAGER=/usr/local/bin/moar\n       export SYSTEMD_PAGER=$PAGER\nin your ~/.bashrc or .bash_aliases.d/pathvariables.sh\n"
fi
    #./setup_git_build_from_source.sh "y" "" "https://github.com" "neovim/neovim" "stable" "sudo apt update; sudo apt install ninja-build gettext libtool libtool-bin cmake g++ pkg-config unzip curl doxygen" "make CMAKE_BUILD_TYPE=RelWithDebInfo; sudo make install" "sudo make uninstall" "make distclean; make deps" "y"


