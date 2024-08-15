if ! type reade &> /dev/null; then
    . ~/.bash_aliases.d/00-rlwrap_scripts.sh
fi

alias check_songs='serber "cd /mnt/MyStuff/Files/Audio/ && ls | xargs -0"'
alias check_youtubes='serber "cd /mnt/MyStuff/Files/Videos/YouTubes/ && ls | xargs -0 "'

if test -z "$yt_dl" && type yt-dlp &> /dev/null || type youtube-dl &> /dev/null; then
    if type yt-dlp &> /dev/null; then
        yt_dl='yt-dlp'
    elif type youtube-dl &> /dev/null; then
        yt_dl='youtube-dl'
    fi

    function yt-dl(){
        if [ -z "$1" ]; then                                
            reade -Q "GREEN" -p "Link to youtube video (Go to browser -> Ctrl-L + Ctrl-C): " "" url
        else
            url=$1
        fi
        format=""
        format_sub=""
        format_sub_auto=""
        test $yt_dl == 'yt_dlp' && form_pre="mp4 flv ogg webm mkv avi" || form_pre="mp4 flv ogg webm mkv avi gif mp3 wav vorbis mov mka aac aiff alac flac m4a" 
        reade -Q "green" -i "best" -p "Video Format? [Best(default)/avi/flv/gif/mkv/mov/mp4/webm/aac/aiff/alac/flac/m4a/mka/mp3/ogg/opus/vorbis/wav]: " "avi flv gif mkv mov mp4 webm aac aiff alac flac m4a mka mp3 ogg opus vorbis wav" format
        if ! test $format == 'best'; then
            format=" --recode-video $format"
        else
            format=''
        fi
        reade -Q "GREEN" -i "y" -p "Include subtitles and auto captions? [Y/n/sub(only)/cap(only)]: " "n sub cap" sub_cap
        if test "$sub_cap" == 'y' || test "$sub_cap" == 'sub' || test "$sub_cap" == 'cap' ; then
            sub=''
            sub_auto=''
            echo "Fetching possible formats"
            if test "$yt_dl" == 'yt-dlp'; then
                list_sub="$(yt-dlp --list-subs --simulate $url)" 
                sub_list="$(echo "$list_sub" | awk '/subtitle/{flag=1;next}/\[info\]/{flag=0}flag')"
                subs=$(echo "$sub_list" | awk 'NR>2 {$1=$2="";  print}' | sed 's/(.*) //g' | sed 's/,/\n/g' | sed '/^[[:space:]]*$/d' | sort -u)
                cap_list="$(echo "$list_sub" | awk '/captions/{flag=1;next}/subtitles/{flag=0}flag')"
                cap_frm=$(echo "$sub_list" | awk 'NR>2 {$1=$2="";  print}' | sed 's/(.*) //g' | sed 's/,/\n/g' | sed '/^[[:space:]]*$/d' | sort -u)
            else
                list_sub="$(youtube-dl --list-subs --simulate $url)"
                sub_list="$(echo "$list_sub" | awk '/subtitles/,EOF')"
                subs=$(echo "$sub_list" | awk 'NR>2 {$1="";  print $0}' | sed 's/,//g' | sed 's/,/\n/g' | sed '/^[[:space:]]*$/d' | sort -u)
                cap_list="$(echo "$list_sub" | awk '/captions/{flag=1;next}/subtitles/{flag=0}flag')"
                cap_frm=$(echo "$sub_list" | awk 'NR>2 {$1=$2="";  print}' | sed 's/(.*) //g' | sed 's/,/\n/g' | sed '/^[[:space:]]*$/d' | sort -u)
            fi
            if test $sub_cap == 'y' || test $sub_cap == 'sub'; then
                test $yt_dl == 'yt_dlp' && sub=" --write-subs" || sub=" --write-sub" 
                test $yt_dl == 'yt_dlp' && sub_lang=" --sub-langs" || sub=" --sub-lang" 
                reade -Q "CYAN" -i "n" -p "Set subtitle format? [N/y]: " "y" format_sub
                if test "$format_sub" == 'n'; then
                    format_sub=" "
                else
                    if test -z "$sub_list" || [[ "$sub_list" =~ 'no subtitles' ]] ; then

                        echo 'No subtitles available for this video'
                        format_sub=''
                    else 
                        sub_langs=$(echo "$sub_list" | awk 'NR>1{print $1;}' | sed '/live_chat/d')
                        frst_frm=$(echo "$subs" | awk '{print $1}')
                        frst_frm_p=$(echo "$frst_frm" | tr '[:lower:]' '[:upper:]')
                        subs=$(echo "$subs" | sed $'s/$frst_frm//g' )
                        echo "$sub_list"
                        reade -Q "cyan" -i "all" -p "Languages?: " "$sub_langs" lang
                        if ! test -z $lang; then
                            lang="$sub_lang $lang"
                        fi
                        reade -Q "cyan" -i "$frst_frm" -p "Format [$frst_frm_p$subs_pre]: " "$subs" format_sub
                        format_sub="--sub-format $format_sub"
                        live_chat=""
                        if test $yt_dl == 'yt-dlp' && [[ "$sub_list" =~ 'live_chat' ]]; then 
                            if test "$subs" == 'all'; then
                                reade -Q 'cyan' -i 'n' -p 'Subtitles include live chat. Explicitly exclude from subtitles? [N/y]: ' "y" live_chat_no
                                if test "$live_chat_no" == 'y'; then
                                    live_chat="--compat-options no-live-chat"
                                fi
                            else
                                reade -Q 'cyan' -i 'n' -p 'Subtitles include live chat. Write subtitles for? [N/y]: ' "y" live_chat
                                if test "$live_chat" == 'y'; then
                                    lang="$lang,live_chat"
                                    #chat_frm="$(echo "$sub_list" | grep --color=never live_chat | awk '{$1=""; print}' | sed 's/(.*) //g' | sed 's/,/\n/g' | sed '/^[[:space:]]*$/d' | sort -u)"
                                    #if ! test $(echo "$chat_frm" | wc -l) == 1; then
                                    #    frst_frm=$(echo "$chat_frm" | awk '{print $1}')   
                                    #    frst_frm_p=$(echo "$frst_frm" | tr '[:lower:]' '[:upper:]')
                                    #    subs=$(echo "$subs" | sed "s/$frst_frm//g" )
                                    #    subs_pre=$(echo "$subs" | tr '\n' ' ' | tr -s ' ' | tr ' ' '/' | sed 's/.$//')
                                    #    reade -Q 'cyan' -i "$frst_frm" -p "Live chat format? [$frst_frm_p]: " "y" live_chat_no

                                    #fi
                                fi
                            fi
                        fi
                    fi
                    format_sub=" $format_sub $lang $live_chat"
                fi
            fi
            sub="$sub $format_sub"
            if test "$sub_cap" == 'y' || test "$sub_cap" == 'cap'; then
                test $yt_dl == 'yt_dlp' && sub_auto=" --write-auto-subs" || sub_auto=" --write-auto-sub" 
                reade -Q "CYAN" -i "n" -p "Set auto captions format? [N/y]: " "y" sub_auto
                if test $sub_auto == 'n'; then
                    sub_auto=" "
                else
                    if test -z "$sub_list" || [[ "$sub_list" =~ 'no subtitles' ]] ; then
                        echo 'No auto captions available for this video'
                        format_sub=''
                    else 
                        subs_pre=$(echo "$subs" | tr '\n' ' ' | tr -s ' ' | tr ' ' '/' | sed 's/.$//')          
                        cap_langs=$(echo "$cap_list" | awk 'NR>1{;print $1;}')
                        frst_frm=$(echo "$cap_list" | awk '{print $1}')
                        frst_frm_p=$(echo "$frst_frm" | tr '[:lower:]' '[:upper:]')
                        subs=$(echo "$subs" | sed $'s/$frst_frm//g' )
                        echo "$sub_list"
                        reade -Q "cyan" -i "all" -p "Languages?: " "$sub_langs" lang
                        if ! test -z $lang; then
                            lang="--sub-lang $lang"
                        fi
                        reade -Q "cyan" -i "$frst_frm" -p "Format [$frst_frm_p$subs_pre]: " "$subs" format_sub
                        format_sub="--sub-format $format_sub"
                        live_chat=""
                        if test $yt_dl == 'yt-dlp' && [[ "$sub_list" =~ 'live_chat' ]]; then
                            reade -Q 'cyan' -i 'n' -p 'Subtitles include live chat. Explicitly exclude from subtitles? [N/y]: ' "y" live_chat_no
                            if test "$live_chat_no" == 'y'; then
                                live_chat="--compat-options no-live-chat"
                            fi
                        fi
                    fi
                    format_sub=" $format_sub $lang $live_chat"
                fi
            fi
            # https://stackoverflow.com/questions/17988756/how-to-select-lines-between-two-marker-patterns-which-may-occur-multiple-times-w
        fi
        "$yt_dl" -c -i -R 20 $format $sub $sub_auto "$url" ;
    }

    alias youtube-download="yt-dl"

    function yt-dl-dir(){
        if [ ! -z "$1" ] && [ ! -z "$2" ]; then                                
            (mkdir "$2" && cd "$2";
            reade -Q "green" -i "best" -p "Video Format? [Best(default)/avi/flv/gif/mkv/mov/mp4/webm/aac/aiff/alac/flac/m4a/mka/mp3/ogg/opus/vorbis/wav]: " "avi flv gif mkv mov mp4 webm aac aiff alac flac m4a mka mp3 ogg opus vorbis wav" format
            if test $format == 'best'; then
                format=""
            else
                format=" --remux-video $format"
            fi
            "$yt_dl" -c -i -R 20 $format --write-sub --yes-playlist "$1" ;)
        else
            echo "Give up a url and a dir, big guy. Know you can do it xoxox" ;
        fi
    }
    
    alias youtube-download-dir="yt-dl-dir"

    function yt-dl-audio-only(){
        reade -Q "green" -i "best" -p "Audio Format? [Best(default)/aac/alac/flac/m4a/mp3/opus/vorbis/wav]: " "aac alac flac m4a mp3 opus vorbis wav" format
        if test "$format" == 'best'; then
            aud_format=''
        else
            aud_format=" --audio-format $format"
        fi
        if [ ! -z "$1" ]; then    
            if [ ! -z "$2" ]; then
                "$yt_dl" -c -i -R 20 -x $aud_format --write-sub --yes-playlist "$1" $start $end;
            else 
                "$yt_dl" -c -i -R 20 -x $aud_format --write-sub --yes-playlist "$1" $start $end;
            fi
        else
            echo "Give up a url, big guy. Know you can do it xoxox" ;
        fi
    }
    
    alias youtube-download-audio-only="yt-dl-audio-only"
    
    # Numbered tracks => -o "%(playlist)s\%(playlist_index)s - %(title)s.%(ext)s"

    function yt-dl-playlist(){
        start=" "
        end=" " 
        if [ ! -z "$2" ]; then
            start=" --playlist-start $2";
        fi
        if [ ! -z "$3" ]; then
            end=" --playlist-end $3";
        fi
        if [ ! -z "$1" ]; then                                
            reade -Q "green" -i "best" -p "Video Format? [Best(default)/avi/flv/gif/mkv/mov/mp4/webm/aac/aiff/alac/flac/m4a/mka/mp3/ogg/opus/vorbis/wav]: " "avi flv gif mkv mov mp4 webm aac aiff alac flac m4a mka mp3 ogg opus vorbis wav" format
            if test $format == 'best'; then
                format=""
            else
                format=" --remux-video $format"
            fi
            reade -Q "green" -i "y" -p "Make directory using playlist name and put songs in said dir? [Y/n]: " "n" plst_dir
            if test "$plst_dir" == "y"; then
                "$yt_dl" -c -i -R 20 $format -o "%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s" --write-sub --yes-playlist "$1" "$start" "$end";
            else
                "$yt_dl" -c -i -R 20 $format -o "%(playlist_index)s - %(title)s.%(ext)s" --write-sub --yes-playlist "$1" "$start" "$end";
            fi
        else
            echo "Give up a url, big guy. Know you can do it xoxox" ;
        fi
    }
        
    alias youtube-download-playlist="yt-dl-playlist"

    function yt-dl-playlist-audio-only(){
        start=" "
        end=" " 
        if [ ! -z "$3" ]; then
            start=" --playlist-start $3";
        fi
        if [ ! -z "$4" ]; then
            end=" --playlist-end $4";
        fi
        if [ ! -z "$1" ]; then                                
            reade -Q "green" -i "best" -p "Audio Format? [Best(default)/aac/alac/flac/m4a/mp3/opus/vorbis/wav]: " "aac alac flac m4a mp3 opus vorbis wav" format
            reade -Q "green" -i "y" -p "Make directory using playlist name and put songs in said dir? [Y/n]: " "n" plst_dir
            if test "$format" == 'best'; then
                aud_format=''
            else
                aud_format=" --audio-format $format"
            fi
            if test "$plst_dir" == "y"; then
                "$yt_dl" -c -i -R 20 -o "%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s" -x $aud_format --write-sub --yes-playlist "$1" "$start" "$end";
            else
                "$yt_dl" -c -i -R 20 -o "%(playlist_index)s - %(title)s.%(ext)s" -x $aud_format --write-sub --yes-playlist "$1" "$start" "$end";
            fi
        else
            echo "Give up a url, big guy. Know you can do it xoxox" ;
        fi
    }

    alias youtube-download-playlist-audio-only="yt-dl-playlist-audio-only"


    function yt-dl-playlist-dir(){
        start=" "
        end=" " 
        if [ ! -z "$3" ]; then
            start=" --playlist-start $3";
        fi
        if [ ! -z "$4" ]; then
            end=" --playlist-end $4";
        fi
        if [ ! -z "$1" ]; then
            reade -Q "green" -i "best" -p "Video Format? [Best(default)/avi/flv/gif/mkv/mov/mp4/webm/aac/aiff/alac/flac/m4a/mka/mp3/ogg/opus/vorbis/wav]: " "avi flv gif mkv mov mp4 webm aac aiff alac flac m4a mka mp3 ogg opus vorbis wav" format
            if test $format == 'best'; then
                format=""
            else
                format=" --remux-video $format"
            fi
            reade -Q "green" -p "Name directory? (default - playlist name)" "" plst_name
            if test "$plst_name" == ""; then
                "$yt_dl" -c -i -R 20 $format -o "%(playlist)s\%(playlist_index)s - %(title)s.%(ext)s" --write-sub --yes-playlist "$1" "$start" "$end" ; 
            else
                (cd "$plst_name"
                "$yt_dl" -c -i -R 20 $format -o "%(playlist_index)s - %(title)s.%(ext)s" -x $aud_format --write-sub --yes-playlist "$1" "$start" "$end")
            fi
            
        else
            echo "Give up a url, big guy. Know you can do it xoxox" ;
        fi
    }

    alias youtube-download-playlist-dir="yt-dl-playlist"
    
    function yt-dl-playlist-audio-only-dir(){
        start=" "
        end=" " 
        if [ ! -z "$3" ]; then
            start="--playlist-start $3";
        fi
        if [ ! -z "$4" ]; then
            end=" --playlist-end $4";
        fi
        reade -Q "green" -i "best" -p "Audio Format? [Best(default)/aac/alac/flac/m4a/mp3/opus/vorbis/wav]: " "aac alac flac m4a mp3 opus vorbis wav" format
        if test "$format" == 'best'; then
            aud_format=''
        else
            aud_format=" --audio-format $format"
        fi
        if test -z "$1" || test -z "$2"; then
            echo "Give up a url and a dir, big guy. Know you can do it xoxox";
        else
            mkdir "$2";
            (cd "$2"    
            "$yt_dl" -c -i -R 20 -o "%(playlist_index)s - %(title)s.%(ext)s" -x $aud_format --write-sub --yes-playlist "$1" "$start" "$end";
            )
        fi
    }
    alias youtube-download-playlist-dir="yt-dl-playlist-yt-dl-playlist-audio-only-dir"
fi


