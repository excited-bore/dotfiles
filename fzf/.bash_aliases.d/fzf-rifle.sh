#~/.fzf/shell/vid_viewer.sh

if [ ! -f ~/.fdignore ]; then
   touch ~/.fdignore             
fi

if [ ! -f ~/.fzf_history ]; then
    touch ~/.fzf_history 
fi

#if ! type print-path-to-prompt &> /dev/null; then
function print-path-to-prompt(){
    lines="n"
    while getopts ':l' flag; do
        case "${flag}" in
            l)  lines="y"
                shift 
                ;;
        esac
    done && OPTIND=1;
    fls=$(echo "$@" | sed 's| |\\ |g' | sed 's|\[|\\\[|g' | sed 's|\]|\\\]|g' | sed 's|(|\\(|g' | sed 's|)|\\)|g' | sed 's|{|\\{|g' | sed 's|}|\\}|g')
    if test $lines == 'n'; then
        fls="$(echo $fls | tr "\n" ' ')"
#    else
#        fls="$(echo $fls | tr "\n" "/ \n")"
    fi
    READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$fls${READLINE_LINE:$READLINE_POINT}"
    READLINE_POINT=$(( READLINE_POINT + ${#fls} ))
    unset lines fls 
}
#fi

fzf_rifle(){
    #EXTERNAL_COLUMNS=$COLUMNS
    #file="$(fzf -m --height 66% --reverse --preview='
    #if file --mime-type {} | grep -qF image/; then
    #    kitten icat --clear  --stdin=no --transfer-mode=memory --place="$COLUMNS"x"$LINES"@"$(($EXTERNAL_COLUMNS-$COLUMNS))"x0 --stdin=no {} > /dev/tty;
    #else
    #    bat --color=always --style numbers {} && printf "\x1b_Ga=d,d=A\x1b\\";
    #fi;' --preview-window 'right,50%,border-left')"
    ##--bind 'ctrl-t:change-preview-window(down|hidden|)'\
    local file
    INITIAL_QUERY="${*:-}"
    #--bind "start:reload:$RG_PREFIX {q}" \
    #--bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
    #--bind='ctrl-g:change-prompt(Append> )+change-header('\''Append stuff\nCTRL+F to go back'\'')+change-preview(printf "\x1b_Ga=d,d=A\x1b\\"; bat --color=always {1} --highlight-line {2})"' \
    local fle="$(fzf -m --reverse --height 100% --query "$INITIAL_QUERY" --ansi  --header-first --history="$HOME/.fzf_history" --preview='size=$(kitten icat --print-window-size {})
        t_mode="memory"
        [[ -n "$SSH_TTY" ]] && t_mode="stream"    
        x_img=$(($(echo $size | cut -d"x" -f 1) / $COLUMNS)); y_img=$(($(echo $size | cut -d"x" -f 2) / "$LINES"));
        x_img=$((($FZF_PREVIEW_COLUMNS*$x_img/100)*4)); y_img=$((($FZF_PREVIEW_LINES*$y_img/100)*4));
    if file --mime-type {} | grep -qF image/; then 
        kitten icat --clear --transfer-mode=${t_mode} --place=${x_img}x${y_img}@125x1 --stdin=no {} > /dev/tty; 
    elif file --mime-type {} | grep -q video/; then
        TMP_DIR="/tmp/.vidthumbs.$(tr -dc A-Za-z0-9 </dev/urandom | head -c6)";
        mkdir -- "$TMP_DIR" >&2;
        ffmpegthumbnailer -i {} -s 256 -o "$TMP_DIR/$(basename {}).jpg" 2>/dev/null;
        kitten icat --clear --transfer-mode=${t_mode} --scale-up --place=${x_img}x${y_img}@125x1 --stdin=no "$TMP_DIR" > /dev/tty;
        $(rm -rf -- "$TMP_DIR" 2>/dev/null);
    else 
        printf "\x1b_Ga=d,d=A\x1b\\"; 
        bat --color always --style numbers --line-range :200 {};
    fi;' \
    --prompt="Files> " \
    --header=$'Each file can get opened using rifle\nCTRL-G choose wich file to append to' \
    --preview-window='right,50%,border-left' \
    --bind=$'ctrl-f:reload:$FZF_DEFAULT_COMMAND+change-prompt(Files> )+change-header('$'Each file can get opened using rifle\nChoose a file and append to it using CTRL-G'')+change-preview(size=$(kitten icat --print-window-size {});     
        t_mode="memory";
        [[ -n "$SSH_TTY" ]] && t_mode="stream";   
        x_img=$(($(echo $size | cut -d"x" -f 1) / "$COLUMNS")); y_img=$(($(echo $size | cut -d"x" -f 2) / "$LINES"));
        x_img=$((($FZF_PREVIEW_COLUMNS*$x_img/100)*4)); y_img=$((($FZF_PREVIEW_LINES*$y_img/100)*4));
    if file --mime-type {} | grep -qF image/; then 
        kitten icat --clear --transfer-mode=${t_mode} --place=${x_img}x${y_img}@125x1 --stdin=no {} > /dev/tty; 
    elif file --mime-type {} | grep -q video/; then
        TMP_DIR="/tmp/.vidthumbs.$(tr -dc A-Za-z0-9 </dev/urandom | head -c6)";
        mkdir -- "$TMP_DIR" >&2;
        ffmpegthumbnailer -i {} -s 256 -o "$TMP_DIR/$(basename {}).jpg" 2>/dev/null;
        kitten icat --clear --transfer-mode=${t_mode} --scale-up --place=${x_img}x${y_img}@125x1 --stdin=no "$TMP_DIR" > /dev/tty;
        $(rm -rf -- "$TMP_DIR" 2>/dev/null);
    else 
        printf "\x1b_Ga=d,d=A\x1b\\"; 
        bat --color always --style numbers --line-range :200 {};
    fi;')";
    #--bind 'focus:transform-preview-label:file --brief {}'
    if [ -z "$fle" ]; then
        return 0;
    else
        lines="$(echo "$fle" | wc -l)";
        if [ "$lines" == 1 ]; then
            if [ -d "$fle" ]; then
                result=$(printf "0:change directory \n1:Use rifle" | fzf --height 30% --reverse) 
                if [ "${result::1}" == "0" ]; then
                    cd "$fle";
                    return 0;
                fi
            else
                opts=$(rifle -l "$fle")
                result="$(printf "Put item in prompt\n$opts" | fzf --height 50% --reverse)";
                if test "$result" == 'Put item in prompt'; then
                    print-path-to-prompt "$fle" 
                else
                    rifle -p ${result::1} "$fle";
                fi
                return 0;
            fi
        else
            #IFS=$'\n' read -d "\034" -r -a files <<<"${fle}\034";
            for i in ${fle[@]}; do
                opts="$(rifle -l "$i")"
                result="$(printf "Put items in prompt (lines)\nPut items in prompt (words)\n$opts" | fzf --height 50% --reverse)";
                if test "$result" == 'Put items in prompt (lines)'; then
                    print-path-to-prompt -l "$i"   
                elif test "$result" == 'Put items in prompt (words)'; then 
                    print-path-to-prompt "$i" 
                else
                    rifle -p ${result::1} $i;
                fi
                return 0;
            done
        fi    
    fi
    unset fle 
}
