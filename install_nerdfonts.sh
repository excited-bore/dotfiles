DLSCRIPT=1

hash jq &>/dev/null && hash unzip &>/dev/null &&
    SYSTEM_UPDATED='TRUE'

if ! test -f checks/check_all.sh; then
    if type curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        printf "If not downloading/git cloning the scriptfolder, you should at least install 'curl' beforehand when expecting any sort of succesfull result...\n"
        return 1 || exit 1
    fi
else
    . ./checks/check_all.sh
fi

if ! test -f aliases/.bash_aliases.d/git.sh; then
    source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/git.sh)
else
    . ./aliases/.bash_aliases.d/git.sh
fi

if ! [ -d ~/.local/share/fonts ]; then
    mkdir ~/.local/share/fonts
fi

if ! type jq &>/dev/null; then
    eval "$pac_ins jq"
fi


reade -Q 'GREEN' -i 'tar zip' -p "Would you like the script to get '.zip' files or '.tar.xz' files (need to install 'unzip' for '.zip' files if it's not already installed) [Tar/zip]: " tar_zip

if [[ "$tar_zip" == 'zip' ]]; then 
    tar_zip='.zip' 
    if ! type unzip &>/dev/null; then
        eval "$pac_ins unzip"
    fi
else
    tar_zip='.tar.xz'
fi

fonts=$(mktemp -d)
get-latest-releases-github https://github.com/ryanoasis/nerd-fonts $fonts/ "$tar_zip"

if [[ "$(ls $fonts/* 2> /dev/null)" ]]; then

    if [[ "$(ls $fonts/*.zip 2> /dev/null)" ]]; then
        for i in $(command ls $fonts/*.zip); do
            unzip $i -d $fonts 
        done
        rm $fonts/*.zip
    fi

    if [[ "$(ls $fonts/*.tar.xz 2> /dev/null)" ]]; then
        for i in $(command ls $fonts/*.tar.xz); do
            tar -xf $i -C $fonts
        done
        rm $fonts/*.tar.xz
    fi
    for i in $(command ls $fonts/*tf); do 
        name="$name$(basename "$i")\n"; 
    done 

    mv $fonts/* ~/.local/share/fonts
    sudo fc-cache -fv
fi

if test -n "$name"; then

    if ! hash display &> /dev/null; then
        readyn -p "Install 'ImageMagick' to preview/show fonts?" yhno
        if [[ "$yhno" == 'y' ]]; then
            eval "$pac_ins ImageMagick"
        fi
    fi

    if hash display &> /dev/null; then
        files=$(printf "$name" | sort  -t '-'  -k1,1 | uniq | fzf --header="Which fonts to preview?" --query='Regular' --multi --reverse --height 50%) 
        for i in $files; do 
            display $(echo "$HOME/.local/share/fonts/$i" | sed 's/.*[[:space:]]//g'); 
        done
    fi

    if hash xfconf-query &> /dev/null; then 
        unset yhno 
        readyn -p 'Set one as default font for the entire system?' yhno
        if [[ "$yhno" == 'y' ]]; then
           
            quer="--query=Regular" 
            if [[ $(echo "$files" | wc -w) == 1 ]]; then
                quer="--query=$files" 
            fi
            file=$(printf "$name" | sort  -t '-'  -k1,1 | uniq | fzf --header="Which font?" $quer --reverse --height 50%) 
            style=$(basename $file .ttf | cut -d- -f2) 
            name=$(fc-list $file:style=$style --format "%{family} %{style}") 
            reade -Q 'GREEN' -i "10 $(seq 1 48)" -p "Default fontsize (Default 10): " size 
            re='^[0-9]+$'
            if ! [[ $size =~ $re ]] ; then
                echo "${RED}$size${normal} is not a number!" 
            else
                xfconf-query -c xsettings -p /Gtk/FontName -s "$name $size"
            fi
        fi
    fi
fi

unset fonts style name file files i yhno size tar_zip quer
