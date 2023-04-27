 DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. $DIR/check_distro.sh

if [[ $dist == "Manjaro" || $dist == "Arch" ]];then
    sudo pacman -Su flatpak xorg-xrdb libpamac-flatpak-plugin snap xclip sshfs reptyr gdb neovim mono go nodejs jre11-openjdk npm python ranger atool bat calibre elinks ffmpegthumbnailer fontforge highlight imagemagick kitty mupdf-tools odt2txt bottom
elif [[ $dist == "Debian" || $dist == "Raspbian" ]];then
    sudo apt install xclip gdb sshfs reptyr build-essential python2 python3 sshfs cmake python3-dev python3-pip mono-complete golang nodejs openjdk-17-jdk openjdk-17-jre npm ranger atool bat elinks ffmpegthumbnailer fontforge highlight imagemagick jq kitty libcaca0 odt2txt mupdf-tools 
fi 

