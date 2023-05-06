 #DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. ./checks/check_distro.sh

answer=""
if [ ! -x "$(command -v moar)" ]; then
    
    if [ $distro == "Manjaro" ]; then
        
        reade -Q "GREEN" -i "y" -p "Install moar from packagemanager (y), github binary (b) or not (anything but empty, y or b) [Y/b/n]: " "y b n"  answer
        if [ "$answer" == "y" ] || [ -z "$answer" ] || [ "$answer" == "Y" ]; then
            yes | pamac update;
            yes | pamac install moar;
        fi
    
    elif [ $distro == "Arch" ] && [ -x "$(command -v yay)" ]; then
        
        reade -Q "GREEN" -i "y" -p "Install moar from packagemanager (y), github binary (b) or not (anything but empty, y or b) [Y/b/n]: " "y b n"  answer
        if [ "$answer" == "y" ] || [ -z "$answer" ] || [ "$answer" == "Y" ]; then
            yes | yay -Su moar-git;
        fi
    
    else
        
        printf "Package manager unknown or PM doesn't offer moar (f.ex. apt).\n"; 
        reade -Q "YELLOW" -i "b" -p "Install moar from github binary (b) or not (anything but empty or b) [B/n]: " "b n"  answer
        if [ -z "$answer" ] || [ "B" == "$answer" ] || [ "b" == "$answer" ]; then
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
    fi
fi


    #./setup_git_build_from_source.sh "y" "" "https://github.com" "neovim/neovim" "stable" "sudo apt update; sudo apt install ninja-build gettext libtool libtool-bin cmake g++ pkg-config unzip curl doxygen" "make CMAKE_BUILD_TYPE=RelWithDebInfo; sudo make install" "sudo make uninstall" "make distclean; make deps" "y"


