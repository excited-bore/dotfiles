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

if ! type unzip &>/dev/null; then
    eval "$pac_ins unzip"
fi

if ! type jq &>/dev/null; then
    eval "$pac_ins jq"
fi


fonts=$(mktemp -d)
get-latest-releases-github https://github.com/ryanoasis/nerd-fonts $fonts/
#wget-aria-dir "$fonts" https://github.com/vorillaz/devicons/archive/master.zip

if [[ "$(ls $fonts/*)" ]]; then

    if [[ "$(ls $fonts/*.zip &> /dev/null)" ]]; then
        name=$(basename $(command ls $fonts/) .zip)
        unzip $fonts/*.zip -d $fonts 
        rm $fonts/*.zip
    fi

    if [[ "$(ls $fonts/*.tar.xz 2> /dev/null)" ]]; then
        name=$(basename $(command ls $fonts/) .tar.xz) 
        tar -xf $fonts/*.tar.xz -C $fonts
        rm $fonts/*.tar.xz
    fi
    echo "$name" 

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
        files="$(find $HOME/.local/share/fonts -name "$name*NerdFont*")" 
        for i in $files; do 
            echo $i; 
            display $(echo "$i" | sed 's/.*[[:space:]]//g'); 
        done
    fi
fi

#if hash xfconf-query &> /dev/null; then 
    #family="$(fc-list --format="%{fullname}\t%{file}\n" | fzf --ansi --select-1 --multi --reverse --sync --delimiter '\t' --with-nth 1 --height 33% --preview='echo {2}' --preview-window='down,10%,follow')" 
    #xfconf-query -c xsettings -p /Gtk/FontName -s "$name 10"
#fi

unset fonts name files i yhno
