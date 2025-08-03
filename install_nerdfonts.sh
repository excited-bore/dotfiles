[[ "$XDG_SESSION_TYPE" == 'x11' ]] && hash jq &>/dev/null && hash unzip &>/dev/null && hash fzf &>/dev/null && hash magick &> /dev/null && hash ueberzugpp &> /dev/null &&
    SYSTEM_UPDATED='TRUE'
[[ "$XDG_SESSION_TYPE" == 'wayland' ]] && hash jq &>/dev/null && hash unzip &>/dev/null && hash fzf &>/dev/null && hash magick &> /dev/null && hash nsxiv &> /dev/null && 
    SYSTEM_UPDATED='TRUE'


if ! test -f checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ./checks/check_all.sh
fi

if ! test -f aliases/.bash_aliases.d/git.sh; then
    source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/git.sh)
else
    . ./aliases/.bash_aliases.d/git.sh
fi

if ! [ -d $XDG_DATA_HOME/fonts ]; then
    mkdir $XDG_DATA_HOME/fonts
fi

if ! hash fzf &> /dev/null; then
    if ! test -f install_fzf.sh; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_fzf.sh 'simple')
    else
        . ./install_fzf.sh 'simple'
    fi
fi

if ! hash jq &>/dev/null; then
    eval "$pac_ins_y jq"
fi

reade -Q 'GREEN' -i 'tar zip' -p "Would you like the script to get '.zip' files or '.tar.xz' files (need to install 'unzip' for '.zip' files if it's not already installed) [Tar/zip]: " tar_zip

if [[ "$tar_zip" == 'zip' ]]; then 
    tar_zip='.zip' 
    if ! hash unzip &>/dev/null; then
        eval "$pac_ins_y unzip"
    fi
else
    tar_zip='.tar.xz'
fi

fonts=$(mktemp -d)
get-latest-releases-github https://github.com/ryanoasis/nerd-fonts $fonts/ "$tar_zip"

