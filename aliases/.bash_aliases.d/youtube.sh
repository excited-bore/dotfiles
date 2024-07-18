if [ ! -f ~/.bash_aliases.d/rlwrap_scripts.sh ]; then
    . ../aliases/rlwrap_scripts.sh
else
    . ~/.bash_aliases.d/rlwrap_scripts.sh
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
            "$yt_dl" -c -i -R 20  --write-sub --yes-playlist "$1" ;
        else
            echo "Give up a url, big guy. Know you can do it xoxox" ;
        fi
    }

    function yt-dl-dir(){
        if [ ! -z "$1" ] && [ ! -z "$2" ]; then                                
            mkdir "$2";
            cd "$2";
            "$yt_dl" -c -i -R 20  --write-sub --yes-playlist "$1" ;
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
            reade -Q "green" -i "y" -p "Make directory using playlist name and put songs in said dir? [Y/n]: " "n" plst_dir
            if test "$plst_dir" == "y"; then
                "$yt_dl" -c -i -R 20 -o "%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s" --write-sub --yes-playlist "$1" "$start" "$end";
            else
                "$yt_dl" -c -i -R 20 -o "%(playlist_index)s - %(title)s.%(ext)s" --write-sub --yes-playlist "$1" "$start" "$end";
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
            reade -Q "green" -p "Name directory? (default - playlist name)" "" plst_name
            if test "$plst_name" == ""; then
                "$yt_dl" -c -i -R 20 -o "%(playlist)s\%(playlist_index)s - %(title)s.%(ext)s" --write-sub --yes-playlist "$1" "$start" "$end" ; 
            else
                (cd "$plst_name"
                "$yt_dl" -c -i -R 20 -o "%(playlist_index)s - %(title)s.%(ext)s" -x $aud_format --write-sub --yes-playlist "$1" "$start" "$end")
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
