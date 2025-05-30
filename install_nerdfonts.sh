hash jq &>/dev/null && hash unzip &>/dev/null && hash display &> /dev/null && hash ueberzug &> /dev/null &&
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

if ! [ -d $XDG_DATA_HOME/fonts ]; then
    mkdir $XDG_DATA_HOME/fonts
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
        name1="$name1$XDG_DATA_HOME/fonts/$(basename "$i")\n" 
    done 

    command mv $fonts/* $XDG_DATA_HOME/fonts
    sudo fc-cache -fv
fi

if test -n "$name"; then

    if ! hash display &> /dev/null || ! hash ueberzug &> /dev/null; then
        readyn -p "Install 'imagemagick' and 'ueberzug' to preview/show fonts?" yhno
        if [[ "$yhno" == 'y' ]]; then
            eval "$pac_ins imagemagick ueberzug"
        fi
    fi
    
    # get github.com/xlucn/fontpreview-ueberzug
    
    if (hash display &> /dev/null && hash ueberzug &> /dev/null); then
        curl -o $TMPDIR/fontpreview.sh https://raw.githubusercontent.com/xlucn/fontpreview-ueberzug/refs/heads/master/fontpreview-ueberzug
        sed -i 's/convert/magick/g' $TMPDIR/fontpreview.sh
        sed -i 's/fc-list -f/\tif [ -z "$FONTPREVIEW_FILES" ]; then\n\tfc-list -f/g' $TMPDIR/fontpreview.sh
        sed -i 's,wrap",wrap"\n\telse\n\t\t(cd $XDG_DATA_HOME/fonts/\n\t\ttest -n "$FONTPREVIEW_QUERY" \&\& quer="--query=$FONTPREVIEW_QUERY" || quer=""\n\t\tprintf "$FONTPREVIEW_FILES" | sort -t "-" -k1\,1 | uniq |\n\t\tfzf --header="Which font?" $quer --layout=reverse --preview "sh $0 {}" --preview-window "left:50%:noborder:wrap")\n\tfi,g' $TMPDIR/fontpreview.sh 
        chmod u+x $TMPDIR/fontpreview.sh   
    fi
  
    #while : ; do 
    #    if hash display &> /dev/null; then
    #        files=$(printf "$name" | sort  -t '-'  -k1,1 | uniq | fzf --header="Which fonts to preview?" --query='Regular' --multi --reverse --height 50%) 
    #        for i in $files; do 
    #            display $(echo "$XDG_DATA_HOME/fonts/$i" | sed 's/.*[[:space:]]//g'); 
    #        done
    #    fi
    #    readyn -p "Preview more fonts?" prvwmore
    #    if [[ "$prvwmore" == 'n' ]]; then
    #         break;
    #    fi
    #done
    #unset prvwmore
    
    unset FONTPREVIEW_FILES 

    if ( hash xfconf-query &> /dev/null || hash gsettings &> /dev/null || test -f $XDG_CONFIG_HOME/kitty/kitty.conf) ; then 
        if [[ "$DESKTOP_SESSION" == 'xfce' ]]; then 
            readyn -p "Set one installed font as the default for the entire system - for ${CYAN}xfce${GREEN}?" yhno
            if [[ "$yhno" == 'y' ]]; then
               
                quer="--query=Regular" 
                #if [[ $(echo "$files" | wc -w) == 1 ]]; then
                #    quer="--query=$files" 
                #fi
                ! (hash display &> /dev/null && hash ueberzug &> /dev/null) && 
                    file=$(printf "$name" | sort  -t '-'  -k1,1 | uniq | fzf --header="Which font?" $quer --reverse --height 50%) ||
                    file=$(FONTPREVIEW_FILES="$name" $TMPDIR/fontpreview.sh) 
                style=$(echo $file | cut -d. -f-1 | cut -d- -f2) 
                familystyle=$(fc-query "$XDG_DATA_HOME/fonts/$file" --format "%{family} %{style}\n" | uniq) 
                reade -Q 'GREEN' -i "10 $(seq 1 48)" -p "Default fontsize (Default 10): " size 
                re='^[0-9]+$'
                if ! [[ $size =~ $re ]] ; then
                    echo "${RED}$size${normal} is not a number!" 
                else
                    xfconf-query -c xsettings -p /Gtk/FontName -s "$familystyle $size"
                fi
            fi
        elif [[ "$DESKTOP_SESSION" == 'gnome' ]]; then 
            readyn -p "Set one installed font as the default for the entire system - for ${CYAN}GNOME${GREEN}?" yhno
            if [[ "$yhno" == 'y' ]]; then
               
                quer="--query=Regular" 
                #if [[ $(echo "$files" | wc -w) == 1 ]]; then
                #    quer="--query=$files" 
                #fi
                ! (hash display &> /dev/null && hash ueberzug &> /dev/null) && 
                    file=$(printf "$name" | sort  -t '-'  -k1,1 | uniq | fzf --header="Which font?" $quer --reverse --height 50%) ||
                    file=$(FONTPREVIEW_FILES="$name" $TMPDIR/fontpreview.sh) 
                style=$(echo $file | cut -d. -f-1 | cut -d- -f2) 
                familystyle=$(fc-query "$XDG_DATA_HOME/fonts/$file" --format "%{family} %{style}\n" | uniq) 
                reade -Q 'GREEN' -i "10 $(seq 1 48)" -p "Default fontsize (Default 10): " size 
                re='^[0-9]+$'
                if ! [[ $size =~ $re ]] ; then
                    echo "${RED}$size${normal} is not a number!" 
                else
                    gsettings set org.gnome.desktop.interface font-name "$familystyle $size" 
                    gsettings set org.gnome.desktop.wm.preferences titlebar-font "$familystyle $size"
                    readyn -p "Set as default font when using document editors (for example librewriter)" yhno
                    if [[ "$yhno" == 'y' ]]; then
                        gsettings set org.gnome.desktop.interface document-font-name "$familystyle $size" 
                    fi 
                    if ! [[ "$familystyle" =~ 'Mono' ]]; then
                        printf "Font is ${RED}not${normal} from family ${CYAN}'Mono/Monospace'${cyan} (type of font where each character occupies the same amount of horizontal space)${normal}\nIf set as the default for terminals text might look ugly / out of place\n"
                        readyn -n -p "Set as default font for terminals anyway?" yhno 
                        if [[ "$yhno" == 'y' ]]; then
                            gsettings set org.gnome.desktop.interface monospace-font-name "$familystyle $size"
                        elif [[ "$yhno" == 'n' ]] && [[ "$name" =~ "Mono" ]]; then
                            readyn -p "Rechose a font from the family 'Mono/Monospace'?" yhno
                            if [[ "$yhno" == 'y' ]]; then 
                                quer="--query=Mono" 
                                file=$(printf "$name" | sort  -t '-'  -k1,1 | uniq | fzf --header="Which font?" $quer --reverse --height 50%) 
                                if ! [[ "$file" =~ "Mono" ]]; then
                                    echo "Chosen family of fonts not 'Mono/Monospace'. Moving on.." 
                                else
                                    style=$(echo $file | cut -d. -f-1 | cut -d- -f2) 
                                    familystyle=$(fc-query "$XDG_DATA_HOME/fonts/$file" --format "%{family} %{style}\n" | uniq) 
                                    reade -Q 'GREEN' -i "10 $(seq 1 48)" -p "Default fontsize (Default 10): " size 
                                    re='^[0-9]+$'
                                    if ! [[ $size =~ $re ]] ; then
                                        echo "${RED}$size${normal} is not a number!" 
                                    else
                                        gsettings set org.gnome.desktop.interface monospace-font-name "$familystyle $size"
                                    fi
                                fi
                            fi 
                        fi
                    else
                        gsettings set org.gnome.desktop.interface monospace-font-name "$familystyle $size"
                    fi
                fi
            fi
        fi 


        if test -f $XDG_CONFIG_HOME/kitty/kitty.conf; then
            readyn -p "Set one installed font as the default for the ${CYAN}kitty terminal emulator${GREEN}?" yhno
            if [[ "$yhno" == 'y' ]]; then
                if [[ -n "$file" ]]; then 
                    quer="--query=$file" 
                #elif [[ $(echo "$files" | wc -w) == 1 ]]; then
                #    quer="--query=$files" 
                fi
                ! (hash display &> /dev/null && hash ueberzug &> /dev/null) && 
                    file=$(printf "$name" | sort  -t '-'  -k1,1 | uniq | fzf --header="Which font?" $quer --reverse --height 50%) ||
                    file=$(FONTPREVIEW_QUERY="$file" FONTPREVIEW_FILES="$name" $TMPDIR/fontpreview.sh) 
                style=$(echo $file | cut -d. -f-1 | cut -d- -f2) 
                familystyle=$(fc-query "$XDG_DATA_HOME/fonts/$file" --format "%{family} %{style}\n" | uniq) 
                reade -Q 'GREEN' -i "10 $(seq 1 48)" -p "Default fontsize (Default 10): " size 
                re='^[0-9]+$'
                if ! [[ $size =~ $re ]] ; then
                    echo "${RED}$size${normal} is not a number!" 
                else
                    sed -i "s/font_family.*/font_family\t$familystyle/g" $XDG_CONFIG_HOME/kitty/kitty.conf
                    sed -i "s/font_size.*/font_size\t$size/g" $XDG_CONFIG_HOME/kitty/kitty.conf
                fi
            fi 
        fi
    fi
fi

unset fonts style name name1 file files i yhno size tar_zip quer familystyle
