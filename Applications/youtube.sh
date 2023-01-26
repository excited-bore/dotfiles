alias check_songs='serber "cd /mnt/MyStuff/Files/Audio/ && ls | xargs -0"'
alias check_youtubes='serber "cd /mnt/MyStuff/Files/Videos/YouTubes/ && ls | xargs -0 "'

function youtube(){
    if [ ! -z "$1" ]; then                                
        youtube-dl -c -i -R 20  --write-sub --yes-playlist "$1" ;
    else
        echo "Give up a url, big guy. Know you can do it xoxox" ;
    fi
}

function youtube_dir(){
    if [ ! -z "$1" ] && [ ! -z "$2" ]; then                                
        mkdir "$2";
        cd "$2";
        youtube-dl -c -i -R 20  --write-sub --yes-playlist "$1" ;
    else
        echo "Give up a url and a dir, big guy. Know you can do it xoxox" ;
    fi
}
# Numbered tracks => -o "%(playlist)s\%(playlist_index)s - %(title)s.%(ext)s"

function youtube_playList(){
    start=" "
    end=" " 
    if [ ! -z "$2" ]; then
        start=" --playlist-start $2";
    fi
    if [ ! -z "$3" ]; then
        end=" --playlist-end $3";
    fi    
    if [ ! -z "$1" ]; then                                
        youtube-dl -c -i -R 20 -o "%(playlist)s\%(playlist_index)s - %(title)s.%(ext)s" --write-sub --yes-playlist "$1" $start $end;
    else
        echo "Give up a url, big guy. Know you can do it xoxox" ;
    fi
}

function youtube_playList_onlyAudio(){
    start=" "
    end=" " 
    if [ ! -z "$3" ]; then
        start=" --playlist-start $3";
    fi
    if [ ! -z "$4" ]; then
        end=" --playlist-end $4";
    fi
    if [ ! -z "$1" ]; then    
        if [ ! -z "$2" ]; then
            youtube-dl -c -i -R 20 -o "%(playlist)s\%(playlist_index)s - %(title)s.%(ext)s" -x --audio-format $2 --write-sub --yes-playlist "$1" $start $end;
        else 
            youtube-dl -c -i -R 20 -o "%(playlist)s\%(playlist_index)s - %(title)s.%(ext)s" -x --audio-format mp3 --write-sub --yes-playlist "$1" $start $end;
        fi
    else
        echo "Give up a url, big guy. Know you can do it xoxox" ;
    fi
}

function youtube_playList_dir(){
    start=" "
    end=" " 
    if [ ! -z "$3" ]; then
        start=" --playlist-start $3";
    fi
    if [ ! -z "$4" ]; then
        end=" --playlist-end $4";
    fi
    if [ ! -z "$1" ] && [ ! -z "$2" ]; then
        mkdir "$2";
        cd "$2"; 
        youtube-dl -c -i -R 20 -o "%(playlist)s\%(playlist_index)s - %(title)s.%(ext)s" --write-sub --yes-playlist "$1" $start $end ; 
    else
        echo "Give up a url and dir, big guy. Know you can do it xoxox" ;
    fi
}

function youtube_playList_onlyAudio_dir(){
    start=" "
    end=" " 
    if [ ! -z "$3" ]; then
        start="--playlist-start $3";
    fi
    if [ ! -z "$4" ]; then
        end=" --playlist-end $4";
    fi
    if [ -z "$1"] || [ -z "$2" ]; then
        echo "Give up a url and a dir, big guy. Know you can do it xoxox";
    else
        mkdir "$2";
        cd "$2";    
        if [ ! -z "$3" ]; then
            youtube-dl -c -i -R 20 -o "%(playlist)s\%(playlist_index)s - %(title)s.%(ext)s" -x --audio-format $3 --write-sub --yes-playlist "$1" $start $end ;
        else 
            youtube-dl -c -i -R 20 -o "%(playlist)s\%(playlist_index)s - %(title)s.%(ext)s" -x --audio-format mp3 --write-sub --yes-playlist "$1" $start $end;
        fi
    fi
}
