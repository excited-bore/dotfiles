#!/bin/bash

if ! type reade &> /dev/null && test -f ~/.bash_aliases.d/00-rlwrap_scripts.sh; then
    . ~/.bash_aliases.d/00-rlwrap_scripts.sh
fi 

if type ffmpeg &> /dev/null; then

    function ffmpeg-convert-to-mp3(){
        readyn -N 'GREEN' -n -p "Delete after conversion?" del
        for var in "$@"
        do
            ffmpeg -i "$var" -vn -acodec libmp3lame -ac 2 -ab 160k -ar 48000 "${var%.*}.mp3" && test "$del" == 'y' && test -f "$var" && rm -v "$var" 
        done
    }
    
    function ffmpeg-convert-mkv-embed-subtitles(){
        readyn -N 'GREEN' -n -p "Delete after conversion?" del
        for var in "$@"
        do
            filename=$(basename -- "$var")
            ext="${filename##*.}" 
            filename="${filename%.*}" 
            sub=''
            compgen -G "$filename*.vtt" 
            if compgen -G "$filename*.vtt" &> /dev/null || compgen -G  "$filename*.srt" || compgen -G  "$filename*.ass"; then                
             
                compgen -G "$filename*.srt" &> /dev/null && pos=$(compgen -G "$filename*.srt")
                compgen -G "$filename*.vtt" &> /dev/null && pos=$(compgen -G "$filename*.vtt")
                compgen -G "$filename*.ass" &> /dev/null && pos=$(compgen -G "$filename*.ass")
                reade -N "GREEN" -n -p " Use ${cyan}$pos${GREEN} as subtitle file?" sub_pos
                if test $sub_pos == 'y'; then
                    sub=$pos 
                fi
            else
                reade -Q "GREEN" -p "Subtitle file?: " -e sub
            fi
            if ! test -f "$sub"; then
                echo 'No subtitle file found'
                return 1
            fi
            if [[ $var =~ '.mkv' ]]; then
               var_o="${var%.*}1.mkv"
            else
               var_o="${var%.*}.mkv"
            fi
            ffmpeg -i "$var" -vf subtitles="'$sub'" "$var_o" && test "$del" == 'y' && test -f "$var" && rm -v "$var"
            test "$del" == 'y' && test -f $sub && rm -v $sub  
        done
    }

    function videotomp3(){
        readyn -N "GREEN" -n -p "Delete after conversion?" del
        for var in "$@"
        do
            ffmpeg -i "$var" -vn -acodec libmp3lame -ac 2 -ab 160k -ar 48000 "${var%.*}.mp3" && test "$del" == 'y' && test -f "$var" && rm -v "$var" 
        done
    }
     

    function ffmpeg-convert-to-mp4(){
        reade -N "GREEN" -n -p "Delete after conversion?" del
        for var in "$@"
        do
            local sub='' 
            reade -Q "GREEN" -p "Add subtitle file? (leave empty if no): " -e sub
            if ! test -z $sub && ! test -f "$sub"; then
                echo 'No subtitle file found'
                return 1
            elif ! test -z $sub && test -f $sub; then
                sub="subtitle=\"'$sub'\""
            fi
            ffmpeg -i "$var" $sub "${var%.*}.mp4" && test "$del" == 'y' && test -f "$var" && rm -v "$var" 
            test "$del" == 'y' && test -f $sub && rm -v $sub  
        done
        unset del sub var 
    }
    
fi