if [[ "$(command ls $fonts/* 2> /dev/null)" ]]; then

    if [[ "$tar_zip" == 'zip' ]]; then
        for i in $(command ls $fonts/*.zip); do
            unzip $i -d $fonts 
        done
        rm $fonts/*.zip
    
    elif [[ "$tar_zip" == '.tar.xz' ]]; then
        for i in $(command ls $fonts/*.tar.xz); do
            tar -xf $i -C $fonts
        done
        rm $fonts/*.tar.xz
    fi
    for i in $(command ls $fonts/*tf); do 
        name="$name$(basename "$i")\n"; 
        name1="$name1$XDG_DATA_HOME/fonts/$(basename "$i")\n" 
    done 

    echo $name 
    command mv $fonts/* $XDG_DATA_HOME/fonts
    sudo fc-cache -fv
fi

if test -n "$name"; then
    if ! hash magick &> /dev/null; then 
        if [[ "$distro_base" == 'Debian' ]]; then
            readyn -p "${GREEN}Latest version of ${CYAN}imagemagick${GREEN} not installed.\n${YELLOW}Warning - installing latest version could take a while\n${GREEN}Install ${CYAN}imagemagick${GREEN}?" nstll_mgmagick 
        else
            nstll_mgmagick='y'
        fi
        if [[ "$nstll_mgmagick" == 'y' ]]; then 
            if ! test -f install_imagemagick.sh; then
                source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_imagemagick.sh)
            else
                . ./install_imagemagick.sh 
            fi
        fi
        unset nstll_mgmagick
    fi
    
    if [[ "$XDG_SESSION_TYPE" == 'x11' ]]; then
        if ! hash magick &> /dev/null || ! hash ueberzugpp &> /dev/null; then
            readyn -p "Install 'imagemagick' and 'ueberzugpp' to preview/show fonts?" yhno
            if [[ "$yhno" == 'y' ]]; then
                if ! hash ueberzugpp &> /dev/null; then
                    if ! test -f install_ueberzugpp.sh; then
                        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_ueberzugpp.sh)
                    else
                        . ./install_ueberzugpp.sh
                    fi
                fi
            fi
            unset yhno
        fi
        # get github.com/xlucn/fontpreview-ueberzug
        
        if hash magick &> /dev/null && hash ueberzugpp &> /dev/null; then
            wget-aria-name $TMPDIR/fontpreview.sh https://raw.githubusercontent.com/xlucn/fontpreview-ueberzug/refs/heads/master/fontpreview-ueberzug 
            if hash magick &> /dev/null; then
                sed -i 's/convert/magick/g' $TMPDIR/fontpreview.sh
            fi
            sed -i 's/fc-list -f/\tif [ -z "$FONTPREVIEW_FONTS" ]; then\n\tfc-list -f/g' $TMPDIR/fontpreview.sh
            sed -i 's,wrap",wrap"\n\telse\n\t(cd $XDG_DATA_HOME/fonts/\n\t\ttest -n "$FONTPREVIEW_QUERY" \&\& quer="--query=$FONTPREVIEW_QUERY" || quer=""\n\tprintf "$FONTPREVIEW_FONTS" | sort -t "-" -k1\,1 | uniq |\n\tfzf --header="Which font?" $quer --layout=reverse --preview "sh $0 {}" --preview-window "left:50%:noborder:wrap")\n\tfi,g' $TMPDIR/fontpreview.sh 
            chmod u+x $TMPDIR/fontpreview.sh   
        fi
        
    elif [[ "$XDG_SESSION_TYPE" == 'wayland' ]]; then

        if ! hash nsxiv &> /dev/null; then
            eval "$pac_ins_y nsxiv" 
        fi
       
        if hash magick &> /dev/null && hash nsxiv &> /dev/null; then
         
            wget-curl https://git.io/raw_fontpreview > $TMPDIR/fontpreview.sh
            #if [[ "$XDG_CURRENT_DESKTOP" == 'GNOME' ]]; then
            sed -i 's/xdotool, //; s/(xdotool\ /(\ /; /xdotool/d;' $TMPDIR/fontpreview.sh
            sed -i 's/\(fontpreview very customizable\)/\1\n\t\[\[ $FONTPREVIEW_FONTS != "" \]\] \&\& FONTS=$FONTPREVIEW_FONTS/' $TMPDIR/fontpreview.sh
            sed -i 's/\(--search-prompt)\)/\t--fonts)\n\tFONTPREVIEW_FONTS=$2\n\t;;\n\t\1/' $TMPDIR/fontpreview.sh 
            sed -i 's/\(search-prompt:,)\)/fonts:,\1/' $TMPDIR/fontpreview.sh 
            sed -i 's|\(font=$(magick -list font.*)\)|\tif test -z "$FONTPREVIEW_FONTS"; then\n\t\1\n\telse\n\tfont=$(printf "$FONTPREVIEW_FONTS" \| sort -t "-" -k1\,1 \| uniq \| fzf --header="Which font? (Ctrl+C to quit - last selected will be used)" $quer --layout=reverse --prompt="$SEARCH_PROMPT")\n\techo "$font"\n\tfi\n|' $TMPDIR/fontpreview.sh
            #sed -i 's|\[\[ -z $font \]\].*|if test -z $font; then\n\treturn\n\telse\n\tstyle=$(echo $font \| cut -d- -f2 \| cut -d. -f1)\n\tfont=$(fc-match $font \| awk '\''{$1=""; print}'\'' \| xargs \| sed "s/Regular/$style/; s/ /-/g; s/-Regular//g")\n\tfi|' $TMPDIR/fontpreview.sh 
            sed -i 's|\[\[ -z $font \]\].*|if test -z $font; then\n\treturn\n\telse\n\ttest -n "$FONTPREVIEW_FONTS" \&\& font=$(fc-query -f "%{fullname}\\n" $XDG_DATA_HOME/fonts/$font \| sed "s/ /-/g;")\n\tfi|' $TMPDIR/fontpreview.sh 
             
            sed -i 's/^main$/echo $(main | awk '\''{print $NF}'\'')/' $TMPDIR/fontpreview.sh 
            chmod u+x $TMPDIR/fontpreview.sh
        fi 
    fi
    
    #while : ; do 
    #    if hash magick &> /dev/null; then
    #        files=$(printf "$name" | sort  -t '-'  -k1,1 | uniq | fzf --header="Which fonts to preview?" --query='Regular' --multi --reverse --height 50%) 
    #        for i in $files; do 
    #            magick $(echo "$XDG_DATA_HOME/fonts/$i" | sed 's/.*[[:space:]]//g'); 
    #        done
    #    fi
    #    readyn -p "Preview more fonts?" prvwmore
    #    if [[ "$prvwmore" == 'n' ]]; then
    #         break;
    #    fi
    #done
    #unset prvwmore
    
    unset FONTPREVIEW_FONTS 

    if ( hash xfconf-query &> /dev/null || hash gsettings &> /dev/null || test -f $XDG_CONFIG_HOME/kitty/kitty.conf) ; then 
        if [[ "$XDG_CURRENT_DESKTOP" == 'XFCE' ]]; then 
            readyn -p "Set one installed font as the default for the entire system - for ${CYAN}xfce${GREEN}?" yhno
            if [[ "$yhno" == 'y' ]]; then
               
                quer="--query=Regular" 
                #if [[ $(echo "$files" | wc -w) == 1 ]]; then
                #    quer="--query=$files" 
                #fi
                (! hash magick &> /dev/null || ! (hash ueberzug &> /dev/null || hash ueberzugpp &> /dev/null)) && 
                    file=$(printf "$name" | sort  -t '-'  -k1,1 | uniq | fzf --header="Which font?" $quer --reverse --height 50%) ||
                    file=$(FONTPREVIEW_FONTS="$name" quer="$quer" $TMPDIR/fontpreview.sh) 
                style=$(echo $file | cut -d. -f-1 | cut -d- -f2) 
                familystyle=$(fc-query "$XDG_DATA_HOME/fonts/$file" --format "%{family} %{style}\n" | uniq) 
                reade -Q 'GREEN' -i "10 $(seq 1 48 | tr '\n' ' ')" -p "Default fontsize (Default 10): " size 
                re='^[0-9]+$'
                if ! [[ $size =~ $re ]] ; then
                    echo "${RED}$size${normal} is not a number!" 
                else
                    xfconf-query -c xsettings -p /Gtk/FontName -s "$familystyle $size"
                fi
            fi
        elif [[ "$XDG_CURRENT_DESKTOP" =~ 'GNOME' ]]; then 
            readyn -p "Set one installed font as the default for the entire system - for ${CYAN}GNOME${GREEN}?" yhno
            if [[ "$yhno" == 'y' ]]; then
               
                quer="--query=Regular" 
                #if [[ $(echo "$files" | wc -w) == 1 ]]; then
                #    quer="--query=$files" 
                #fi
                (! hash magick &> /dev/null || ! (hash ueberzug &> /dev/null || hash ueberzugpp &> /dev/null)) && 
                    file=$(printf "$name" | sort  -t '-'  -k1,1 | uniq | fzf --header="Which font?" $quer --reverse --height 50%) ||
                    file=$(FONTPREVIEW_FONTS="$name" $TMPDIR/fontpreview.sh) 
                style=$(echo $file | cut -d. -f-1 | cut -d- -f2) 
                familystyle=$(fc-query "$XDG_DATA_HOME/fonts/$file" --format "%{family} %{style}\n" | uniq) 
                reade -Q 'GREEN' -i "10 $(seq 1 48 | tr '\n' ' ')" -p "Default fontsize (Default 10): " size 
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
                                    reade -Q 'GREEN' -i "10 $(seq 1 48 | tr '\n' ' ')" -p "Default fontsize (Default 10): " size 
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
                if [ -n "$file" ]; then 
                    quer="--query=$file" 
                #elif [[ $(echo "$files" | wc -w) == 1 ]]; then
                #    quer="--query=$files" 
                fi
                (! hash magick &> /dev/null || ! (hash ueberzug &> /dev/null || hash ueberzugpp &> /dev/null)) &&
                    file=$(printf "$name" | sort  -t '-'  -k1,1 | uniq | fzf --header="Which font?" $quer --reverse --height 50%) ||
                    file=$(FONTPREVIEW_QUERY="$file" FONTPREVIEW_FONTS="$name" $TMPDIR/fontpreview.sh) 
                style=$(echo $file | cut -d. -f-1 | cut -d- -f2) 
                familystyle=$(fc-query "$XDG_DATA_HOME/fonts/$file" --format "%{family} %{style}\n" | uniq) 
                reade -Q 'GREEN' -i "10 $(seq 1 48 | tr '\n' ' ')" -p "Default fontsize (Default 10): " size 
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
