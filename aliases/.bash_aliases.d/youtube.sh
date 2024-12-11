if ! type reade &> /dev/null && test -f ~/.bash_aliases.d/00-rlwrap_scripts.sh; then
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
            reade -Q "GREEN" -i "''" -p "Link to youtube video (Go to browser -> Ctrl-L + Ctrl-C): " "" url
        else
            url=$1
        fi

        [[ $yt_dl =~ 'yt_dlp' ]] && form_pre="mp4 flv ogg webm mkv avi" || form_pre="mp4 flv ogg webm mkv avi gif mp3 wav vorbis mov mka aac aiff alac flac m4a" 
        
        less_=''
        if type less &> /dev/null; then
            less_="| less --quit-if-one-screen"
        fi
        playlist='--no-playlist'
        start=" "
        end=" "
        plst_frm=''
        rror='' 

        readyn -n -N 'GREEN' -p 'Download playlist if url directs to one?' plslt
        if test $plslt == 'y' ; then
            playlist="--yes-playlist"
            reade -Q 'cyan' -i '' -p 'Start playlist? (In numbers, leave empty will start here): ' start
            if [ ! -z "$start" ]; then
                start=" --playlist-start $start";
            fi
            reade -Q 'cyan' -i '' -p 'End playlist? (In numbers, leave empty will download until end): ' end
            if [ ! -z "$end" ]; then
                end=" --playlist-end $end";
            fi

            readyn -Y "green" -p "Give each videotitle the index according how it's ordered in the playlist? (f.ex. '4) Lofi Mix.mp3')" plst_rank
            if test "$plst_rank" == "y"; then
                plst_frm="%(playlist_index)s - %(title)s.%(ext)s"
            fi
            
            reade -Q "green" -i "3 1 2 4 5 6 7 8 9 10" -p "How many errors for a video in list is skipped?: " rror
            rror=" --skip-playlist-after-error $rror"

            readyn -Q "green" -p "Make directory using playlist name and put songs in said dir?" plst_dir
            if test "$plst_dir" == "y"; then
                if ! test -z $plst_rank; then
                    plst_frm="%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s"
                else
                    plst_frm="%(playlist)s/%(title)s.%(ext)s"
                fi
            fi
        else
            playlist="--no-playlist"
        fi


        format=""
        format_sub=""
        format_cap=""
        format_all=""

        readyn -n -N 'CYAN' -p 'Audio only?:' aud_only
        if test $aud_only == 'y'; then
            reade -Q "green" -i "best mp3 opus aac alac flac m4a vorbis wav" -p "Audio Format? [Best(default)/mp3/opus/aac/alac/flac/m4a/vorbis/wav]: " format
            if test "$format" == 'best'; then
                format='-x'
            else
                format="-x --audio-format $format"
            fi
        else
            reade -Q "green" -i "best mp4 mkv avi flv gif mov webm aac aiff alac flac m4a mka mp3 ogg opus vorbis wav" -p "Video Format? [Best(default)/mp4/mkv/avi/flv/gif/mov/mp4/webm/aac/aiff/alac/flac/m4a/mka/mp3/ogg/opus/vorbis/wav]: " format
            if ! test $format == 'best'; then
                format=" --recode-video $format"
            else
                format=''
            fi
        fi

        reade -Q "GREEN" -i "y n sub cap" -p "Include subtitles and auto captions? [Y(Both)/n/sub/cap]: " sub_cap

        if test "$sub_cap" == 'y' || test "$sub_cap" == 'sub' || test "$sub_cap" == 'cap' ; then
            sub=''
            cap=''
            echo "Fetching possible formats"
            if [[ "$yt_dl" =~ 'yt-dlp' ]]; then
                list_sub="$(yt-dlp --skip-download --list-subs --simulate $playlist -- $url)" 
                sub_list="$(echo "$list_sub" | awk '/subtitles/{flag=1;next}/\[info\]/{flag=0}flag')"
                subs=$(echo "$sub_list" | awk 'NR>1 {$1=$2="";  print}' | sed 's/(.*) //g' | sed 's/,/\n/g' | sed '/^[[:space:]]*$/d' | sort -u)
                cap_list=$(echo "$list_sub" | awk '/captions/{flag=1;next}/subtitles/{flag=0}flag')
                cap_frm=$(echo "$cap_list" | awk 'NR>2 {$1=$2="";  print}'  | sed 's/(.*) //g' | sed 's/[[:upper:]].*$//g' | sed 's/,/\n/g' | sed '/^[[:space:]]*$/d' | sed '/from/d' | sort -u)
            else
                list_sub="$(youtube-dl --skip-download --list-subs --simulate $playlist -- $url)"
                sub_list="$(echo "$list_sub" | awk '/subtitles/,EOF')"
                subs=$(echo "$sub_list" | awk 'NR>2 {$1="";  print $0}' | sed 's/,//g' | sed 's/,/\n/g' | sed '/^[[:space:]]*$/d' | sort -u)
                cap_list=$(echo "$list_sub" | awk '/captions/{flag=1;next}/subtitles/{flag=0}flag')
                cap_frm=$(echo "$cap_list" | awk 'NR>2 {$1=$2="";  print}'  | sed 's/(.*) //g' | sed 's/[[:upper:]].*$//g' | sed 's/,/\n/g' | sed '/^[[:space:]]*$/d' | sed '/from/d' | sort -u)
            fi
            [[ $yt_dl =~ 'yt_dlp' ]] && sub=" --write-subs" || sub=" --write-sub" 
            [[ $yt_dl =~ 'yt_dlp' ]] && sub_lang=" --sub-langs" || sub_lang=" --sub-lang" 
            if test $sub_cap == 'y' || test $sub_cap == 'sub'; then
                format_sub=''
                if test -z "$sub_list" || [[ "$sub_list" =~ 'no subtitles' ]] ; then
                    echo 'No subtitles available for this video'
                    format_sub=''
                else 
                    readyn -n -N "CYAN" -p "Set subtitle format?" format_sub
                    if test "$format_sub" == 'y'; then
                        sub_langs=$(echo "$sub_list" | awk 'NR>1{print $1;}' | sed '/live_chat/d')
                        frst_frm=$(echo $subs | awk '{print $1}')
                        frst_frm_p=$(echo "$frst_frm" | tr '[:lower:]' '[:upper:]')
                        subs=$(echo $subs | sed 's/'"$frst_frm "'//g')
                        frm_pre=$(echo "$subs" | tr '\n' ' ' | tr -s ' ' | tr ' ' '/' | sed 's/.$//')
                        echo "$sub_list"
                        if ! test -z "$sub_langs"; then
                            readyn -Q "cyan" -i "all $sub_langs" -p "Languages?: " lang
                            if ! test -z $lang; then
                                lang="$sub_lang $lang"
                            fi
                        fi
                        if ! test -z "$sub_langs"; then
                            reade -Q "cyan" -i "$frst_frm $subs" -p "Format [$frst_frm_p/$frm_pre]: " format
                            format_sub="--sub-format $format"
                        fi
                        live_chat=""
                        if [[ $yt_dl =~ 'yt-dlp' ]] && [[ "$sub_list" =~ 'live_chat' ]]; then 
                            if test "$subs" == 'all'; then
                                readyn -y 'cyan' -p 'Subtitles include live chat. Explicitly exclude from subtitles?' live_chat_no
                                if test "$live_chat_no" == 'y'; then
                                    live_chat="--compat-options no-live-chat"
                                fi
                            else
                                readyn -n -N 'cyan' -p 'Subtitles include live chat. Write subtitles for?' live_chat
                                if test "$live_chat" == 'y'; then
                                    if ! test -z "$lang"; then
                                        lang="$lang,live_chat"
                                    else
                                        lang="$sub_lang live_chat"
                                    fi
                                fi
                            fi
                        fi
                    fi
                    format_sub=" $format_sub $lang $live_chat"
                fi
            fi
            sub="$sub $format_sub"
            if test "$sub_cap" == 'y' || test "$sub_cap" == 'cap'; then
                sub_auto=" "
                if test -z "$cap_list" || [[ "$cap_list" =~ 'no auto captions' ]] ; then
                    echo 'No auto captions available for this video'
                else
                    readyn -n -N "CYAN" -p "Set auto captions format?" sub_auto
                    if test $sub_auto == 'y'; then
                        [[ $yt_dl =~ 'yt_dlp' ]] && sub_auto=" --write-auto-subs" || sub_auto=" --write-auto-sub" 
                        format_sub=''
                        cap_langs=$(echo "$cap_list" | awk 'NR>1{print $1;}')
                        frst_frm=$(echo $cap_frm | awk '{print $1}')
                        frst_frm_p=$(echo "$frst_frm" | tr '[:lower:]' '[:upper:]')
                        cap_frm=$(echo $cap_frm | sed 's/'"$frst_frm "'//g')
                        cap_frm_p=$(echo "$cap_frm" | tr '\n' ' ' | tr -s ' ' | tr ' ' '/' | sed 's/.$//')
                        eval 'echo "$cap_list"'" $less_"
                        if ! test -z "$cap_langs" ; then
                            reade -Q "cyan" -i "all $cap_langs" -p "Languages?: "  caplang
                            cap_lang="$sub_lang $caplang"
                            reade -Q "cyan" -i "$frst_frm $cap_frm" -p "Format [$frst_frm_p/$cap_frm_p]: " format_cap
                            format_cap="--sub-format $format_cap"
                        else
                            format_cap=''
                            cap_lang=''
                        fi
                    fi
                    format_cap=" $format_cap $cap_lang"
                fi
                cap="$cap $format_cap"
            fi
            
            # https://stackoverflow.com/questions/17988756/how-to-select-lines-between-two-marker-patterns-which-may-occur-multiple-times-w
        fi
        
        readyn -n -N "magenta" -p "Set ${bold}minimum${normal}${magenta} resolution? (Will always try to the get best available by default)" min_res 
        if test $min_res == 'y'; then
            echo 'Fetching available formats'
            eval "$yt_dl --color always --list-formats $url | awk '/\[info\]/,EOF' $less_"   
            reade -Q 'GREEN' -i '1080' -p 'Minimum resolution: ' '720 480 360 240 144' res
            [[ $yt_dl =~ 'yt_dlp' ]] && format_all="-f 'bv[res>=$res]*+ba/b'" || format_all="-f 'bestvideo[resolution>=$res]+bestaudio/best'" 
        fi
            
        if ! test -z "$plst_frm"; then
            "$yt_dl" -c -i -R 20 $playlist $start $end $rror -o "$plst_frm" $format $format_all $sub $cap -- "$url" ;
        else
            "$yt_dl" -c -i -R 20 $playlist $start $end $rror $format $format_all $sub $cap -- "$url" ;
        fi
        unset plslt plst_frm plst_dir plst_rank playlist start end plst_dir cap sub format format_sub form_pre format_cap format_all formats url cap_list sub_list frst_frm_p frst_frm caplang sub_auto live_chat cap_langs sub_lang sub_langs less_
    }

    alias youtube-download="yt-dl"
    #alias yt-dl-dir="reade -Q 'GREEN' -p \"Dir? : \" -e dir && mkdir "$dir" && cd "$dir" && yt-dl && unset dir"
    #alias youtube-download-dir="reade -Q 'GREEN' -p \"Dir? : \" -e dir && mkdir "$dir" && cd "$dir" && yt-dl && unset dir"

    #function yt-dl-audio-only(){
    #    reade -Q "green" -i "best" -p "Audio Format? [Best(default)/aac/alac/flac/m4a/mp3/opus/vorbis/wav]: " "aac alac flac m4a mp3 opus vorbis wav" format
    #    if test "$format" == 'best'; then
    #        aud_format=''
    #    else
    #        aud_format=" --audio-format $format"
    #    fi
    #    if [ ! -z "$1" ]; then    
    #        if [ ! -z "$2" ]; then
    #            "$yt_dl" -c -i -R 20 -x $aud_format --write-sub "$1" $start $end;
    #        else 
    #            "$yt_dl" -c -i -R 20 -x $aud_format --write-sub "$1" $start $end;
    #        fi
    #    else
    #        echo "Give up a url, big guy. Know you can do it xoxox" ;
    #    fi
    #}
    #
    #alias youtube-download-audio-only="yt-dl-audio-only"
    
    # Numbered tracks => -o "%(playlist)s\%(playlist_index)s - %(title)s.%(ext)s"

    #function yt-dl-playlist(){
    #    if [ ! -z "$1" ]; then                                
    #        reade -Q "green" -i "best" -p "Video Format? [Best(default)/avi/flv/gif/mkv/mov/mp4/webm/aac/aiff/alac/flac/m4a/mka/mp3/ogg/opus/vorbis/wav]: " "avi flv gif mkv mov mp4 webm aac aiff alac flac m4a mka mp3 ogg opus vorbis wav" format
    #        if test $format == 'best'; then
    #            format=""
    #        else
    #            format=" --remux-video $format"
    #        fi
    #        reade -Q "green" -i "y" -p "Make directory using playlist name and put songs in said dir? [Y/n]: " "n" plst_dir
    #        if test "$plst_dir" == "y"; then
    #            "$yt_dl" -c -i -R 20 $format -o "%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s" --write-sub --yes-playlist "$1" "$start" "$end";
    #        else
    #            "$yt_dl" -c -i -R 20 $format -o "%(playlist_index)s - %(title)s.%(ext)s" --write-sub --yes-playlist "$1" "$start" "$end";
    #        fi
    #    else
    #        echo "Give up a url, big guy. Know you can do it xoxox" ;
    #    fi
    #}
    #    
    #alias youtube-download-playlist="yt-dl-playlist"

    #function yt-dl-playlist-audio-only(){
    #    start=" "
    #    end=" " 
    #    if [ ! -z "$3" ]; then
    #        start=" --playlist-start $3";
    #    fi
    #    if [ ! -z "$4" ]; then
    #        end=" --playlist-end $4";
    #    fi
    #    if [ ! -z "$1" ]; then                                
    #        reade -Q "green" -i "best" -p "Audio Format? [Best(default)/aac/alac/flac/m4a/mp3/opus/vorbis/wav]: " "aac alac flac m4a mp3 opus vorbis wav" format
    #        reade -Q "green" -i "y" -p "Make directory using playlist name and put songs in said dir? [Y/n]: " "n" plst_dir
    #        if test "$format" == 'best'; then
    #            aud_format=''
    #        else
    #            aud_format=" --audio-format $format"
    #        fi
    #        if test "$plst_dir" == "y"; then
    #            "$yt_dl" -c -i -R 20 -o "%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s" -x $aud_format --write-sub --yes-playlist "$1" "$start" "$end";
    #        else
    #            "$yt_dl" -c -i -R 20 -o "%(playlist_index)s - %(title)s.%(ext)s" -x $aud_format --write-sub --yes-playlist "$1" "$start" "$end";
    #        fi
    #    else
    #        echo "Give up a url, big guy. Know you can do it xoxox" ;
    #    fi
    #}

    #alias youtube-download-playlist-audio-only="yt-dl-playlist-audio-only"


    #function yt-dl-playlist-dir(){
    #    start=" "
    #    end=" " 
    #    if [ ! -z "$3" ]; then
    #        start=" --playlist-start $3";
    #    fi
    #    if [ ! -z "$4" ]; then
    #        end=" --playlist-end $4";
    #    fi
    #    if [ ! -z "$1" ]; then
    #        reade -Q "green" -i "best" -p "Video Format? [Best(default)/avi/flv/gif/mkv/mov/mp4/webm/aac/aiff/alac/flac/m4a/mka/mp3/ogg/opus/vorbis/wav]: " "avi flv gif mkv mov mp4 webm aac aiff alac flac m4a mka mp3 ogg opus vorbis wav" format
    #        if test $format == 'best'; then
    #            format=""
    #        else
    #            format=" --remux-video $format"
    #        fi
    #        reade -Q "green" -p "Name directory? (default - playlist name)" "" plst_name
    #        if test "$plst_name" == ""; then
    #            "$yt_dl" -c -i -R 20 $format -o "%(playlist)s\%(playlist_index)s - %(title)s.%(ext)s" --write-sub --yes-playlist "$1" "$start" "$end" ; 
    #        else
    #            (cd "$plst_name"
    #            "$yt_dl" -c -i -R 20 $format -o "%(playlist_index)s - %(title)s.%(ext)s" -x $aud_format --write-sub --yes-playlist "$1" "$start" "$end")
    #        fi
    #        
    #    else
    #        echo "Give up a url, big guy. Know you can do it xoxox" ;
    #    fi
    #}

    #alias youtube-download-playlist-dir="yt-dl-playlist"
    #
    #function yt-dl-playlist-audio-only-dir(){
    #    start=" "
    #    end=" " 
    #    if [ ! -z "$3" ]; then
    #        start="--playlist-start $3";
    #    fi
    #    if [ ! -z "$4" ]; then
    #        end=" --playlist-end $4";
    #    fi
    #    reade -Q "green" -i "best" -p "Audio Format? [Best(default)/aac/alac/flac/m4a/mp3/opus/vorbis/wav]: " "aac alac flac m4a mp3 opus vorbis wav" format
    #    if test "$format" == 'best'; then
    #        aud_format=''
    #    else
    #        aud_format=" --audio-format $format"
    #    fi
    #    if test -z "$1" || test -z "$2"; then
    #        echo "Give up a url and a dir, big guy. Know you can do it xoxox";
    #    else
    #        mkdir "$2";
    #        (cd "$2"    
    #        "$yt_dl" -c -i -R 20 -o "%(playlist_index)s - %(title)s.%(ext)s" -x $aud_format --write-sub --yes-playlist "$1" "$start" "$end";
    #        )
    #    fi
    #}
    #alias youtube-download-playlist-dir="yt-dl-playlist-yt-dl-playlist-audio-only-dir"
fi

