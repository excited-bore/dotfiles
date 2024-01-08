#~/.fzf/shell/vid_viewer.sh

fzf_rifle(){
    #EXTERNAL_COLUMNS=$COLUMNS
    #file="$(fzf -m --height 66% --reverse --preview='
    #if file --mime-type {} | grep -qF image/; then
    #    kitten icat --clear  --stdin=no --transfer-mode=memory --place="$COLUMNS"x"$LINES"@"$(($EXTERNAL_COLUMNS-$COLUMNS))"x0 --stdin=no {} > /dev/tty;
    #else
    #    bat --color=always --style numbers {} && printf "\x1b_Ga=d,d=A\x1b\\";
    #fi;' --preview-window 'right,50%,border-left')"
    ##--bind 'ctrl-t:change-preview-window(down|hidden|)'\
    fle=$(EXTERNAL_COLUMNS=$COLUMNS fzf -m --reverse --height 100% \
    --preview='
        size=$(kitten icat --print-window-size {})
        x_img=$(($(echo $size | cut -d"x" -f 1) / $COLUMNS)); y_img=$(($(echo $size | cut -d"x" -f 2) / $LINES));
        x_img=$((($FZF_PREVIEW_COLUMNS*$x_img/100)*4)); y_img=$((($FZF_PREVIEW_LINES*$y_img/100)*4))
        #echo $FZF_PREVIEW_COLUMNS; echo $FZF_PREVIEW_LINES
        #echo ${x_img}x${y_img}
    if file --mime-type {} | grep -qF image/; then 
        kitten icat --clear --transfer-mode=memory --place=${x_img}x${y_img}@125x1 --stdin=no {} > /dev/tty; 
    elif file --mime-type {} | grep -q video/; then
        TMP_DIR="/tmp/.vidthumbs.$(tr -dc A-Za-z0-9 </dev/urandom | head -c6)"
        mkdir -- "$TMP_DIR" >&2
        ffmpegthumbnailer -i {} -s 256 -o "$TMP_DIR/$(basename {}).jpg" 2>/dev/null
        kitten icat --clear --transfer-mode=memory --scale-up --place=${x_img}x${y_img}@125x1 --stdin=no "$TMP_DIR" > /dev/tty;
        $(rm -rf -- "$TMP_DIR" 2>/dev/null)
    else 
        printf "\x1b_Ga=d,d=A\x1b\\"; 
        bat --color always --style numbers --line-range :200 {}
        fi;'\
    --preview-window "right,50%,border-left")
    #echo $fle
    if [ -z "$fle" ]; then
        return 0;
    else
        lines="$(echo "$fle" | wc -l)";
        if [ "$lines" == 1 ]; then
            if [ -d "$fle" ]; then
                result=$(printf "0:change directory \n1:Use rifle" | fzf --height 30% --reverse $FZF_CTRL_T_OPTS) 
                if [ "${result::1}" == "0" ]; then
                    cd "$fle";
                    return 0;
                fi
            else
                result=$(rifle -l "$fle" | fzf --height 50% --reverse "$FZF_CTRL_T_OPTS");
                rifle -p "${result::1}" "$fle";
                return 0;
            fi
        else
            IFS=$'\n' read -d "\034" -r -a files <<<"${fle}\034";
            result=$(rifle -l "$files" | fzf --height 50% --reverse );
            rifle -p "${result::1}" "${files[@]}"
            return 0;
        fi    
    fi
}
