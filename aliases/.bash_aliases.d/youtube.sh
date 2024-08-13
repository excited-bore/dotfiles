if ! type reade &> /dev/null; then
    . ~/.bash_aliases.d/00-rlwrap_scripts.sh
fi

alias check_songs='serber "cd /mnt/MyStuff/Files/Audio/ && ls | xargs -0"'
alias check_youtubes='serber "cd /mnt/MyStuff/Files/Videos/YouTubes/ && ls | xargs -0 "'

if type yt-dlp &> /dev/null || type youtube-dl &> /dev/null; then
    if type youtube-dl &> /dev/null; then
        yt_dl='youtube-dl'
    elif type yt-dlp &> /dev/null; then
        yt_dl='yt-dlp'
    fi

    function yt-dl(){
        if [ ! -z "$1" ]; then                                
            format=""
            format_sub=""
            format_sub_auto=""
            test $yt_dl == 'yt_dlp' && form_pre="mp4 flv ogg webm mkv avi" || form_pre="mp4 flv ogg webm mkv avi gif mp3 wav vorbis mov mka aac aiff alac flac m4a" 
            reade -Q "green" -i "best" -p "Video Format? [Best(default)/avi/flv/gif/mkv/mov/mp4/webm/aac/aiff/alac/flac/m4a/mka/mp3/ogg/opus/vorbis/wav]: " "avi flv gif mkv mov mp4 webm aac aiff alac flac m4a mka mp3 ogg opus vorbis wav" format
            if ! test $format == 'best'; then
                format=" --recode-video $format"
            fi
            reade -Q "GREEN" -i "y" -p "Include subtitles? [Y/n]: " "n" format_sub
            if test $format_sub == 'y'; then
                test $yt_dl == 'yt_dlp' && sub=" --write-subs" || sub=" --write-sub" 

                # youtube-dl --list-subs --simulate $1 | awk '/subtitles/,EOF'
                # yt-dlp --list-subs --simulate $1 | awk '/subtitle/{flag=1;next}/\[info\]/{flag=0}flag'
                
                # https://stackoverflow.com/questions/17988756/how-to-select-lines-between-two-marker-patterns-which-may-occur-multiple-times-w
                
                reade -Q "cyan" -i "n" -p "Set subtitle format? [N/y]: " format_sub
                if test $format_sub == 'n'; then
                    format_sub=" "
                else
                    format_sub=" --sub-format $format_sub"
                fi
                sub="$sub $format_sub"
                reade -Q "cyan" -i "n" -p "Also include auto generated subtitles? [N/y]: " "n" sub_auto
                if test $sub_auto == 'y'; then
                    test $yt_dl == 'yt_dlp' && sub_auto=" --write-auto-subs" || sub_auto=" --write-auto-sub" 
                else
                    sub_auto=''
                    # youtube-dl --list-subs --simulate $1 | awk '/automatic/,EOF'
                    # $yt_dl --list-subs --simulate $1 | awk '/automatic/{flag=1;next}/\[info\]/{flag=0}flag'
                fi
            fi
            "$yt_dl" -c -i -R 20 $format $sub $sub_auto "$1" ;
        else
            echo "Give up a url, big guy. Know you can do it xoxox" ;
        fi
    }

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
fi
